
//
//  ControllerViewController.m
//
//  Created by Cady Holmes on 9/8/15.
//  Copyright © 2015-present Cady Holmes. All rights reserved.
//

#import "ControllerViewController.h"

static int const port = 18282;

@interface ControllerViewController ()

@property (strong) CAEmitterLayer *dotEmitter;

@end

@implementation ControllerViewController

-(BOOL)shouldAutorotate {
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromHex(0xD24D57);
    speedString = [NSString stringWithFormat:@"speed/100"];
    levelString = [NSString stringWithFormat:@"level/1.0"];
    pitchString = [NSString stringWithFormat:@"pitch/0"];
    rollString = [NSString stringWithFormat:@"roll/0"];
    yawString = [NSString stringWithFormat:@"yaw/0"];
    accString = [NSString stringWithFormat:@"accel/0"];
    
    [self createMenu];
    [self createEmitter];
    [self createSignalIcon];
    [self easyModeAccelerometer];
    
    if (udpSocket == nil) {
        [self setupSocket];
    }
    
    [self loadIP];
    
    if ([nnKit isValidIpAddress:ipAddress]) {
        [self makeIPPopupWithCancel:YES];
    } else {
        [self makeIPPopupWithCancel:NO];
    }
}

- (void)loadIP {
    ipAddress = [NSString stringWithFormat:@"0"];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    path = [path stringByAppendingPathComponent:@"ipaddress.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *array;
    
    if ([fileManager fileExistsAtPath:path]) {
        array = [[NSArray alloc] initWithContentsOfFile:path];
        if ([array objectAtIndex:0]) {
            ipAddress = [array objectAtIndex:0];
        }
    }

    if ([nnKit isValidIpAddress:ipAddress] && udpSocket) {
        [nnKit animateViewGrowAndShow:nil or:signalIcon completion:nil];
    }
}

- (void)saveIP {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *array;
        BOOL isUDP = NO;
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        path = [path stringByAppendingPathComponent:@"ipaddress.plist"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:path]) {
            array = [[NSArray alloc] initWithContentsOfFile:path];
            if ([array count] > 1 && [array objectAtIndex:1]) {
                isUDP = [[array objectAtIndex:1] boolValue];
            }
            [fileManager removeItemAtPath:path error:nil];
        }
        array = @[ipAddress, [NSNumber numberWithBool:isUDP]];
        [fileManager createFileAtPath:path
                             contents:nil
                           attributes:nil];
        [array writeToFile:path atomically:YES];

        if ([nnKit isValidIpAddress:ipAddress] && udpSocket) {
            [nnKit animateViewGrowAndShow:nil or:signalIcon completion:nil];
        }
    });
}

#pragma mark - Accelerometer

- (void)easyModeAccelerometer {
    
    accel = [[NNAccelView alloc] init];
    [accel putItHere:self.view];
    accel.exposesAcceleration = YES;
    accel.transformsWithAcceleration = YES;
    [accel setShadowColor:UIColorFromHex(0xFEFEFE)];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0/40.0 target:self selector:@selector(updateAccel:) userInfo:nil repeats:YES];
}

- (void)updateAccel:(NSTimer*)timer {
    
    [accel update];
    
    float pitch = accel.pitch;
    float yaw = accel.yaw;
    float roll = accel.roll;
    
    float acc = accel.acceleration;
    acc = FILTER(acc, lastAcc, .9);
    acc = [nnKit linearToExponential:acc inputMIN:.001 inputMAX:.5 outputMIN:10 outputMAX:50];
    //NSLog(@"%f",acc);
    
    roll = fabsf(roll);
    pitch = fabsf(pitch);
    yaw = fabsf(yaw);
    
    roll = pow(roll, 1.6);
    pitch = pow(pitch, 1.6);
    yaw = pow(yaw, 1.6);
    
    pitchString = [NSString stringWithFormat:@"pitch/%f",pitch];
    rollString = [NSString stringWithFormat:@"roll/%f",roll];
    yawString = [NSString stringWithFormat:@"yaw/%f",yaw];
    accString = [NSString stringWithFormat:@"acc/%f",acc];

    [self sendOSC:pitchString];
    [self sendOSC:rollString];
    [self sendOSC:yawString];
    [self sendOSC:accString];
}

#pragma mark - CAEmitter

