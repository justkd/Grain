//
//  NNAccelView.m
//
//  Created by Danny Holmes.
//  Copyright (c) 2015-present Cady Holmes. All rights reserved.
//

#import "NNAccelView.h"

@implementation NNAccelView

/* See below for example uses */

-(BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)putItHere:(UIView *)view {
    
    CGRect frame = CGRectMake(view.bounds.size.width*.01, view.bounds.size.height*.024, view.bounds.size.width/6, view.bounds.size.height/10);
    self.frame = frame;
    [view addSubview:self];
    [self createPlaneView];
    [self setDefaults];
    [self startMotionManager];
    [self startPolling];
    //[self useShakeReset:YES];
}

- (void)startPolling {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0/40.0 target:self selector:@selector(accelUpdateCallback:) userInfo:nil repeats:YES];
}

- (void)stopPolling {
    [self.timer invalidate];
}

- (void)accelUpdateCallback:(NSTimer *)timer {
    [self update];
}

- (void)startMotionManager {
    NSString *deviceType = [UIDevice currentDevice].model;
    self.motionManager = [[CMMotionManager alloc] init];
    if([deviceType isEqualToString:@"iPod touch"]) {
        [self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryZVertical];
    } else {
        [self.motionManager startDeviceMotionUpdates];
        //[self.motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXArbitraryCorrectedZVertical];
    }
    
}

- (void)stopMotionManager {
    [self.motionManager stopDeviceMotionUpdates];
}

- (void)resetMotionManager {
    [self stopMotionManager];
    [self startMotionManager];
}

- (void)initWithCenter:(CGPoint)center {
    self.center = center;
    [self createPlaneView];
    [self setDefaults];
    [self startMotionManager];
}
- (void)setDefaults {
    //self.lastAcceleration = 1;
    shadowColor = [UIColor colorWithRed:(22/255.0) green:(22/255.0) blue:(22/255.0) alpha:1];
    self.transformsWithAcceleration = NO;
    self.transformsWithEulerAngles = YES;
    self.exposesAcceleration = NO;
    self.exposesEulerAngles = YES;
    self.logsStuff = NO;
    self.resolution = 3;
    self.hasOutline = NO;
    self.userInteractionEnabled = YES;
    isStopped = NO;
}

- (void)createPlaneView {
    
    self.isPlane = YES;
    self.parentView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.parentView];
    
    if (self.hasOutline) {
        shadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowbottom.pdf"]];
    } else {
        shadowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowbottom_alt.pdf"]];
    }
    
    shadowImageView.center = self.center;
    shadowImageView.backgroundColor = [UIColor clearColor];
    shadowImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    shadowImageView.contentMode = UIViewContentModeScaleAspectFit;
    [shadowImageView.layer setZPosition:1];
    [shadowImageView.layer setDoubleSided:YES];
    shadowImageView.frame = self.parentView.frame;
    
    if (self.hasOutline) {
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowtop.pdf"]];
    } else {
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"arrowtop_alt.pdf"]];
    }
    imageView.center = self.center;
    imageView.backgroundColor = [UIColor clearColor];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [imageView.layer setZPosition:2];
    [imageView.layer setDoubleSided:NO];
    imageView.frame = self.parentView.frame;

    imageView.layer.shadowOpacity = 1.0;
    imageView.layer.shadowRadius = 0;
    imageView.layer.shadowColor = shadowColor.CGColor;
    imageView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    
    shadowImageView.layer.shadowOpacity = 1.0;
    shadowImageView.layer.shadowRadius = 0;
    shadowImageView.layer.shadowColor = shadowColor.CGColor;
    shadowImageView.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    
    dotImage = [[UIImageView alloc] initWithFrame:self.bounds];
    if (self.self.hasOutline) {
        dotImage.image = [UIImage imageNamed:@"dot.pdf"];
    } else {
        dotImage.image = [UIImage imageNamed:@"dot_alt.pdf"];
    }
    dotImage.alpha = 0;

    UITapGestureRecognizer *dt = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleAccel)];
    [dt setNumberOfTapsRequired:2];
    UITapGestureRecognizer *st = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resetMotionManager)];
    [st setNumberOfTapsRequired:1];
    
    [self addGestureRecognizer:st];
    [self addGestureRecognizer:dt];
    [self.parentView addSubview:shadowImageView];
    [self.parentView addSubview:imageView];
    [self.parentView addSubview:dotImage];
    self.layer.masksToBounds = NO;
}

