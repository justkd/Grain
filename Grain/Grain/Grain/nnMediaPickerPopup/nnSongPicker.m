//
//  nnSongPicker.m
//
//  Created by Cady Holmes on 9/4/15.
//  Copyright © 2015-present Cady Holmes. All rights reserved.
//

#import "nnSongPicker.h"

@implementation nnSongPicker

+ (nnSongPicker *)initWithID:(int)ID {
    
    nnSongPicker *picker = [[nnSongPicker alloc] init];
    picker.ID = [NSString stringWithFormat:@"%d",ID];
    picker.converter = [nnAudioConverter initWithID:ID];
    picker.converter.delegate = picker;
    
    return picker;
}

- (id)initWithFontSize:(CGFloat)size andOrigin:(CGPoint)origin andID:(int)ID {
    self.ID = [NSString stringWithFormat:@"%d",ID];
    CGRect rect = CGRectMake(origin.x, origin.y, size*9, size*2.5);
    
    if ((self = [super initWithFrame:rect])) {
        
        self.button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        self.button.frame = CGRectMake(0, 0, size*6, self.frame.size.height);
        [self.button setTitle:@"Pick Song" forState:UIControlStateNormal];
        self.button.titleLabel.font = [UIFont fontWithName:@"Georgia" size:size];
        
        [self.button addTarget:self action:@selector(openLibrary) forControlEvents:UIControlEventTouchUpInside];
        //[self.button setBackgroundColor:[UIColor redColor]];
        [self addSubview:self.button];
        
        CGPoint labelOrigin = CGPointMake(0, 0);
        self.converter = [[nnAudioConverter alloc] initWithFontSize:size andOrigin:labelOrigin andID:ID];
        self.converter.delegate = self;
        self.converter.center = CGPointMake(self.button.center.x+((self.button.frame.size.width/2)+(self.converter.frame.size.width/2)), self.button.center.y);
        [self addSubview:self.converter];
        
        //[self setBackgroundColor:[UIColor greenColor]];
        
    }
    return self;
}

- (void)openLibrary {
    
    MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAny];
    
    mediaPicker.delegate = self;
    mediaPicker.allowsPickingMultipleItems   = NO;
    mediaPicker.showsCloudItems = NO;
    mediaPicker.prompt = @"Only songs downloaded to your device will be shown.";
    
    UIViewController *currentTopVC = [self currentTopViewController];
    [currentTopVC presentViewController:mediaPicker animated:YES completion:nil];
}

- (void)mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection {
    id<nnSongPickerDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(songPickerShouldStartConverting:)]) {
        [strongDelegate songPickerShouldStartConverting:self];
    }
    
    NSArray *selectedSong = [mediaItemCollection items];
    if (mediaItemCollection) {
        
        self.song = [selectedSong objectAtIndex:0];
        
        if (self.song.playbackDuration > 480) {
            float min = self.song.playbackDuration / 60;
            UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"This is a long song..."
                                                             message:[NSString stringWithFormat:@"Song length: %.2f minutes.\nYour selection is long and may cause memory issues. We'll let it slide, but we have to truncate the song to 8 minutes.",min]
                                                            delegate:self
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles: nil];
            [alert show];
        }
        if (self.song.assetURL) {
            
            NSURL *url = [self.song valueForProperty:MPMediaItemPropertyAssetURL];
            //NSLog(@"%@",url);
            
            //[self.converter convertToWavFromFilePathInBackground:url];
            [self.converter convertToWavFromFilePath:url];
            
            UIViewController *currentTopVC = [self currentTopViewController];
            [currentTopVC dismissViewControllerAnimated:YES completion:nil];
            //[currentTopVC.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {
    
    id<nnSongPickerDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(songPickerDidCancel:)]) {
        [strongDelegate songPickerDidCancel:self];
    }
    
    UIViewController *currentTopVC = [self currentTopViewController];
    [currentTopVC dismissViewControllerAnimated:YES completion:nil];
    //[currentTopVC.navigationController popViewControllerAnimated:YES];
}

- (UIViewController *)currentTopViewController {
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

#pragma mark - nnAudioConverter delegate
- (void)audioConverterDidStart:(nnAudioConverter *)converter {
    id<nnSongPickerDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(songPickerDidStartConverting:)]) {
        [strongDelegate songPickerDidStartConverting:self];
    }
}

- (void)audioConverterDidFinish:(nnAudioConverter *)converter {
    self.songURL = self.converter.urlString;
    id<nnSongPickerDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(songPickerDidFinish:)]) {
        [strongDelegate songPickerDidFinish:self];
    }
}

- (void)loadPercentageUpdated:(float)percent {
    self.conversionPercent = percent;
    
    id<nnSongPickerDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(songPickerIsConverting:)]) {
        [strongDelegate songPickerIsConverting:self];
    }
}

@end