- (void)createEmitter {
    CGRect viewBounds = self.view.layer.bounds;
    
    self.dotEmitter = [CAEmitterLayer layer];

    self.dotEmitter.emitterPosition = CGPointMake(viewBounds.size.width/2.0, viewBounds.size.height/2.0);
    self.dotEmitter.emitterSize     = CGSizeMake(50, 0);
    self.dotEmitter.emitterMode     = kCAEmitterLayerOutline;
    self.dotEmitter.emitterShape    = kCAEmitterLayerCircle;
    self.dotEmitter.renderMode      = kCAEmitterLayerBackToFront;
    
    CAEmitterCell* dot = [CAEmitterCell emitterCell];
    [dot setName:@"dot"];
    
    dot.birthRate			= 4;
    dot.velocity			= 40;
    dot.scale				= 0.5;
    dot.scaleSpeed			=-0.2;
    dot.greenSpeed			=-0.15;
    dot.redSpeed			=-0.5;
    dot.blueSpeed			=-0.5;
    dot.lifetime			= .8;
    
    dot.color = [[UIColor whiteColor] CGColor];
    dot.contents = (id) [[UIImage imageNamed:@"dot_particle.pdf"] CGImage];
    
    
    CAEmitterCell* hex = [CAEmitterCell emitterCell];
    [hex setName:@"hex"];
    
    hex.birthRate         = 4;
    hex.emissionLongitude = M_PI * 0.5;
    hex.velocity          = 50;
    hex.scale             = 0.35;
    hex.scaleSpeed        =-0.4;
    hex.greenSpeed        =-0.1;
    hex.redSpeed          =-0.4;
    hex.blueSpeed         = 0.1;
    hex.alphaSpeed        =-0.3;
    hex.lifetime          = .8;
    
    hex.color = [[UIColor whiteColor] CGColor];
    hex.contents = (id) [[UIImage imageNamed:@"hex_particle.pdf"] CGImage];
    
    
    CAEmitterCell* cap = [CAEmitterCell emitterCell];
    [cap setName:@"cap"];
    
    cap.birthRate		= 4;
    cap.velocity		= 30;
    cap.zAcceleration  = -1;
    cap.emissionLongitude = -M_PI;
    cap.scale			= 0.5;
    cap.scaleSpeed		=-0.2;
    cap.greenSpeed		=-0.1;
    cap.redSpeed		= 0.4;
    cap.blueSpeed		=-0.1;
    cap.alphaSpeed		=-0.2;
    cap.lifetime		= .8;
    
    cap.color = [[UIColor whiteColor] CGColor];
    cap.contents = (id) [[UIImage imageNamed:@"capsule_particle.pdf"] CGImage];
    
    self.dotEmitter.emitterCells = [NSArray arrayWithObject:dot];
    dot.emitterCells = [NSArray arrayWithObjects:hex, cap, nil];
    //self.dotEmitter.beginTime = CACurrentMediaTime();
    [self.view.layer addSublayer:self.dotEmitter];
}

- (void)createMenu {
    NSArray *imageList = @[[UIImage imageNamed:@"controller2.pdf"], [UIImage imageNamed:@"home.pdf"], [UIImage imageNamed:@"question.pdf"], [UIImage imageNamed:@"close.pdf"]];
    sideBar = [[CDSideBarController alloc] initWithImages:imageList andUpperMargin:50];
    sideBar.delegate = self;
    [sideBar insertMenuButtonOnView:self.view atPosition:CGPointMake(self.view.frame.size.width - 50, 27)];
}

#pragma mark - Touches

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    [self touchAtPosition:touchPoint];
}


- (void) touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchPoint = [touch locationInView:self.view];
    [self touchAtPosition:touchPoint];
}


- (void) touchAtPosition:(CGPoint)position
{
    CABasicAnimation *burst = [CABasicAnimation animationWithKeyPath:@"emitterCells.dot.birthRate"];
    burst.fromValue			= [NSNumber numberWithFloat: 75.0];
    burst.toValue			= [NSNumber numberWithFloat: 0.0];
    burst.duration			= 0.5;
    burst.timingFunction	= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [self.dotEmitter addAnimation:burst forKey:@"burst"];
    
    [CATransaction begin];
    [CATransaction setDisableActions: YES];
    self.dotEmitter.emitterPosition	= position;
    [CATransaction commit];
    
    float x = position.x;
    float y = position.y;
    
    x = x/self.view.bounds.size.width;
    y = y/self.view.bounds.size.height;
    
    x = x*200;
    x = MAX(1, x);
    
    y = 1-y;
    y = y*3;
    
    //NSLog(@"%f,%f",x,y);
    
    speedString = [NSString stringWithFormat:@"speed/%f",x];
    levelString = [NSString stringWithFormat:@"level/%f",y];
    
    [self sendOSC:speedString];
    [self sendOSC:levelString];
}