- (void)toggleAccel {
    if (!isStopped) {
        [self stopPolling];
        [self stopMotionManager];
        
        dotImage.alpha = 1;
        imageView.alpha = 0;
        shadowImageView.alpha = 0;
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            dotImage.alpha = 0;
            imageView.alpha = 1;
            shadowImageView.alpha = 1;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self startPolling];
                [self startMotionManager];
            });
        });
    }
    isStopped = !isStopped;
}

- (void)setShadowColor:(UIColor *)color {
    shadowColor = color;
    shadowImageView.layer.shadowColor = shadowColor.CGColor;
    imageView.layer.shadowColor = shadowColor.CGColor;
}

- (void)update {
    if (self.exposesEulerAngles == YES) {
        
        NSDictionary *noGimbal = [self noGimbalDict:self.lastAccelDict];
        self.lastAccelDict = noGimbal;
        
        double pitch = [[noGimbal objectForKey:@"pitch"] floatValue];
        double yaw = [[noGimbal objectForKey:@"yaw"] floatValue];
        double roll = [[noGimbal objectForKey:@"roll"] floatValue];
        
        self.pitch = pitch / self.resolution;
        self.yaw = yaw / self.resolution;
        self.roll = roll / self.resolution;
        
        if (self.logsStuff == YES) {
            NSLog(@"\r Pitch %.3f | Yaw %.3f | Roll %.3f",self.pitch,self.yaw,self.roll);
        }
    }
    
    if (self.exposesAcceleration == YES) {
        
        float aX = fabsf((float)self.motionManager.deviceMotion.userAcceleration.x);
        float aY = fabsf((float)self.motionManager.deviceMotion.userAcceleration.y);
        float aZ = fabsf((float)self.motionManager.deviceMotion.userAcceleration.z);
        float acceleration = aX + aY + aZ;
        
        acceleration = [self filterCurrentInput:acceleration lastOutput:self.acceleration];
        aX = [self filterCurrentInput:aX lastOutput:self.lastX];
        aY = [self filterCurrentInput:aY lastOutput:self.lastY];
        aZ = [self filterCurrentInput:aZ lastOutput:self.lastZ];
        self.acceleration = acceleration;
        self.lastX = aX;
        self.lastY = aY;
        self.lastZ = aZ;
        
        if (self.logsStuff == YES) {
            clog(@"\r X: %.2f| Y: %.2f | Z: %.2f | Total Acceration: %.2f",aX,aY,aZ,self.acceleration);
        }
    }
    
    if (self.hidden == NO) {
        if (self.transformsWithEulerAngles == YES) {
            
            float pitch = self.pitch;
            float yaw = self.yaw;
            float roll = self.roll;
            
            NSArray *attitudeArray = [NSArray arrayWithObjects:[NSNumber numberWithFloat:pitch],[NSNumber numberWithFloat:yaw],[NSNumber numberWithFloat:roll],nil];
            NSArray *keyArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"pitch"],[NSString stringWithFormat:@"yaw"],[NSString stringWithFormat:@"roll"],nil];
            
            NSDictionary *transformDict = [NSDictionary dictionaryWithObjects:attitudeArray forKeys:keyArray];
            
            [self accelViewRotationTransformWithEulerAngleDictionary:transformDict];
        }
        
        if (self.transformsWithAcceleration == YES) {
            [self accelViewAccelerationTransform:self.acceleration];
        }
    }
}


