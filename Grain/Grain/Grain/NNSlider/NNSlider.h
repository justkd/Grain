//
//  NNSlider.h
//
//  Created by Cady Holmes on 1/28/15.
//  Copyright (c) 2015-present Cady Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIColor+NNColors.h"

@interface NNSlider : UIControl {
    @protected
    CAShapeLayer *knobLayer;
    CAShapeLayer *lineLayer;
    CGPoint knobCenter;
    float knobCenterOffset;
    float normalizedValue;

}
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSString *customLabel;

@property (nonatomic, strong) UIColor *knobColor;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) UIColor *dialColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *labelTextColor;
@property (nonatomic, strong) UIColor *segmentColor;
@property (nonatomic, strong) UIColor *textBubbleColor;
@property (nonatomic) CGFloat lineWidth;
@property (nonatomic) CGFloat knobRadius;
@property (nonatomic) CGPathRef bendPath;
@property (nonatomic) float value;
@property (nonatomic) float altValue;
@property (nonatomic) float minValue;
@property (nonatomic) float startupAnimationDuration;
@property (nonatomic) float stringFlex;
@property (nonatomic) float valueScale;
@property (nonatomic) float segments;
@property (nonatomic) BOOL shouldDoCoolAnimation;
@property (nonatomic) BOOL clipsAltValues;
@property (nonatomic) BOOL snapsBack;
@property (nonatomic) BOOL isDial;
@property (nonatomic) BOOL isString;
@property (nonatomic) BOOL isSegmented;
@property (nonatomic) BOOL hasLabel;
@property (nonatomic) BOOL hasPopup;
@property (nonatomic) BOOL isClockwise;
@property (nonatomic) BOOL shouldFlip;
@property (nonatomic) BOOL isVertical;
@property (nonatomic) BOOL isInt;

- (void)updateValueTo:(float)value;

@end
