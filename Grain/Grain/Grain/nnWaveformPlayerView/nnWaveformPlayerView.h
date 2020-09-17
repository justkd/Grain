//
//  nnWaveformPlayerView.h
//
//  Created by Cady Holmes on 9/11/15.
//  Copyright © 2015-present Cady Holmes. All rights reserved.
//


//  Extended from:
//  SYWaveformPlayerView.h
//  SCWaveformView
//
//  Created by Spencer Yen on 12/26/14.
//  Copyright (c) 2014 Simon CORSIN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "SCWaveformView.h"
#import "DFContinuousForceTouchGestureRecognizer.h"

@protocol nnWaveformPlayerViewDelegate;
@interface nnWaveformPlayerView : UIView <AVAudioPlayerDelegate, UIGestureRecognizerDelegate, DFContinuousForceTouchDelegate>

@property (nonatomic, weak) id<nnWaveformPlayerViewDelegate> delegate;
@property (nonatomic, strong) SCWaveformView *waveformView;
@property (nonatomic, strong) AVAudioPlayer *player;
@property (nonatomic) BOOL loops;

- (id)initWithFrame:(CGRect)frame asset:(AVURLAsset *)asset color:(UIColor *)normalColor progressColor:(UIColor *)progressColor;
- (void)updateWaveform:(id)sender;

@end

@protocol nnWaveformPlayerViewDelegate <NSObject>
- (void)progressDidChange:(nnWaveformPlayerView *)player;
- (void)didReceiveTouch:(UIGestureRecognizer *)sender;
- (void)didStartPlaying:(nnWaveformPlayerView *)player;
- (void)didPausePlaying:(nnWaveformPlayerView *)player;
- (void)ftRecognized:(nnWaveformPlayerView *)player;
- (void)ftDidStart:(nnWaveformPlayerView *)player withForce:(CGFloat)force maxForce:(CGFloat)maxForce;
- (void)ftDidCancel:(nnWaveformPlayerView *)player withForce:(CGFloat)force maxForce:(CGFloat)maxForce;
- (void)ftDidEnd:(nnWaveformPlayerView *)player withForce:(CGFloat)force maxForce:(CGFloat)maxForce;
- (void)ftDidMove:(nnWaveformPlayerView *)player withForce:(CGFloat)force maxForce:(CGFloat)maxForce;
- (void)ftDidTimeout:(nnWaveformPlayerView *)player;
@end