#pragma mark - CDSideBarController delegate

- (void)menuOpened {
    if ([nnKit isValidIpAddress:ipAddress] && udpSocket) {
        [nnKit animateViewShrinkAndWink:nil or:signalIcon andRemoveFromSuperview:NO completion:nil];
    }
}

- (void)menuClosed {
    if ([nnKit isValidIpAddress:ipAddress] && udpSocket) {
        [nnKit animateViewGrowAndShow:nil or:signalIcon completion:nil];
    }
}

- (void)menuButtonClicked:(int)index {
    if (index == 1) {
        [self dismissViewControllerAnimated:YES completion:^(){
            if (udpSocket) {
                udpSocket = nil;
            }
        }];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (index) {
                case 0:
                    [self makeIPPopupWithCancel:YES];
                    break;
                case 2:
                    
                    break;
                case 3:
                    [sideBar dismissMenu];
                    break;

                default:
                    break;
            }
        });
    }
}

#pragma mark - IP Popup

- (void)makeIPPopupWithCancel:(BOOL)cancel {
    ipPopupBackground = [[UIView alloc] initWithFrame:self.view.frame];
    ipPopupBackground.backgroundColor = UIColorFromHex(0xD24D57);
    [self.view addSubview:ipPopupBackground];
    
    ipPopup = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width*.95, self.view.bounds.size.height/2)];
    ipPopup.backgroundColor = [UIColor whiteColor];
    ipPopup.center = CGPointMake(self.view.center.x, self.view.bounds.size.height/3);
    ipPopup.layer.cornerRadius = 8;
    ipPopup.layer.masksToBounds = YES;
    
    textFieldIP = [[UITextField alloc] init];
    textFieldIP = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, ipPopup.bounds.size.width*.95, ipPopup.bounds.size.height*.5)];
    
    CGPoint center = CGPointMake(ipPopup.bounds.size.width/2, ipPopup.bounds.size.height/4);
    
    textFieldIP.center = center;
    textFieldIP.borderStyle = UITextBorderStyleNone;
    [textFieldIP setFont:[UIFont boldSystemFontOfSize:ipPopup.bounds.size.width/12]];
    textFieldIP.textAlignment = NSTextAlignmentCenter;
    textFieldIP.autocorrectionType = UITextAutocorrectionTypeNo;
    textFieldIP.keyboardType = UIKeyboardTypeDecimalPad;
    textFieldIP.clearButtonMode = UITextFieldViewModeWhileEditing;
    textFieldIP.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textFieldIP.delegate = self;
    
    NSString *titleString;
    if ([nnKit isValidIpAddress:ipAddress]) {
        titleString = [NSString stringWithFormat:@"Current Target IP Address:"];
        textFieldIP.placeholder = [NSString stringWithFormat:@"%@",ipAddress];
    } else {
        titleString = [NSString stringWithFormat:@"Enter Target IP Address:"];
        textFieldIP.placeholder = [NSString stringWithFormat:@"eg. 10.0.0.1"];
    }
    
    center = CGPointMake(ipPopup.bounds.size.width/2, (ipPopup.bounds.size.height/4)/2);
    UILabel *label = [nnKit makeLabelWithCenter:center fontSize:ipPopup.bounds.size.width/20 text:titleString];
    
    center = CGPointMake(ipPopup.bounds.size.width/2, ipPopup.bounds.size.height/2);
    
    if (cancel && [nnKit isValidIpAddress:ipAddress]) {
        titleString = [NSString stringWithFormat:@"Change it!"];
    } else {
        titleString = [NSString stringWithFormat:@"Go!"];
    }
    
    CGRect rect = CGRectMake(0, 0, ipPopup.bounds.size.width*.6, 100);
    UIButton *done = [nnKit makeButtonWithFrame:rect fontSize:ipPopup.bounds.size.width/10 title:titleString method:@"returnText" fromClass:self];
    done.center = center;
    
    if (cancel && [nnKit isValidIpAddress:ipAddress]) {
        titleString = [NSString stringWithFormat:@"(No changes please.)"];
    } else {
        titleString = [NSString stringWithFormat:@"(Nevermind.)"];
    }
    
    UIButton *cancelButton = [nnKit makeButtonWithFrame:rect fontSize:ipPopup.bounds.size.width/20 title:titleString method:@"cancelPopup" fromClass:self];
    cancelButton.center = CGPointMake(ipPopup.bounds.size.width/2, ipPopup.bounds.size.height-(ipPopup.bounds.size.height/4));
    
    UIButton *helpButton = [nnKit makeButtonWithImage:[UIImage imageNamed:@"question.pdf"] frame:CGRectMake(0, 0, SW()/10, SW()/10) method:@"showPopupHelp:" fromClass:self];
    [helpButton setCenter:CGPointMake(SW()/10,ipPopup.bounds.size.height-SW()/10)];
    
    [ipPopup addSubview:helpButton];
    [ipPopup addSubview:cancelButton];
    [ipPopup addSubview:label];
    [ipPopup addSubview:textFieldIP];
    [ipPopup addSubview:done];
    [self.view addSubview:ipPopup];
    
    if (textFieldIP) {
        [textFieldIP becomeFirstResponder];
    }
}

