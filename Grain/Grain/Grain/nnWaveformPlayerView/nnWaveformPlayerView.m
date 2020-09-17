//
//  nnWaveformPlayerView.m
//
//  Created by Cady Holmes on 9/11/15.
//  Copyright © 2015-present Cady Holmes. All rights reserved.
//

#import "nnWaveformPlayerView.h"

@implementation nnWaveformPlayerView

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return YES;
}

- (UIViewController *)currentTopViewController {
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

- (id)initWithFrame:(CGRect)frame asset:(AVURLAsset *)asset color:(UIColor *)normalColor progressColor:(UIColor *)progressColor {
    if (self = [super initWithFrame:frame]) {
        
        self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:asset.URL error:nil];
        self.player.delegate = self;
        
        self.waveformView = [[SCWaveformView alloc] init];
        self.waveformView.normalColor = normalColor;
        self.waveformView.progressColor = progressColor;
        self.waveformView.alpha = 0.8;
        self.waveformView.backgroundColor = [UIColor clearColor];
        self.waveformView.asset = asset;
        
        UILongPressGestureRecognizer *lp = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [lp setMinimumPressDuration:0.000000001];
        [self addGestureRecognizer:lp];
        [lp setDelegate:self];
        
        UIViewController *currentTopVC = [self currentTopViewController];
        if ([[currentTopVC.view traitCollection] forceTouchCapability] == UIForceTouchCapabilityAvailable) {
            DFContinuousForceTouchGestureRecognizer* forceTouchRecognizer = [[DFContinuousForceTouchGestureRecognizer alloc] init];
            forceTouchRecognizer.forceTouchDelegate = self;
            [self addGestureRecognizer:forceTouchRecognizer];
        }
        
        [self addSubview:self.waveformView];
        
        //[self.player setVolume:0];
        //[self.player play];
        
        [NSTimer scheduledTimerWithTimeInterval:0.1 target: self
                                       selector: @selector(updateWaveform:) userInfo: nil repeats: YES];
        
    }
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.waveformView.frame = CGRectMake(10, 0, self.frame.size.width - 20, self.frame.size.height);
}

- (void)longPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        [self pause];
    } else if (sender.state == UIGestureRecognizerStateCancelled | sender.state == UIGestureRecognizerStateEnded) {
        NSTimeInterval newTime = self.waveformView.progress * self.player.duration;
        self.player.currentTime = newTime;
        [self play];
    }
    
    CGPoint location = [sender locationInView:self];
    
    if(location.x/self.frame.size.width > 0) {
        self.waveformView.progress = location.x/self.frame.size.width;
        self.waveformView.progress = MAX(0, MIN(1.0, self.waveformView.progress));
        
        //NSLog(@"%f %f",location.x, self.waveformView.progress);
        id<nnWaveformPlayerViewDelegate> strongDelegate = self.delegate;
        if ([strongDelegate respondsToSelector:@selector(didReceiveTouch:)]) {
            [strongDelegate didReceiveTouch:sender];
        }
    }
}

/*
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self touchesMoved:touches withEvent:event];
    [self pause];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [[event allTouches]anyObject];
    CGPoint location = [touch locationInView:self];
    
    if(location.x/self.frame.size.width > 0) {
        self.waveformView.progress = location.x/self.frame.size.width;
        self.waveformView.progress = MAX(0, MIN(1.0, self.waveformView.progress));
        
        //NSLog(@"%f %f",location.x, self.waveformView.progress);
        
        id<nnWaveformPlayerViewDelegate> strongDelegate = self.delegate;
        if ([strongDelegate respondsToSelector:@selector(progressDidChange:)]) {
            [strongDelegate progressDidChange:self];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    NSTimeInterval newTime = self.waveformView.progress * self.player.duration;
    self.player.currentTime = newTime;
    [self play];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    NSTimeInterval newTime = self.waveformView.progress * self.player.duration;
    self.player.currentTime = newTime;
    [self play];
}
*/

- (void)play {
    [self.player play];
    id<nnWaveformPlayerViewDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(didStartPlaying:)]) {
        [strongDelegate didStartPlaying:self];
    }
}

- (void)pause {
    [self.player pause];
    id<nnWaveformPlayerViewDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(didPausePlaying:)]) {
        [strongDelegate didPausePlaying:self];
    }
}

- (void)updateWaveform:(id)sender {
    if(self.player.playing) {
        self.waveformView.progress = self.player.currentTime/self.player.duration;
    }
    
    id<nnWaveformPlayerViewDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(progressDidChange:)]) {
        [strongDelegate progressDidChange:self];
    }
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player
                       successfully:(BOOL)flag {
    if (self.loops) {
        [self.player stop];
        [self.player prepareToPlay];
        [self.player play];
    }
}

#pragma DFContinuousForceTouchDelegate

- (void) forceTouchRecognized:(DFContinuousForceTouchGestureRecognizer*)recognizer {
    id<nnWaveformPlayerViewDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(ftRecognized:)]) {
        [strongDelegate ftRecognized:self];
    }
}

- (void) forceTouchRecognizer:(DFContinuousForceTouchGestureRecognizer*)recognizer didStartWithForce:(CGFloat)force maxForce:(CGFloat)maxForce {
    id<nnWaveformPlayerViewDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(ftDidStart:withForce:maxForce:)]) {
        [strongDelegate ftDidStart:self withForce:force maxForce:maxForce];
    }
    //NSLog(@"%ld, %f",recognizer.view.tag,force);
}

- (void) forceTouchRecognizer:(DFContinuousForceTouchGestureRecognizer*)recognizer didMoveWithForce:(CGFloat)force maxForce:(CGFloat)maxForce {
    id<nnWaveformPlayerViewDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(ftDidMove:withForce:maxForce:)]) {
        [strongDelegate ftDidMove:self withForce:force maxForce:maxForce];
    }
    //NSLog(@"%ld, %f",recognizer.view.tag,force);
}

- (void) forceTouchRecognizer:(DFContinuousForceTouchGestureRecognizer*)recognizer didCancelWithForce:(CGFloat)force maxForce:(CGFloat)maxForce {
    id<nnWaveformPlayerViewDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(ftDidCancel:withForce:maxForce:)]) {
        [strongDelegate ftDidCancel:self withForce:force maxForce:maxForce];
    }
}

- (void) forceTouchRecognizer:(DFContinuousForceTouchGestureRecognizer*)recognizer didEndWithForce:(CGFloat)force maxForce:(CGFloat)maxForce {
    id<nnWaveformPlayerViewDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(ftDidEnd:withForce:maxForce:)]) {
        [strongDelegate ftDidEnd:self withForce:force maxForce:maxForce];
    }
}

- (void) forceTouchDidTimeout:(DFContinuousForceTouchGestureRecognizer*)recognizer {
    id<nnWaveformPlayerViewDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(ftDidTimeout:)]) {
        [strongDelegate ftDidTimeout:self];
    }
}
@end
