NNAccelView
by Danny Holmes
danny.notnatural.co

Copyright (c) 2015 Danny Holmes, notnatural.co.
Licensed under the MIT license.

NNAccelView is an easy-to-use obj-c class for accessing filtered, normalized accelerometer values. It includes optional graphics for visualizing the device motion.

Another advantage to using NNAccelView is that postive/negative values should not “flip over.” Rather than 1 immediately flipping to -1 at a certain angle, the signal will reverse itself. This effectively gives NNAccelView a limited range of 180 degrees, but this is acceptable for apps that do not actually require 360 degree range (most apps…).


TODO: 
-	Better graphic images
-	BUG - pitch values are correct, but the graphic representation only “pitches down”



Basic Instructions

- Import NNAccelView.h
- Create properties for NNAccelView and NSTimer
- Then something like this: (other example uses/code are included in the demo project)


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self easyModeAccelerometer];
}

- (void)easyModeAccelerometer
{
    self.accelView = [[NNAccelView alloc] init];
    [self.accelView putItHere:self.view];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0/40.0 
			  target:self selector:@selector(updateAccel:) 
			  userInfo:nil repeats:YES];
}

- (void)updateAccel:(NSTimer *)timer
{
    NNAccelView *accel = self.accelView;
    float pitch = accel.pitch;
    float yaw = accel.yaw;
    float roll = accel.roll;
    
    /* Do stuff here */
    NSLog(@"\r Pitch: %.2f | Yaw: %.2f | Roll: %.2f”,pitch,yaw,roll);
}
