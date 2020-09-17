//
//  NNAccelView.h
//
//  Created by Cady Holmes.
//  Copyright (c) 2015-present Cady Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "nnKit.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreMotion/CoreMotion.h>
#import <CoreGraphics/CoreGraphics.h>

#ifdef DEBUG
#define clog(FORMAT, ...) fprintf(stderr,"%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(...)
#endif

@interface NNAccelView : UIView {
    UIColor *shadowColor;
    UIImageView *dotImage;
    UIImageView *shadowImageView;
    UIImageView *imageView;
    BOOL isStopped;
}

@property (nonatomic, strong) CMDeviceMotion *deviceMotion;
@property (nonatomic, strong) CMAttitude *currentAttitude;
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic) double pitch;
@property (nonatomic) double yaw;
@property (nonatomic) double roll;
@property (nonatomic) double resolution;
@property (nonatomic) float acceleration;
@property (nonatomic) float lastAcceleration;
@property (nonatomic) float lastX;
@property (nonatomic) float lastY;
@property (nonatomic) float lastZ;
@property (nonatomic, strong) UIView *parentView;
@property (nonatomic, strong) UILabel *label;
//@property (nonatomic, strong) UIImageView *imageView;
//@property (nonatomic, strong) UIImageView *shadowImageView;
@property (nonatomic, strong) NSDictionary *lastAccelDict;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) BOOL transformsWithEulerAngles;
@property (nonatomic) BOOL transformsWithAcceleration;
@property (nonatomic) BOOL exposesEulerAngles;
@property (nonatomic) BOOL exposesAcceleration;
@property (nonatomic) BOOL logsStuff;
@property (nonatomic) BOOL isPlane;
@property (nonatomic) BOOL hasOutline;

- (void)putItHere:(UIView *)view;
- (void)initWithCenter:(CGPoint)center;
- (void)accelViewRotationTransformWithEulerAngleDictionary:(NSDictionary *)dict;
- (void)accelViewAccelerationTransform:(float)acceleration;
- (void)resetMotionManager;
- (void)startMotionManager;
- (void)stopMotionManager;
- (void)startPolling;
- (void)stopPolling;
- (void)update;
- (void)useShakeReset:(BOOL)x;
- (void)makeLabelWithString:(NSString *)string withCenter:(CGPoint)center withFontSize:(float)size;
- (void)setShadowColor:(UIColor *)color;

@end
