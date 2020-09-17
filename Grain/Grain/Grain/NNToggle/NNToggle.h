//
//  NNToggle.h
//
//  Created by Cady Holmes on 9/18/15.
//  Copyright © 2015-present Cady Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol NNToggleDelegate;

@interface NNToggle : UIView {
    CAShapeLayer *shapeLayer;
    CALayer *imageLayer;
}

@property (nonatomic, retain) id<NNToggleDelegate> delegate;
@property (nonatomic, strong) UIColor* borderColor;
@property (nonatomic, strong) UIColor* onColor;
@property (nonatomic, strong) UIColor* offColor;
@property (nonatomic, strong) UIImage* image;
@property (nonatomic) float imageSize;
@property (nonatomic) CGFloat borderWidth;
@property (nonatomic) CGFloat cornerRadius;
@property (nonatomic) BOOL isOn;
@property (nonatomic) BOOL animatesTap;

- (void)switchState;
- (void)animateToggleTapped:(UIView*)view;

@end

@protocol NNToggleDelegate <NSObject>

- (void)toggleDidSwitchState:(NNToggle*)toggle;
- (void)toggleWasTapped:(NNToggle*)toggle;

@end


