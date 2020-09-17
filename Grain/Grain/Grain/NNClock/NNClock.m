//
//  NNClock.m
//
//  Created by Cady Holmes on 6/5/15.
//  Copyright (c) 2015-present Cady Holmes. All rights reserved.
//

#import "NNClock.h"

@implementation NNClock

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialSetup];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [self drawUI];
}

- (void)initialSetup {
    self.isDark = NO;
    self.backgroundColor = [UIColor clearColor];
    [self addGestures];
}

- (void)addGestures {
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTap.numberOfTapsRequired = 2;

    [self addGestureRecognizer:singleTap];
    [self addGestureRecognizer:doubleTap];
}

- (void)drawUI {
    label = [[UILabel alloc] initWithFrame:self.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:self.frame.size.width/6]];
    label.alpha = 0;
    label.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0, 0);
    [self addSubview:label];
    
    clock = [[UIImageView alloc] initWithFrame:self.bounds];
    clock.contentMode = UIViewContentModeScaleAspectFit;
    if (self.isDark) {
        clock.image = [UIImage imageNamed:@"clock_black.pdf"];
        label.textColor = [UIColor colorWithRed:23/255. green:23/255. blue:23/255. alpha:1];
    } else {
        clock.image = [UIImage imageNamed:@"clock_offwhite.pdf"];
        label.textColor = [UIColor colorWithRed:218/255. green:234/255. blue:239/255. alpha:1];
    }
    clock = [self resizeImageView:clock inViewBounds:self.bounds withRatio:.8];
    [self addSubview:clock];
}

- (void)handleSingleTap:(id)sender {
    if (!isTimerOn) {
        isTimerOn = YES;
        [self animateViewShrinkToNothing:clock];
        [self animateViewToNormalSize:label];
        [self animateViewAlpha:clock to:0];
        [self animateViewAlpha:label to:1];
    }
    [self resetTimer];
}

- (void)handleDoubleTap:(id)sender {
    
    if (isTimerOn) {
        isTimerOn = NO;
        [clockTimer invalidate];
        clockTimer = nil;
        timerSeconds = 0;
        [self animateViewToNormalSize:clock];
        [self animateViewShrinkToNothing:label];
        [self animateViewAlpha:clock to:1];
        [self animateViewAlpha:label to:0];
    }
}

- (void)resetTimer {
    
    [clockTimer invalidate];
    clockTimer = nil;
    
    timerSeconds = 0;
    int minutes = 0;
    int seconds = 0;
    
    clockTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(clockUpdateCallback:) userInfo:nil repeats:YES];
    
    NSString *currentTime = [NSString stringWithFormat:@"%i:%02i", minutes, seconds];
    label.text = currentTime;
    
}

- (void)clockUpdateCallback:(NSTimer *)update {
    
    timerSeconds = timerSeconds + 1;
    int minutes = timerSeconds / 60;
    int seconds = timerSeconds % 60;
    NSString *currentTime = [NSString stringWithFormat:@"%i:%02i", minutes, seconds];
    label.text = currentTime;
}

- (UIImageView *)resizeImageView:(UIImageView *)view inViewBounds:(CGRect)bounds withRatio:(CGFloat)ratio {
    view.bounds = CGRectMake(bounds.size.width*((1-ratio)/2),
                             bounds.size.height*((1-ratio)/2),
                             bounds.size.width*ratio,
                             bounds.size.height*ratio);
    return view;
}

- (void)animateViewShrinkToNothing:(UIView*)view {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:(UIViewAnimationOptionAllowUserInteraction |
                                     UIViewAnimationOptionCurveEaseInOut)
                         animations:^{
                             view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0, 0);
                         }
                         completion:^(BOOL finished) {
                         }];
    });
}

- (void)animateViewToNormalSize:(UIView*)view {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3f
                              delay:0.0f
                            options:(UIViewAnimationOptionAllowUserInteraction |
                                     UIViewAnimationOptionCurveEaseInOut)
                         animations:^{
                             view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.005, 1.005);
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.3f
                                                   delay:0.0f
                                                 options:(UIViewAnimationOptionAllowUserInteraction |
                                                          UIViewAnimationOptionCurveEaseInOut)
                                              animations:^{
                                                  view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                                              }
                                              completion:^(BOOL finished) {
                                              }];
                         }];
    });
}

- (void)animateViewAlpha:(UIView*)view to:(CGFloat)alpha {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3f
                              delay:0.0f
             usingSpringWithDamping:.2f
              initialSpringVelocity:10.f
                            options:(UIViewAnimationOptionAllowUserInteraction |
                                     UIViewAnimationOptionCurveEaseInOut)
                         animations:^{
                             view.alpha = alpha;
                         }
                         completion:^(BOOL finished) {
                         }];
    });
}

@end