- (NSDictionary *)noGimbalDict:(NSDictionary *)dictionary {

    double qw = self.motionManager.deviceMotion.attitude.quaternion.w;
    double qx = self.motionManager.deviceMotion.attitude.quaternion.x;
    double qy = self.motionManager.deviceMotion.attitude.quaternion.y;
    double qz = self.motionManager.deviceMotion.attitude.quaternion.z;

    double yaw = (qw*qz - qx*qy) * 6;
    double pitch = (qw*qx - qy*qz) * 6;
    double roll = (qw*qy - qx*qz) * 6;

//    double yaw = self.motionManager.deviceMotion.attitude.yaw;
//    double pitch = self.motionManager.deviceMotion.attitude.pitch;
//    double roll = self.motionManager.deviceMotion.attitude.roll;

    //NSLog(@"%@", [NSString stringWithFormat:@"%f",pitch]);

    NSDictionary *filteredDict = [self filterPitch:pitch roll:roll yaw:yaw lastDict:dictionary];
    
    return filteredDict;
}

- (NSDictionary *)filterPitch:(double)pitch roll:(double)roll yaw:(double)yaw lastDict:(NSDictionary *)lastDict {
    
    double x = [[lastDict objectForKey:@"yaw"] doubleValue];
    double y = [[lastDict objectForKey:@"pitch"] doubleValue];
    double z = [[lastDict objectForKey:@"roll"] doubleValue];
    
    pitch = [self filterCurrentInput:pitch lastOutput:y];
    yaw = [self filterCurrentInput:yaw lastOutput:x];
    roll = [self filterCurrentInput:roll lastOutput:z];
    
    NSNumber *numPitch = [NSNumber numberWithDouble:pitch];
    NSNumber *numYaw = [NSNumber numberWithDouble:yaw];
    NSNumber *numRoll = [NSNumber numberWithDouble:roll];
    
    NSArray *attitudeArray = [NSArray arrayWithObjects:numPitch,numYaw,numRoll,nil];
    NSArray *keyArray = [NSArray arrayWithObjects:[NSString stringWithFormat:@"pitch"],[NSString stringWithFormat:@"yaw"],[NSString stringWithFormat:@"roll"],nil];
    
    NSDictionary *filteredDict = [NSDictionary dictionaryWithObjects:attitudeArray forKeys:keyArray];
    return filteredDict;
}

- (void)accelViewRotationTransformWithEulerAngleDictionary:(NSDictionary *)dict  {
    
    float pitch = [[dict objectForKey:@"pitch"] floatValue];
    float yaw = [[dict objectForKey:@"yaw"] floatValue];
    float roll = [[dict objectForKey:@"roll"] floatValue];
    
    pitch = pitch / 2.0;
    pitch = pitch + .5;
    pitch = pitch * 360;
    pitch = pitch * M_PI_2 / 180;
    //NSLog(@"%f",pitch);
    
    roll = roll / 3.0;
    roll = roll + .5;
    roll = roll * 360;
    roll = roll * M_PI / 180;
    
    yaw = yaw / 4.0;
    yaw = yaw + .5;
    yaw = yaw * 360;
    yaw = yaw * M_PI / 180;
    
    
//    CATransform3D transform = CATransform3DConcat(CATransform3DConcat(CATransform3DRotate (CATransform3DIdentity, pitch+M_PI_2, 1.0, 0.0, 0.0), CATransform3DRotate(CATransform3DIdentity, roll, 0.0, -1.0, 0.0)), CATransform3DRotate(CATransform3DIdentity, yaw-M_PI, 0.0, 0.0, -1.0));
    
    CATransform3D transform = CATransform3DIdentity;
    transform = CATransform3DMakeRotation(0, -1, 0, 0);
    transform = CATransform3DRotate(transform, pitch, 1, 0, 0);
    transform = CATransform3DRotate(transform, roll, 0, 1, 0);
    transform = CATransform3DRotate(transform, -yaw, 0, 0, 1);
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut)
                     animations:^{
                         if (self.isPlane == YES) {
                             imageView.layer.transform = transform;
                             shadowImageView.layer.transform = transform;
                         } else {
                             self.layer.transform = transform;
                         }
                     } completion:^(BOOL finished){
                     }];
}

