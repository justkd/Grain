//
//  nnSongPicker.h
//
//  Created by Cady Holmes on 9/4/15.
//  Copyright © 2015-present Cady Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "nnAudioConverter.h"

@protocol nnSongPickerDelegate;
@interface nnSongPicker : UIView <MPMediaPickerControllerDelegate, nnAudioConverterDelegate>

@property (nonatomic, weak) id<nnSongPickerDelegate> delegate;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) MPMediaItem *song;
@property (nonatomic, strong) nnAudioConverter *converter;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *songURL;
@property (nonatomic) float conversionPercent;

- (id)initWithFontSize:(CGFloat)size andOrigin:(CGPoint)origin andID:(int)ID;
+ (nnSongPicker *)initWithID:(int)ID;
- (void)openLibrary;

@end

@protocol nnSongPickerDelegate <NSObject>
- (void)songPickerDidFinish:(nnSongPicker *)picker;
- (void)songPickerDidCancel:(nnSongPicker *)picker;
- (void)songPickerShouldStartConverting:(nnSongPicker *)picker;
- (void)songPickerDidStartConverting:(nnSongPicker *)picker;
- (void)songPickerIsConverting:(nnSongPicker *)picker;

@end