- (void)showPopupHelp:(UIButton*)button {
    [nnKit animateViewBigJiggle:button];
}

- (void)cancelPopup {
    [textFieldIP resignFirstResponder];
    [nnKit animateViewShrinkAndWink:ipPopup or:nil andRemoveFromSuperview:YES completion:nil];
    [nnKit animateViewShrinkAndWink:ipPopupBackground or:nil andRemoveFromSuperview:YES completion:nil];
}

- (void)returnText {
    if ([nnKit isValidIpAddress:textFieldIP.text]) {
        ipAddress = textFieldIP.text;
        [textFieldIP resignFirstResponder];
        [self saveIP];
        //NSLog(@"%@",ipAddress);

        [nnKit animateViewShrinkAndWink:ipPopup or:nil andRemoveFromSuperview:YES completion:nil];
        [nnKit animateViewShrinkAndWink:ipPopupBackground or:nil andRemoveFromSuperview:YES completion:nil];
    } else {
        UIAlertView * alert =[[UIAlertView alloc ] initWithTitle:@"Super Important Error Alert"
                                                         message:@"(You must enter a valid IP address.)"
                                                        delegate:self
                                               cancelButtonTitle:@"Sorry, I'll do better next time..."
                                               otherButtonTitles: nil];
        [alert show];
    }
}

- (void)createSignalIcon {
    signalIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, sideBar.menuButton.frame.size.width*.9, sideBar.menuButton.frame.size.width*.9)];
    signalIcon.image = [UIImage imageNamed:@"radio_signal.pdf"];
    signalIcon.center = CGPointMake(SW()-sideBar.menuButton.frame.size.width*2, sideBar.menuButton.center.y);
    [self.view addSubview:signalIcon];
    [nnKit animateViewShrinkAndWink:nil or:signalIcon andRemoveFromSuperview:NO completion:nil];
}

#pragma mark - GCD UDP Socket

- (void)setupSocket
{
    dispatch_queue_t q = dispatch_queue_create("oscqueue",NULL);
    udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:q];
    
    NSError *error = nil;
    
    if (![udpSocket bindToPort:port error:&error])
    {
        NSLog(@"Error binding: %@", error);
    }
    if (![udpSocket beginReceiving:&error])
    {
        NSLog(@"Error receiving: %@", error);
    }

    NSLog(@"Ready");
}

- (void)sendOSC:(NSString*)msg {
    // speed
    // level
    // pitch
    // roll
    // yaw
    // acc
    
    if ([msg length] == 0) {
        NSLog(@"Msg length is 0");
    } else {
        NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
        [udpSocket sendData:data toHost:ipAddress port:port withTimeout:-1 tag:tag];
        
        //NSLog(@"SENT (%i): %@", (int)tag, msg);

        if (tag > 10000) {
            tag = 0;
        }
        tag++;
    }
}

@end