- (void)accelViewAccelerationTransform:(float)acceleration {
    
    acceleration = fabsf(acceleration);

    acceleration = SCALE(acceleration, 0, 1, 0, 80);
    acceleration = CLIP(acceleration, 0, 80);
    // xf = k * xf + (1.0 - k) * x;
    acceleration = FILTER(acceleration, self.lastAcceleration, .98);
    self.lastAcceleration = acceleration;
    
    float opacity = SCALE(acceleration, 0, 20, 0, 1);
    
    //NSLog(@"%f",opacity);
    
    self.transform = CGAffineTransformMakeScale(1, 1);
    [UIView animateWithDuration:.3
                          delay:0
                        options:(UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionCurveEaseInOut)
                     animations:^{
                         //self.transform = CGAffineTransformMakeScale(acceleration, acceleration);
                         imageView.layer.shadowOpacity = opacity;
                         shadowImageView.layer.shadowOpacity = opacity;
                         imageView.layer.shadowRadius = acceleration;
                         shadowImageView.layer.shadowRadius = acceleration;
                     } completion:^(BOOL finished){
                     }];
    
}

- (double)filterCurrentInput:(double)x lastOutput:(double)y {
    
    double q = 0.1;
    double r = 0.1;
    double p = 0.1;
    double k = 0.8;
    
    p = p + q;
    k = p / (p + r);
    x = x + k*(y - x);
    p = (1 - k)*p;
    
    return x;
}

- (void)makeLabelWithString:(NSString *)string withCenter:(CGPoint)center withFontSize:(float)size {
    
    self.isPlane = NO;
    
    self.parentView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.parentView];
    
    self.label = [[UILabel alloc] initWithFrame:self.parentView.bounds];
    [self.label setFont:[UIFont fontWithName:@"AmericanTypewriter-Bold" size:size]];
    self.label.text = string;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.center = self.center;
    self.label.backgroundColor = [UIColor clearColor];
    self.label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.label.layer.masksToBounds = NO;
    self.label.layer.shadowOpacity = 1.0;
    self.label.layer.shadowRadius = 3.0;
    self.label.layer.shadowColor = [[UIColor whiteColor] CGColor];
    self.label.layer.shadowOffset = CGSizeMake(1.15, -1.0);
    
    [self.parentView addSubview:self.label];
    self.layer.masksToBounds = NO;
    self.center = center;
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor grayColor] CGColor], (id)[[UIColor lightGrayColor] CGColor], nil];
    [self.parentView.layer insertSublayer:gradient atIndex:0];
    
    self.parentView.layer.shadowOpacity = 1.0;
    self.parentView.layer.shadowRadius = 3.5;
    self.parentView.layer.shadowColor = [[UIColor grayColor] CGColor];
    self.parentView.layer.shadowOffset = CGSizeMake(1.15, -1.0);
    
    [self setDefaults];
    [self startMotionManager];
}

- (void)useShakeReset:(BOOL)x {
    if (x == YES) {
        [self becomeFirstResponder];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shakeSuccess) name:@"shake" object:nil];
    } else {
        [self resignFirstResponder];
    }
}

- (void)shakeSuccess {
    [self resetMotionManager];
}

- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake ) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shake" object:self];
    }
}

#pragma Example implementation

// Import DHAccelView.h
// Create a DHAccelView property and an NSTimer property named accelView and timer (for the example code below to work)
// Copy and paste the easyModeAccelerometer and updateAccel: methods to your .m file
// Call the easyModeAccelerometer method
// Do whatever it is you need to with the accelerometer data in the updateAccel: method
// Other example uses and a list of public methods and properties are below

