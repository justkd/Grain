//
//  nnAudioConverter.m
//
//  Created by Cady Holmes on 9/1/15.
//  Copyright © 2015-present Cady Holmes. All rights reserved.
//

#import "nnAudioConverter.h"

@implementation nnAudioConverter

+ (nnAudioConverter *)initWithID:(int)ID {
    nnAudioConverter *converter = [[nnAudioConverter alloc] init];
    converter.ID = [NSString stringWithFormat:@"%d",ID];
    
    return converter;
}

- (id)initWithFontSize:(CGFloat)size andOrigin:(CGPoint)origin andID:(int)ID {
    self.ID = [NSString stringWithFormat:@"%d",ID];
    CGRect rect = CGRectMake(origin.x, origin.y, size*3, size*2.5);
    
    if ((self = [super initWithFrame:rect])) {
        
        self.label = [[UILabel alloc] initWithFrame:self.frame];
        [self.label setTextAlignment:NSTextAlignmentCenter];
        [self.label setText:@"%"];
        //[self.label setBackgroundColor:[UIColor blueColor]];
        //[self.label setUserInteractionEnabled:NO];
        [self addSubview:self.label];
    }
    return self;
}

- (void)convertToWavFromFilePathInBackground:(NSURL *)assetURL {
    id<nnAudioConverterDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(audioConverterDidStart:)]) {
        [strongDelegate audioConverterDidStart:self];
    }
    
    [NSThread detachNewThreadSelector:@selector(convertToWavFromFilePath:) toTarget:self withObject:assetURL];
}

- (void)convertToWavFromFilePath:(NSURL *)assetURL {

    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:assetURL options:nil];
    
    NSError *assetError = nil;
    AVAssetReader *assetReader = [AVAssetReader assetReaderWithAsset:songAsset
                                                               error:&assetError];
    if (assetError) {
        NSLog (@"error: %@", assetError);
        return;
    }
    
    AVAssetReaderOutput *assetReaderOutput = [AVAssetReaderAudioMixOutput
                                              assetReaderAudioMixOutputWithAudioTracks:songAsset.tracks
                                              audioSettings: nil];
    
    if (! [assetReader canAddOutput: assetReaderOutput]) {
        NSLog (@"can't add reader output... die!");
        return;
    }
    
    [assetReader addOutput: assetReaderOutput];
    
    NSString *title = [NSString stringWithFormat:@"player%@",self.ID];
    NSArray *docDirs = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [docDirs objectAtIndex: 0];
    NSString *wavFilePath = [[docDir stringByAppendingPathComponent :title]
                                      stringByAppendingPathExtension:@"wav"];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:wavFilePath]) {
        [[NSFileManager defaultManager] removeItemAtPath:wavFilePath error:nil];
    }
    
    NSURL *exportURL = [NSURL fileURLWithPath:wavFilePath];
    AVAssetWriter *assetWriter = [AVAssetWriter assetWriterWithURL:exportURL
                                                          fileType:AVFileTypeWAVE
                                                             error:&assetError];
    
    if (assetError) {
        NSLog (@"error: %@", assetError);
        return;
    }
    
    AudioChannelLayout channelLayout;
    memset(&channelLayout, 0, sizeof(AudioChannelLayout));
    channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo;
    NSDictionary *outputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                    [NSNumber numberWithFloat:44100.0], AVSampleRateKey,
                                    [NSNumber numberWithInt:2], AVNumberOfChannelsKey,
                                    [NSData dataWithBytes:&channelLayout length:sizeof(AudioChannelLayout)], AVChannelLayoutKey,
                                    [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                    [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                    [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                    [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                                    nil];
    AVAssetWriterInput *assetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio
                                                                              outputSettings:outputSettings];
    
    if ([assetWriter canAddInput:assetWriterInput]) {
        [assetWriter addInput:assetWriterInput];
    }
    else {
        NSLog (@"can't add asset writer input... die!");
        return;
    }
    
    assetWriterInput.expectsMediaDataInRealTime = NO;
    
    [assetWriter startWriting];
    [assetReader startReading];
    
    AVAssetTrack *soundTrack = [songAsset.tracks objectAtIndex:0];
    CMTime startTime = CMTimeMake (0, soundTrack.naturalTimeScale);
    [assetWriter startSessionAtSourceTime: startTime];
    
    __block UInt64 convertedByteCount = 0;
    dispatch_queue_t mediaInputQueue = dispatch_queue_create("mediaInputQueue", NULL);

    [assetWriterInput requestMediaDataWhenReadyOnQueue:mediaInputQueue
                                            usingBlock: ^ {
                                                
        while (assetWriterInput.readyForMoreMediaData) {
            
             CMSampleBufferRef nextBuffer = [assetReaderOutput copyNextSampleBuffer];
            
             if (nextBuffer) {
                 [assetWriterInput appendSampleBuffer: nextBuffer];
                 convertedByteCount += CMSampleBufferGetTotalSampleSize (nextBuffer);
                 CMTime progressTime = CMSampleBufferGetPresentationTimeStamp(nextBuffer);
                 
                 CMTime sampleDuration = CMSampleBufferGetDuration(nextBuffer);
                 if (CMTIME_IS_NUMERIC(sampleDuration))
                     progressTime= CMTimeAdd(progressTime, sampleDuration);
                 float dProgress= CMTimeGetSeconds(progressTime) / CMTimeGetSeconds(songAsset.duration);
                 float percent = dProgress*100;
                 //NSLog(@"%f",dProgress);
                 
                 [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                     self.label.text = [NSString stringWithFormat:@"%.0f%%",percent];
                     self.percentFinished = percent;
                     
                     id<nnAudioConverterDelegate> strongDelegate = self.delegate;
                     if ([strongDelegate respondsToSelector:@selector(loadPercentageUpdated:)]) {
                         [strongDelegate loadPercentageUpdated:self.percentFinished];
                     }
                 }];
                 
                 // SUPER IMPORTANT - re-assigning "nextBuffer" each time around doesn't actually release the old buffer
                 // without this manual release, the buffer writing process causes a memory leak
                 CMSampleBufferInvalidate(nextBuffer);
                 CFRelease(nextBuffer);
                 nextBuffer = nil;
             }
             else { 
                 [assetWriterInput markAsFinished];
                 [assetReader cancelReading];
                 [assetWriter finishWritingWithCompletionHandler: ^ {
                     self.urlString = wavFilePath;
                     
                     id<nnAudioConverterDelegate> strongDelegate = self.delegate;
                     if ([strongDelegate respondsToSelector:@selector(audioConverterDidFinish:)]) {
                         [strongDelegate audioConverterDidFinish:self];
                     }
                 }];
             }
         }
    }];
}

@end
