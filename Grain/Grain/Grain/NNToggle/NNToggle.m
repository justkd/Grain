//
//  NNToggle.m
//  NNToggle Tests
//
//  Created by Cady Holmes on 9/18/15.
//  Copyright © 2015-present Cady Holmes. All rights reserved.
//

#import "NNToggle.h"

@implementation NNToggle

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaults];
        [self addTapGesture];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setDefaults];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [self draw];
}

- (void)setDefaults {
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor clearColor];
    self.borderColor = [UIColor colorWithRed:108/255. green:122/255. blue:137/255. alpha:1.];
    self.offColor = [UIColor colorWithRed:218/255. green:224/255. blue:225/255. alpha:1.];
    self.onColor = [UIColor colorWithRed:89/255. green:171/255. blue:227/255. alpha:1.];
    self.borderWidth = 4;
    self.cornerRadius = 8;
    self.isOn = NO;
    self.animatesTap = YES;
}

- (void)draw {
    UIView *containerView = [[UIView alloc] initWithFrame:self.bounds];
    
    UIView *shapeView = [[UIView alloc] initWithFrame:self.bounds];
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.cornerRadius];
    shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = [roundedRect CGPath];
    shapeLayer.drawsAsynchronously = YES;
    shapeLayer.lineWidth = self.borderWidth;
    shapeLayer.strokeColor = self.borderColor.CGColor;
    if (!self.isOn) {
        shapeLayer.fillColor = self.offColor.CGColor;
    } else {
        shapeLayer.fillColor = self.onColor.CGColor;
    }
    [shapeView.layer addSublayer:shapeLayer];
    [containerView addSubview:shapeView];
    
    if (self.image) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        imageView.image = self.image;
        if (self.imageSize) {
            imageView = [self resizeImageView:imageView inViewBounds:self.bounds withRatio:self.imageSize];
        }
        [containerView addSubview:imageView];
    }
    [self addSubview:containerView];
}

- (UIImageView *)resizeImageView:(UIImageView *)view inViewBounds:(CGRect)bounds withRatio:(CGFloat)ratio {
    view.bounds = CGRectMake(bounds.size.width*((1-ratio)/2),
                             bounds.size.height*((1-ratio)/2),
                             bounds.size.width*ratio,
                             bounds.size.height*ratio);
    return view;
}

- (void)addTapGesture {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [self addGestureRecognizer:tap];
}

- (void)tapped:(UITapGestureRecognizer *)sender {
    self.isOn = !self.isOn;
    [self switchState];
    if (self.animatesTap) {
        [self animateToggleTapped:sender.view];
    }
    
    id<NNToggleDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(toggleWasTapped:)]) {
        [strongDelegate toggleWasTapped:self];
    }
}

- (void)switchState {
    UIColor *endColor;
    if (self.isOn) {
        endColor = self.onColor;
    } else {
        endColor = self.offColor;
    }
    
    [CATransaction begin];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    CABasicAnimation *fillAnimation = [CABasicAnimation animationWithKeyPath:@"fillColor"];
    fillAnimation.duration = .3;
    fillAnimation.fromValue = (id)shapeLayer.fillColor;
    fillAnimation.toValue = (id)endColor.CGColor;
    fillAnimation.removedOnCompletion = YES;
    
    [shapeLayer addAnimation:fillAnimation forKey:@"fillColor"];
    
    [CATransaction setCompletionBlock:^{
        shapeLayer.fillColor = endColor.CGColor;
    }];
    [CATransaction commit];
    
    id<NNToggleDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(toggleDidSwitchState:)]) {
        [strongDelegate toggleDidSwitchState:self];
    }
}

- (void)animateToggleTapped:(UIView*)view {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.15f
                              delay:0.0f
             usingSpringWithDamping:.2f
              initialSpringVelocity:10.f
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.05, 1.05);
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.3f
                                                   delay:0.0f
                                  usingSpringWithDamping:.3f
                                   initialSpringVelocity:10.0f
                                                 options:UIViewAnimationOptionAllowUserInteraction
                                              animations:^{
                                                  view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                                              }
                                              completion:^(BOOL finished) {
                                              }];
                         }];
    });
}


//[UIBezierPath bezierPathWithRoundedRect:cornerRadius:]


//UIBezierPath *knobPath = [UIBezierPath bezierPath];
//[knobPath addArcWithCenter:knobCenter radius:self.knobRadius startAngle:startAngle endAngle:endAngle clockwise:self.isClockwise];
//
//CAShapeLayer *layer = [CAShapeLayer layer];
//layer.path = [knobPath CGPath];
//layer.strokeColor = [self.lineColor CGColor];           // M_PI     2*M_PI   - half circle
//layer.fillColor = [self.knobColor CGColor];             // M_PI     -M_PI   - rotate 180
//layer.lineWidth = self.lineWidth;                       // -M_PI/2  2*M_PI   - rotate 90
//layer.lineJoin = kCALineJoinBevel;                      // 2/-M_PI  2*M_PI   - rotate 45
//layer.strokeEnd = 0;                                    // 2*M_PI   M_PI     - upside down half circle
//layer.drawsAsynchronously = YES;                         // 2*M_PI   -M_PI/2  - upside down 3/4 rotated circle
//// 2*M_PI   2/-M_PI  - Near complete circle
//knobLayer = layer;
//[self.layer addSublayer:knobLayer];
@end