/*
 - (void)viewDidLoad {
 [super viewDidLoad];
 
 [self easyModeAccelerometer];
 //[self setUpAccelViewWithMoreOptions];
 //[self createTransformingTextInstead];
 }
 
 - (void)easyModeAccelerometer {
 
 self.accelView = [[DHAccelView alloc] init];
 [self.accelView putItHere:self.view];
 self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0/40.0 target:self selector:@selector(updateAccel:) userInfo:nil repeats:YES];
 }
 
 - (void)updateAccel:(NSTimer *)timer {
 
 float pitch = self.accelView.pitch;
 float yaw = self.accelView.yaw;
 float roll = self.accelView.roll;
 
 // Do stuff here
 NSLog(@"\r DHAccelView Pitch: %.2f | Yaw: %.2f | Roll: %.2f \r OldAttitude Pitch: %.2f | Yaw: %.2f | Roll: %.2f",pitch,yaw,roll,self.accelView.motionManager.deviceMotion.attitude.pitch,self.accelView.motionManager.deviceMotion.attitude.yaw,self.accelView.motionManager.deviceMotion.attitude.roll);
 }
 */

#pragma Other ways to use this thing

/*
 - (void)setUpAccelViewWithMoreOptions {
 
 // Create a custom size/frame and set the center point, add the view to the hierarchy, then update the accelerometer with an external timer.
 
 CGPoint center = CGPointMake(self.view.center.x, self.view.center.y*.5);
 CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width/2, self.view.bounds.size.height/4);
 
 self.accelView = [[DHAccelView alloc] initWithFrame:frame];
 [self.accelView initWithCenter:center];
 [self.view addSubview:self.accelView];
 
 // Change the scaling resolution of the incoming values. 3 is the default scale and outputs -1 to 1
 self.accelView.resolution = 6; // Will output values between -.5 and .5
 
 // You can change the top and bottom grahics if you don't like my airplane. =(
 self.accelView.imageView.image = [UIImage imageNamed:@"arrowbottom.png"];
 self.accelView.shadowImageView.image = [UIImage imageNamed:@"arrowtop.png"];
 
 self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0/40.0 target:self selector:@selector(accelUpdateCallback:) userInfo:nil repeats:YES];
 
 [self.accelView useShakeReset:YES];
 
 // Optionally, hide the graphic
 //self.accelView.hidden = YES;
 }
 
 - (void)accelUpdateCallback:(NSTimer*)timer {
 
 // This method updates all of the properties each time it is called.
 [self.accelView update];
 self.accelView.exposesAcceleration = YES;
 self.accelView.transformsWithAcceleration = YES;
 
 float pitch = self.accelView.pitch;
 float yaw = self.accelView.yaw;
 float roll = self.accelView.roll;
 
 float accel = self.accelView.acceleration;
 
 NSLog(@"\r Pitch: %.2f | Yaw: %.2f | Roll: %.2f | Acceleration: %.2f",pitch,yaw,roll,accel);
 }
 */

/*
 - (void)createTransformingTextInstead {
 
 // Create text in a box that transforms instead of the default graphic. initWithFrame like a normal UIView, call the makeLabelWithString: method, add the view to the view hierarchy, start the internal polling timer. You'll still need an external method of accessing the updated values.
 
 self.accelView = [[DHAccelView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width/2, self.view.bounds.size.width/8)];
 [self.accelView makeLabelWithString:@"Accel" withCenter:self.view.center withFontSize:40];
 [self.view addSubview:self.accelView];
 [self.accelView startPolling];
 
 // Log the internally polled values for easy testing.
 self.accelView.logsStuff = YES;
 }
 */

#pragma Other subclassed public methods and properties.

/*
 - (void)otherThingsYouCanChange {
 [self.accelView stopMotionManager];
 [self.accelView startMotionManager];
 [self.accelView resetMotionManager];
 [self.accelView stopPolling];
 [self.accelView startPolling];
 self.accelView.exposesEulerAngles = NO;
 self.accelView.transformsWithEulerAngles = NO;
 }
 */


@end
