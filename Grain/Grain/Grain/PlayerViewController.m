//
//  PlayerViewController.m
//  Grain
//
//  Created by Cady Holmes on 9/8/15.
//  Copyright © 2015-present Cady Holmes. All rights reserved.
//

#import "PlayerViewController.h"

#define kFadeTime 0.3
#define kFadeDelay 0.1
#define kFadePD 0.36
#define kStartingGain 70.0

static int const port = 18282;

@interface PlayerViewController () 
@end

@implementation PlayerViewController

//- (BOOL)canBecomeFirstResponder {
//    return YES;
//}
//
//- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
//    if (UIEventSubtypeMotionShake) {
//        if (self.waveView1) {
//            if (oneIsPlaying) {
//                oneIsPlaying = NO;
//                [self.pd sendFloat:0 toReceiver:[NSString stringWithFormat:@"1.main.play"]];
//                [self.waveView1.player stop];
//                [self.transport1 setBackgroundImage:[UIImage imageNamed:@"play.pdf"] forState:UIControlStateNormal];
//            }
//        }
//
//        if (self.waveView2) {
//            if (twoIsPlaying) {
//                twoIsPlaying = NO;
//                [self.waveView2.player stop];
//                [self.pd sendFloat:0 toReceiver:[NSString stringWithFormat:@"2.main.play"]];
//                [self.transport2 setBackgroundImage:[UIImage imageNamed:@"play.pdf"] forState:UIControlStateNormal];
//            }
//        }
//
//        if (self.waveView3) {
//            if (threeIsPlaying) {
//                threeIsPlaying = NO;
//                [self.waveView3.player stop];
//                [self.pd sendFloat:0 toReceiver:[NSString stringWithFormat:@"3.main.play"]];
//                [self.transport3 setBackgroundImage:[UIImage imageNamed:@"play.pdf"] forState:UIControlStateNormal];
//            }
//        }
//    }
//}

-(BOOL)shouldAutorotate {
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    if (![self.accel isFirstResponder]) {
        [self.accel becomeFirstResponder];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self launchOrder];
}

- (void)launchOrder {

    [self loadDefaults];
    
    [self createParentView];
    [self createTransportButtons];

    [self initPD];

    dispatch_queue_t pdQueue = dispatch_queue_create("pd queue",NULL);
    dispatch_async(pdQueue, ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"PD is loaded");
            [self loadFiles];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self handleSpinner:1];
                [self handleSpinner:2];
                [self handleSpinner:3];
                
                [self setDefaults];
                [self createMenu];
                [self easyModeAccelerometer];
                [self createClock];
                [self initPopups];
                [self fadeInUI];
            });
        });
    });
}

#pragma mark - Load Initial Settings

- (void) loadDefaults {
    
    pdReceives = @[@"speed",@"level",@"pitch",@"roll",@"yaw",@"acc"];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *path1 = [path stringByAppendingPathComponent:@"defaults1.plist"];
    NSString *path2 = [path stringByAppendingPathComponent:@"defaults2.plist"];
    NSString *path3 = [path stringByAppendingPathComponent:@"defaults3.plist"];
    NSString *ipPath = [path stringByAppendingPathComponent:@"ipaddress.plist"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *defaultsArray = @[@15.0,@30,@80,@1.0,@2.0,@0.0,@25.0,@0.0,@1];
    NSArray *array;
    
    if ([fileManager fileExistsAtPath:ipPath]) {
        array = [[NSArray alloc] initWithContentsOfFile:ipPath];
        if ([array count] > 1 && [array objectAtIndex:1]) {
            self.isUDP = [[array objectAtIndex:1] boolValue];
        }
    }
    
    if (![fileManager fileExistsAtPath:path1]) {
        [fileManager createFileAtPath:path1
                             contents:nil
                           attributes:nil];
        [defaultsArray writeToFile:path1 atomically:YES];
    } else {
        array = [[NSArray alloc] initWithContentsOfFile:path1];
        if ([array count] != [defaultsArray count]) {
            [fileManager removeItemAtPath:path1 error:nil];
            
            [fileManager createFileAtPath:path1
                                 contents:nil
                               attributes:nil];
            [defaultsArray writeToFile:path1 atomically:YES];
        }
    }
    
    if (![fileManager fileExistsAtPath:path2]) {
        [fileManager createFileAtPath:path2
                             contents:nil
                           attributes:nil];
        [defaultsArray writeToFile:path2 atomically:YES];
    } else {
        array = [[NSArray alloc] initWithContentsOfFile:path2];
        if ([array count] != [defaultsArray count]) {
            [fileManager removeItemAtPath:path2 error:nil];
            
            [fileManager createFileAtPath:path2
                                 contents:nil
                               attributes:nil];
            [defaultsArray writeToFile:path2 atomically:YES];
        }
    }
    
    if (![fileManager fileExistsAtPath:path3]) {
        [fileManager createFileAtPath:path3
                             contents:nil
                           attributes:nil];
        [defaultsArray writeToFile:path3 atomically:YES];
    } else {
        array = [[NSArray alloc] initWithContentsOfFile:path3];
        if ([array count] != [defaultsArray count]) {
            [fileManager removeItemAtPath:path3 error:nil];
            
            [fileManager createFileAtPath:path3
                                 contents:nil
                               attributes:nil];
            [defaultsArray writeToFile:path3 atomically:YES];
        }
    }
    
    array = [[NSArray alloc] initWithContentsOfFile:path1];

    self.dur1 = [[array objectAtIndex:0] floatValue];
    self.minVol1 = [[array objectAtIndex:1] floatValue];
    self.maxVol1 = [[array objectAtIndex:2] floatValue];
    self.speed1 = [[array objectAtIndex:3] floatValue];
    self.grainSize1 = [[array objectAtIndex:4] floatValue];
    self.winShape1 = [[array objectAtIndex:5] floatValue];
    self.transposition1 = [[array objectAtIndex:6] floatValue];
    self.reverb1 = [[array objectAtIndex:7] floatValue];
    self.isAccel1 = [[array objectAtIndex:8] intValue];
    
    array = [[NSArray alloc] initWithContentsOfFile:path2];
    
    self.dur2 = [[array objectAtIndex:0] floatValue];
    self.minVol2 = [[array objectAtIndex:1] floatValue];
    self.maxVol2 = [[array objectAtIndex:2] floatValue];
    self.speed2 = [[array objectAtIndex:3] floatValue];
    self.grainSize2 = [[array objectAtIndex:4] floatValue];
    self.winShape2 = [[array objectAtIndex:5] floatValue];
    self.transposition2 = [[array objectAtIndex:6] floatValue];
    self.reverb2 = [[array objectAtIndex:7] floatValue];
    self.isAccel2 = [[array objectAtIndex:8] intValue];
    
    array = [[NSArray alloc] initWithContentsOfFile:path3];
    
    self.dur3 = [[array objectAtIndex:0] floatValue];
    self.minVol3 = [[array objectAtIndex:1] floatValue];
    self.maxVol3 = [[array objectAtIndex:2] floatValue];
    self.speed3 = [[array objectAtIndex:3] floatValue];
    self.grainSize3 = [[array objectAtIndex:4] floatValue];
    self.winShape3 = [[array objectAtIndex:5] floatValue];
    self.transposition3 = [[array objectAtIndex:6] floatValue];
    self.reverb3 = [[array objectAtIndex:7] floatValue];
    self.isAccel3 = [[array objectAtIndex:8] intValue];
}

- (void)setDefaults {
    [self.waveView1.player setRate:self.speed1];
    [self.pd sendFloat:self.grainSize1 toReceiver:@"1.main.preset"];
    [self.pd sendFloat:self.winShape1 toReceiver:@"1.main.shape"];
    [self.pd sendFloat:self.reverb1 toReceiver:@"1.reverb"];
    [self.pd sendFloat:self.maxVol1-10 toReceiver:@"1.main.level"];
    
    float val = self.speed1*100;
    [self.pd sendFloat:val toReceiver:@"1.main.speed"];
    
    val = self.transposition1 - 25;
    [self.pd sendFloat:val toReceiver:@"1.transpose"];
    
    
    [self.waveView2.player setRate:self.speed2];
    [self.pd sendFloat:self.grainSize2 toReceiver:@"2.main.preset"];
    [self.pd sendFloat:self.winShape2 toReceiver:@"2.main.shape"];
    [self.pd sendFloat:self.reverb2 toReceiver:@"2.reverb"];
    [self.pd sendFloat:self.maxVol2-10 toReceiver:@"2.main.level"];
    
    val = self.speed2*100;
    [self.pd sendFloat:val toReceiver:@"2.main.speed"];
    
    val = self.transposition2 - 25;
    [self.pd sendFloat:val toReceiver:@"2.transpose"];
    
    [self.waveView3.player setRate:self.speed3];
    [self.pd sendFloat:self.grainSize3 toReceiver:@"3.main.preset"];
    [self.pd sendFloat:self.winShape3 toReceiver:@"3.main.shape"];
    [self.pd sendFloat:self.reverb3 toReceiver:@"3.reverb"];
    [self.pd sendFloat:self.maxVol3-10 toReceiver:@"3.main.level"];
    
    val = self.speed3*100;
    [self.pd sendFloat:val toReceiver:@"3.main.speed"];
    
    val = self.transposition3 - 25;
    [self.pd sendFloat:val toReceiver:@"3.transpose"];
}

- (void)saveIP {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *array;
        NSString *ipAddress = [NSString stringWithFormat:@"0"];
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        path = [path stringByAppendingPathComponent:@"ipaddress.plist"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:path]) {
            array = [[NSArray alloc] initWithContentsOfFile:path];
            if ([array firstObject]) {
                ipAddress = [array firstObject];
            }
            [fileManager removeItemAtPath:path error:nil];
        }
        array = @[ipAddress, [NSNumber numberWithBool:self.isUDP]];
        [fileManager createFileAtPath:path
                             contents:nil
                           attributes:nil];
        [array writeToFile:path atomically:YES];
    });
}

- (void)loadFiles {
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    
    NSString* file1 = [documentsPath stringByAppendingPathComponent:@"player101.wav"];
    NSString* file2 = [documentsPath stringByAppendingPathComponent:@"player102.wav"];
    NSString* file3 = [documentsPath stringByAppendingPathComponent:@"player103.wav"];
    
    if ([self checkForFile:file1]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pd sendMessage:file1 withArguments:nil toReceiver:[NSString stringWithFormat:@"1.file.url"]];
            [self drawWaveform1:[NSURL fileURLWithPath:file1]];
        });
    } else {
        NSString *defaultItem = [[NSBundle mainBundle] pathForResource:@"GRAIN__strings" ofType:@"wav"];
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"GRAIN__strings" withExtension:@".wav"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pd sendMessage:defaultItem withArguments:nil toReceiver:[NSString stringWithFormat:@"1.file.url"]];
            [self drawWaveform1:url];
        });
    }
    
    if ([self checkForFile:file2]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pd sendMessage:file2 withArguments:nil toReceiver:[NSString stringWithFormat:@"2.file.url"]];
            [self drawWaveform2:[NSURL fileURLWithPath:file2]];
        });
    } else {
        NSString *defaultItem = [[NSBundle mainBundle] pathForResource:@"GRAIN__kalimba" ofType:@"wav"];
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"GRAIN__kalimba" withExtension:@".wav"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pd sendMessage:defaultItem withArguments:nil toReceiver:[NSString stringWithFormat:@"2.file.url"]];
            [self drawWaveform2:url];
        });
    }
    
    if ([self checkForFile:file3]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pd sendMessage:file3 withArguments:nil toReceiver:[NSString stringWithFormat:@"3.file.url"]];
            [self drawWaveform3:[NSURL fileURLWithPath:file3]];
        });
    } else {
        NSString *defaultItem = [[NSBundle mainBundle] pathForResource:@"GRAIN__violin_thump" ofType:@"wav"];
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"GRAIN__violin_thump" withExtension:@".wav"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.pd sendMessage:defaultItem withArguments:nil toReceiver:[NSString stringWithFormat:@"3.file.url"]];
            [self drawWaveform3:url];
        });
    }
    
    [self handleSpinner:1];
    [self handleSpinner:2];
    [self handleSpinner:3];
}

- (void)initPD {
    self.pd = [[NNEasyPD alloc] init];
    NSString *patchString = [NSString stringWithFormat:@"Grain.pd"];
    [self.pd initializeWithPatch:patchString];
}

- (BOOL)checkForFile:(NSString *)filePath {
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    return fileExists;
}

#pragma mark - Accelerometer

- (void)easyModeAccelerometer {
    self.accel = [[NNAccelView alloc] init];
    [self.accel setAlpha:0];
    [self.accel putItHere:self.containerView];
    self.accel.exposesAcceleration = YES;
    self.accel.transformsWithAcceleration = YES;
    [self.accel setShadowColor:UIColorFromHex(0xFEFEFE)];
    [self.accel stopPolling];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0/40.0 target:self selector:@selector(updateAccel:) userInfo:nil repeats:YES];
}

- (void)updateAccel:(NSTimer*)timer {
    [self.accel update];
    
    float pitch = self.accel.pitch;
    float yaw = self.accel.yaw;
    float roll = self.accel.roll;

    float accel = self.accel.acceleration;
    accel = FILTER(accel, lastAccel, .9);
    accel = [nnKit linearToExponential:accel inputMIN:.001 inputMAX:.5 outputMIN:100 outputMAX:150];
    
    roll = fabsf(roll);
    pitch = fabsf(pitch);
    yaw = fabsf(yaw);
    
    roll = pow(roll, 1.6);
    pitch = pow(pitch, 1.6);
    yaw = pow(yaw, 1.6);

    //NSLog(@"%@", [NSString stringWithFormat:@"%f",pitch]);

    if (self.isAccel1) {
        [self.pd sendFloat:pitch toReceiver:@"pitch"];
        [self.pd sendFloat:accel toReceiver:@"1.window"];
    }
    if (self.isAccel2) {
        [self.pd sendFloat:roll toReceiver:@"roll"];
        [self.pd sendFloat:accel toReceiver:@"2.window"];
    }
    if (self.isAccel3) {
        [self.pd sendFloat:yaw toReceiver:@"yaw"];
        [self.pd sendFloat:accel toReceiver:@"3.window"];
    }
}

#pragma mark - Setup UI

- (void)fadeInUI {
    [self.transport1 setAlpha:1];
    [self.transport2 setAlpha:1];
    [self.transport3 setAlpha:1];
    [clock setAlpha:1];
    [self.accel setAlpha:1];
    [nnKit animateViewGrowAndShow:self.transport1 or:nil completion:nil];
    [nnKit animateViewGrowAndShow:self.transport2 or:nil completion:nil];
    [nnKit animateViewGrowAndShow:self.transport3 or:nil completion:nil];
    [nnKit animateViewGrowAndShow:clock or:nil completion:nil];
    [nnKit animateViewGrowAndShow:self.accel or:nil completion:nil];
    if (self.isUDP) {
        [self createSignalIcon];
    }
    isLoaded = YES;
}

- (void)createParentView {
    self.containerView = [[UIView alloc] initWithFrame:self.view.bounds];
    UIColor *color = UIColorFromHex(0x42729B);
    [self.containerView setBackgroundColor:color];
    [self.containerView setUserInteractionEnabled:YES];
    [self.view addSubview:self.containerView];
    
    self.parentView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.parentView setBackgroundColor:[UIColor clearColor]];
    [self.parentView setUserInteractionEnabled:YES];
    [self.containerView addSubview:self.parentView];
    
    self.popupView = [[PassThroughView alloc] initWithFrame:self.view.bounds];
    [self.popupView setBackgroundColor:[UIColor clearColor]];
    [self.popupView setUserInteractionEnabled:YES];
    [self.containerView addSubview:self.popupView];
    
    self.menuView = [[PassThroughView alloc] initWithFrame:self.view.bounds];
    [self.menuView setBackgroundColor:[UIColor clearColor]];
    [self.menuView setUserInteractionEnabled:YES];
    [self.containerView addSubview:self.menuView];
}

- (void)initPopups {
    self.popup1 = [nnMediaPickerPopUp initWithID:101];
    self.popup1.delegate = self;
    
    self.popup2 = [nnMediaPickerPopUp initWithID:102];
    self.popup2.delegate = self;
    
    self.popup3 = [nnMediaPickerPopUp initWithID:103];
    self.popup3.delegate = self;
}

- (void)createMenu {
    NSArray *imageList;
    int margin;
    
    if ([nnKit isIPhone5orIPodTouch]) {
        imageList = @[[UIImage imageNamed:@"sliders1.pdf"], [UIImage imageNamed:@"sliders2.pdf"], [UIImage imageNamed:@"sliders3.pdf"], [UIImage imageNamed:@"www.pdf"], [UIImage imageNamed:@"controller2.pdf"], [UIImage imageNamed:@"home.pdf"], [UIImage imageNamed:@"question.pdf"]];
        margin = 25;
    } else {
        imageList = @[[UIImage imageNamed:@"sliders1.pdf"], [UIImage imageNamed:@"sliders2.pdf"], [UIImage imageNamed:@"sliders3.pdf"], [UIImage imageNamed:@"www.pdf"], [UIImage imageNamed:@"controller2.pdf"], [UIImage imageNamed:@"home.pdf"], [UIImage imageNamed:@"question.pdf"],[UIImage imageNamed:@"close.pdf"]];
        margin = 35;
    }
    
    sideBar = [[CDSideBarController alloc] initWithImages:imageList andUpperMargin:margin];
    sideBar.delegate = self;
    [sideBar insertMenuButtonOnView:self.menuView atPosition:CGPointMake(self.menuView.frame.size.width - 50, 27)];
}

- (void)createClock {
    CGRect clockFrame;
    CGPoint clockCenter;
    
    if ([nnKit isIPad]) {
        clockFrame = CGRectMake(0, 0, SW()/2, 70);
        clockCenter = CGPointMake(SW()/2, self.accel.center.y);
    } else {
        clockFrame = CGRectMake(0, 0, SW()/2, 44);
        clockCenter = CGPointMake(SW()/2, sideBar.menuButton.center.y);
    }
    
    clock = [[NNClock alloc] initWithFrame:clockFrame];
    clock.center = clockCenter;
    [clock setAlpha:0];
    [self.parentView addSubview:clock];
}

- (void)createTransportButtons {

    self.transport1 = [nnKit makeButtonWithImage:[UIImage imageNamed:@"play.pdf"] frame:CGRectMake(10, SH()/5, 50, 50) method:@"tapTransportButton:" fromClass:self];
    self.transport2 = [nnKit makeButtonWithImage:[UIImage imageNamed:@"play.pdf"] frame:CGRectMake(10, SH()/5+((SH()/5)*1.5), 50, 50) method:@"tapTransportButton:" fromClass:self];
    self.transport3 = [nnKit makeButtonWithImage:[UIImage imageNamed:@"play.pdf"] frame:CGRectMake(10, SH()/5+((SH()/5)*3), 50, 50) method:@"tapTransportButton:" fromClass:self];
    
    self.transport1.tag = 1;
    self.transport2.tag = 2;
    self.transport3.tag = 3;
    
    UILongPressGestureRecognizer *lp1 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(lpTransportButton:)];
    UILongPressGestureRecognizer *lp2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(lpTransportButton:)];
    UILongPressGestureRecognizer *lp3 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(lpTransportButton:)];
    
    lp1.delaysTouchesEnded = NO;
    lp2.delaysTouchesEnded = NO;
    lp3.delaysTouchesEnded = NO;
    
    [self.transport1 addGestureRecognizer:lp1];
    [self.transport2 addGestureRecognizer:lp2];
    [self.transport3 addGestureRecognizer:lp3];
    
    [self.transport1 setAlpha:0];
    [self.transport2 setAlpha:0];
    [self.transport3 setAlpha:0];
    
    [self.parentView addSubview:self.transport1];
    [self.parentView addSubview:self.transport2];
    [self.parentView addSubview:self.transport3];
}

#pragma mark - Draw waveform views

- (void)drawWaveform1:(NSURL*)url {
    if (self.waveView1) {
        [self.waveView1.player stop];
        [self.waveView1 removeFromSuperview];
    }
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    UIColor *normalColor = UIColorFromHex(0xDAEAEF);
    UIColor *fillColor = UIColorFromHex(0x8CBEB2);
    self.waveView1 = [[nnWaveformPlayerView alloc] initWithFrame:CGRectMake(60, 0, SW()-80, SH()*.275) asset:asset color:normalColor progressColor:fillColor];
    self.waveView1.delegate = self;
    self.waveView1.tag = 1;
    self.waveView1.player.volume = 0;
    [self.waveView1.player setEnableRate:YES];
    [self.waveView1.player setRate:self.speed1];
    self.waveView1.loops = YES;
    self.waveView1.center = CGPointMake(self.waveView1.center.x, self.transport1.center.y);
    [self.parentView addSubview:self.waveView1];
    [nnKit animateViewGrowAndShow:self.waveView1 or:nil completion:nil];
    
    self.waveView1.layer.shadowOpacity = 0.0;
    self.waveView1.layer.shadowRadius = 0.0;
    //self.waveView1.layer.shadowColor = fillColor.CGColor;
    self.waveView1.layer.shadowColor = [UIColor flatDarkGreenColor].CGColor;
    self.waveView1.layer.shadowOffset = CGSizeMake(1.0, 1.0);
}

- (void)drawWaveform2:(NSURL*)url {
    if (self.waveView2) {
        [self.waveView2.player stop];
        [self.waveView2 removeFromSuperview];
    }
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    UIColor *normalColor = UIColorFromHex(0xDAEAEF);
    UIColor *fillColor = UIColorFromHex(0xE68364);
    self.waveView2 = [[nnWaveformPlayerView alloc] initWithFrame:CGRectMake(60, 0, SW()-80, SH()*.275) asset:asset color:normalColor progressColor:fillColor];
    self.waveView2.delegate = self;
    self.waveView2.tag = 2;
    self.waveView2.player.volume = 0;
    [self.waveView2.player setEnableRate:YES];
    [self.waveView2.player setRate:self.speed2];
    self.waveView2.loops = YES;
    self.waveView2.center = CGPointMake(self.waveView2.center.x, self.transport2.center.y);
    [self.parentView addSubview:self.waveView2];
    [nnKit animateViewGrowAndShow:self.waveView2 or:nil completion:nil];
    
    self.waveView2.layer.shadowOpacity = 0.0;
    self.waveView2.layer.shadowRadius = 0.0;
    //self.waveView2.layer.shadowColor = fillColor.CGColor;
    self.waveView2.layer.shadowColor = [UIColor flatDarkOrangeColor].CGColor;
    self.waveView2.layer.shadowOffset = CGSizeMake(1.0, 1.0);
}

- (void)drawWaveform3:(NSURL*)url {
    if (self.waveView3) {
        [self.waveView3.player stop];
        [self.waveView3 removeFromSuperview];
    }
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    UIColor *normalColor = UIColorFromHex(0xDAEAEF);
    UIColor *fillColor = UIColorFromHex(0xAEA8D3);
    self.waveView3 = [[nnWaveformPlayerView alloc] initWithFrame:CGRectMake(60, 0, SW()-80, SH()*.275) asset:asset color:normalColor progressColor:fillColor];
    self.waveView3.delegate = self;
    self.waveView3.tag = 3;
    self.waveView3.player.volume = 0;
    [self.waveView3.player setEnableRate:YES];
    [self.waveView3.player setRate:self.speed3];
    self.waveView3.loops = YES;
    self.waveView3.center = CGPointMake(self.waveView3.center.x, self.transport3.center.y);
    [self.parentView addSubview:self.waveView3];
    [nnKit animateViewGrowAndShow:self.waveView3 or:nil completion:nil];
    
    self.waveView3.layer.shadowOpacity = 0.0;
    self.waveView3.layer.shadowRadius = 0.0;
    self.waveView3.layer.shadowColor = [UIColor flatDarkPurpleColor].CGColor;
    self.waveView3.layer.shadowOffset = CGSizeMake(1.0, 1.0);
}

#pragma mark - UDP Connect Popup

- (void)makeUDPConnectPopup {
    [self.parentView setUserInteractionEnabled:NO];
    [self.accel setUserInteractionEnabled:NO];
    udpCloseView = [[UIView alloc] initWithFrame:self.view.frame];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissUDPConnectPopup)];
    [udpCloseView  addGestureRecognizer:tap];
    
    [self.containerView addSubview:udpCloseView];
    
    udpView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width*.95, self.view.bounds.size.height/2)];
    udpView.backgroundColor = [UIColor whiteColor];
    udpView.center = CGPointMake(self.view.center.x, self.view.bounds.size.height/2);
    udpView.layer.cornerRadius = 8;
    udpView.layer.masksToBounds = YES;
    
    NNToggle *toggle = [[NNToggle alloc] initWithFrame:CGRectMake( 0, 0, 60, 60)];
    toggle.delegate = self;
    toggle.center = CGPointMake(udpView.center.x, udpView.bounds.size.height-(udpView.bounds.size.height/5));
    toggle.tag = 4;
    toggle.isOn = self.isUDP;
    
    instructLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, udpView.bounds.size.width, 70)];
    instructLabel.center = CGPointMake(udpView.center.x, udpView.bounds.size.height/5);
    instructLabel.textAlignment = NSTextAlignmentCenter;
    instructLabel.textColor = [UIColor flatBlackColor];
    instructLabel.font = [UIFont fontWithName:nnKitGlobalFont size:SW()/16];
    
    ipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, udpView.bounds.size.width, 70)];
    ipLabel.center = CGPointMake(udpView.center.x, udpView.bounds.size.height/2);
    ipLabel.textAlignment = NSTextAlignmentCenter;
    ipLabel.textColor = [UIColor flatBlackColor];
    ipLabel.font = [UIFont fontWithName:nnKitGlobalFont size:SW()/12];
    
    if (self.isUDP) {
        NSString *ipAddress = [nnKit getIPAddress:YES];
        instructLabel.text = [NSString stringWithFormat:@"Your IP Address:"];
        ipLabel.text = [NSString stringWithFormat:@"%@",ipAddress];
    } else {
        instructLabel.text = [NSString stringWithFormat:@"Toggle WiFi Connect?"];
    }
    
    [udpView addSubview:instructLabel];
    [udpView addSubview:ipLabel];
    [udpView addSubview:toggle];
    
    [self.containerView addSubview:udpView];
    [nnKit animateViewGrowAndShow:udpView or:nil completion:nil];
}

- (void)dismissUDPConnectPopup {
    [udpCloseView removeFromSuperview];
    udpCloseView = nil;
    [self.parentView setUserInteractionEnabled:YES];
    [self.accel setUserInteractionEnabled:YES];
    
    [nnKit animateViewShrinkAndWink:udpView or:nil andRemoveFromSuperview:YES completion:nil];
    [self saveIP];
}

- (void)toggleUDP:(NNToggle *)toggle {
    if (self.isUDP) {
        [self setupSocket];
        [self createSignalIcon];
        NSString *ipAddress = [nnKit getIPAddress:YES];
        instructLabel.text = [NSString stringWithFormat:@"Your IP Address:"];
        ipLabel.text = [NSString stringWithFormat:@"%@",ipAddress];
    } else {
        udpSocket = nil;
        [nnKit animateViewShrinkAndWink:nil or:signalIcon andRemoveFromSuperview:YES completion:nil];
        instructLabel.text = [NSString stringWithFormat:@"Toggle WiFi Connect?"];
        ipLabel.text = [NSString stringWithFormat:@""];
    }
}

- (void)createSignalIcon {
    signalIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, sideBar.menuButton.frame.size.width*.9, sideBar.menuButton.frame.size.width*.9)];
    signalIcon.image = [UIImage imageNamed:@"radio_signal.pdf"];
    
    float centerY;
    if ([nnKit isIPad]) {
        centerY = sideBar.menuButton.center.y;
    } else {
        centerY = clock.center.y;
    }
    
    signalIcon.center = CGPointMake(SW()-sideBar.menuButton.frame.size.width*2, centerY);
    [self.parentView addSubview:signalIcon];
    [nnKit animateViewGrowAndShow:nil or:signalIcon completion:nil];
}

#pragma mark - Settings Menus

- (void)createSettingsView:(int)menuNumber {
    
    menu = menuNumber;
    settingsView = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height)];
    settingsView.alpha = 0;
    
    UIColor *color;
    
    switch (menu) {
        case 1:
            color = UIColorFromHex(0x8CBEB2);
            break;
        case 2:
            color = UIColorFromHex(0xE68364);
            break;
        case 3:
            color = UIColorFromHex(0xAEA8D3);
            break;
            
        default:
            break;
    }
    
    [settingsView setBackgroundColor:color];
    
    [self setupSliders:NO];
    [self setupLabels];
    [self setupButtons];
    
    [self.containerView addSubview:settingsView];
    
    [UIView animateWithDuration:kFadeTime
                          delay:kFadeDelay
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                        settingsView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -settingsView.frame.size.width, 0);
                         settingsView.alpha = 1;
                     } completion:nil
     ];
}

- (void)setupSliders:(BOOL)isOpen {
    
    if (isOpen) {
        for (id subview in settingsView.subviews) {
            if ([subview isMemberOfClass:[NNSlider class]]) {
                [subview removeFromSuperview];
            }
        }
    }
    
    float sliderWidth;
    float sliderHeight;
    
    if ([nnKit isIPad]) {
        sliderWidth = SW()*.14;
        sliderHeight = SH()*.2;
    } else {
        if ([nnKit isIPhone5orIPodTouch]) {
            sliderWidth = SW()*.16;
            sliderHeight = SH()*.25;
        } else {
            sliderWidth = SW()*.15;
            sliderHeight = SH()*.25;
        }
    }
    
    float topMargin = SH()*.075;
    float oneCenter = SW()*.15;
    float twoCenter = SW()*(.15+(.7/3));
    float threeCenter = SW()*(.85-(.7/3));
    float fourCenter = SW()*.85;
    
    float dur;
    float minVol;
    float maxVol;
    float speed;
    float grainSize;
    float winShape;
    float transposition;
    float reverb;
    
    switch (menu) {
        case 1:
            dur = self.dur1;
            minVol = self.minVol1;
            maxVol = self.maxVol1;
            speed = self.speed1;
            grainSize = self.grainSize1;
            winShape = self.winShape1;
            transposition = self.transposition1;
            reverb = self.reverb1;
            break;
        case 2:
            dur = self.dur2;
            minVol = self.minVol2;
            maxVol = self.maxVol2;
            speed = self.speed2;
            grainSize = self.grainSize2;
            winShape = self.winShape2;
            transposition = self.transposition2;
            reverb = self.reverb2;
            break;
        case 3:
            dur = self.dur3;
            minVol = self.minVol3;
            maxVol = self.maxVol3;
            speed = self.speed3;
            grainSize = self.grainSize3;
            winShape = self.winShape3;
            transposition = self.transposition3;
            reverb = self.reverb3;
            break;
        default:
            break;
    }
    
    NNSlider *slider1 = [[NNSlider alloc] initWithFrame:CGRectMake(0, topMargin, sliderWidth, sliderHeight)];
    [slider1 setCenter:CGPointMake(oneCenter, slider1.center.y)];
    [slider1 addTarget:self action:@selector(slider1Action:) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragInside];
    slider1.shouldDoCoolAnimation = NO;
    slider1.value = dur*.01;
    slider1.minValue = .005;
    slider1.valueScale = .645;
    slider1.knobColor = [slider1.lineColor complement];
    
    NNSlider *slider2 = [[NNSlider alloc] initWithFrame:CGRectMake(0, topMargin, sliderWidth, sliderHeight)];
    [slider2 setCenter:CGPointMake(twoCenter, slider2.center.y)];
    [slider2 addTarget:self action:@selector(slider2Action:) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragInside];
    slider2.shouldDoCoolAnimation = NO;
    slider2.value = minVol*.01;
    slider2.valueScale = .5;
    slider2.knobColor = [slider2.lineColor complement];
    
    NNSlider *slider3 = [[NNSlider alloc] initWithFrame:CGRectMake(0, topMargin, sliderWidth, sliderHeight)];
    [slider3 setCenter:CGPointMake(threeCenter, slider3.center.y)];
    [slider3 addTarget:self action:@selector(slider3Action:) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragInside];
    slider3.shouldDoCoolAnimation = NO;
    slider3.value = maxVol*.01;
    slider3.minValue = .5;
    slider3.valueScale = .5;
    slider3.knobColor = [slider3.lineColor complement];
    
    NNSlider *slider4 = [[NNSlider alloc] initWithFrame:CGRectMake(0, topMargin, sliderWidth, sliderHeight)];
    [slider4 setCenter:CGPointMake(fourCenter, slider4.center.y)];
    [slider4 addTarget:self action:@selector(slider4Action:) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragInside];
    slider4.shouldDoCoolAnimation = NO;
    slider4.value = speed;
    slider4.valueScale = 4;
    slider4.knobColor = [slider4.lineColor complement];
    
    float secondRowOffset;
    if ([nnKit isIPad]) {
        secondRowOffset = topMargin * 3.5;
    } else {
        secondRowOffset = topMargin * 3;
    }
    
    NNSlider *slider5 = [[NNSlider alloc] initWithFrame:CGRectMake(0, secondRowOffset+sliderHeight, sliderWidth, sliderHeight)];
    [slider5 setCenter:CGPointMake(oneCenter, slider5.center.y)];
    [slider5 addTarget:self action:@selector(slider5Action:) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragInside];
    slider5.shouldDoCoolAnimation = NO;
    slider5.isSegmented = YES;
    slider5.segments = 7;
    slider5.isInt = YES;
    slider5.valueScale = 7;
    slider5.value = grainSize;
    slider5.knobColor = [slider5.lineColor complement];
    
    NNSlider *slider6 = [[NNSlider alloc] initWithFrame:CGRectMake(0, secondRowOffset+sliderHeight, sliderWidth, sliderHeight)];
    [slider6 setCenter:CGPointMake(twoCenter, slider6.center.y)];
    [slider6 addTarget:self action:@selector(slider6Action:) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragInside];
    slider6.shouldDoCoolAnimation = NO;
    slider6.valueScale = 25;
    slider6.isSegmented = YES;
    slider6.segments = 25;
    slider6.isInt = YES;
    slider6.value = winShape;
    slider6.knobColor = [slider6.lineColor complement];
    
    NNSlider *slider7 = [[NNSlider alloc] initWithFrame:CGRectMake(0, secondRowOffset+sliderHeight, sliderWidth, sliderHeight)];
    [slider7 setCenter:CGPointMake(threeCenter, slider7.center.y)];
    [slider7 addTarget:self action:@selector(slider7Action:) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragInside];
    slider7.shouldDoCoolAnimation = NO;
    slider7.valueScale = 50;
    slider7.isSegmented = YES;
    slider7.segments = 50;
    slider7.isInt = YES;
    slider7.value = transposition;
    slider7.knobColor = [slider7.lineColor complement];
    
    NNSlider *slider8 = [[NNSlider alloc] initWithFrame:CGRectMake(0, secondRowOffset+sliderHeight, sliderWidth, sliderHeight)];
    [slider8 setCenter:CGPointMake(fourCenter, slider8.center.y)];
    [slider8 addTarget:self action:@selector(slider8Action:) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragInside];
    slider8.shouldDoCoolAnimation = NO;
    slider8.value = reverb;
    slider8.knobColor = [slider8.lineColor complement];
    
    [settingsView addSubview:slider1];
    [settingsView addSubview:slider2];
    [settingsView addSubview:slider3];
    [settingsView addSubview:slider4];
    [settingsView addSubview:slider5];
    [settingsView addSubview:slider6];
    [settingsView addSubview:slider7];
    [settingsView addSubview:slider8];
}

- (void)setupButtons {
    float buttonSize = SW()/6.5;
    float buttonBottomOffset = SH()-(buttonSize*1.25);
    
    UIButton *closeButton = [nnKit makeButtonWithImage:[UIImage imageNamed:@"back.png"] frame:CGRectMake(0, buttonBottomOffset, buttonSize, buttonSize) method:@"closeSettingsView:" fromClass:self];
    [closeButton setCenter:CGPointMake(SW()*.8, closeButton.center.y)];
    
    UIButton *defaultButton = [nnKit makeButtonWithImage:[UIImage imageNamed:@"defaults.png"] frame:CGRectMake(0, buttonBottomOffset, buttonSize, buttonSize) method:@"resetDefaults:" fromClass:self];
    [defaultButton setCenter:CGPointMake(SW()*.6, defaultButton.center.y)];
    
    UIButton *helpButton = [nnKit makeButtonWithImage:[UIImage imageNamed:@"question.png"] frame:CGRectMake(0, buttonBottomOffset, buttonSize, buttonSize) method:@"settingsHelp:" fromClass:self];
    [helpButton setCenter:CGPointMake(SW()*.4, helpButton.center.y)];
    
    NNToggle *toggle = [[NNToggle alloc] initWithFrame:CGRectMake(0, buttonBottomOffset, buttonSize, buttonSize)];
    toggle.delegate = self;
    toggle.center = CGPointMake(SW()*.2, toggle.center.y);
    toggle.imageSize = .8;
    toggle.image = [UIImage imageNamed:@"arrowtop.pdf"];
    toggle.tag = menu;

    switch (menu) {
        case 1:
            toggle.isOn = self.isAccel1;
            break;
        case 2:
            toggle.isOn = self.isAccel2;
            break;
        case 3:
            toggle.isOn = self.isAccel3;
            break;
            
        default:
            break;
    }
    
    [settingsView addSubview:defaultButton];
    [settingsView addSubview:closeButton];
    [settingsView addSubview:helpButton];
    [settingsView addSubview:toggle];
}

- (void)setupLabels {
    float labelHeight = SH()*.07;
    float topMargin = SH()*.075;
    float sliderHeight = SH()*.25;
    float oneCenter = SW()*.15;
    float twoCenter = SW()*(.15+(.7/3));
    float threeCenter = SW()*(.85-(.7/3));
    float fourCenter = SW()*.85;
    
    float labelOffset;
    float labelOffset2;
    
    if ([nnKit isIPad]) {
        labelOffset = sliderHeight+topMargin+(labelHeight/2)+2;
        labelOffset2 = ((sliderHeight*2)+(topMargin*3)+(labelHeight/2)+4);
    } else {
        labelOffset = sliderHeight+topMargin+labelHeight+2;
        labelOffset2 = ((sliderHeight*2)+(topMargin*3)+labelHeight+4);
    }
    
    UILabel *durLabel = [nnKit makeLabelWithCenter:CGPointMake(oneCenter, labelOffset) fontSize: SW()/20 text:@"Duration"];
    UILabel *minVolLabel = [nnKit makeLabelWithCenter:CGPointMake(twoCenter, labelOffset) fontSize:SW()/20 text:@"Min Gain"];
    UILabel *maxVolLabel = [nnKit makeLabelWithCenter:CGPointMake(threeCenter, labelOffset) fontSize:SW()/20 text:@"Max Gain"];
    UILabel *speedLabel = [nnKit makeLabelWithCenter:CGPointMake(fourCenter, labelOffset) fontSize:SW()/20 text:@"Speed"];
    
    UILabel *grainSizeLabel = [nnKit makeLabelWithCenter:CGPointMake(oneCenter, labelOffset2) fontSize:SW()/20 text:@"Grain Size"];
    UILabel *winShapeLabel = [nnKit makeLabelWithCenter:CGPointMake(twoCenter, labelOffset2) fontSize:SW()/20 text:@"Win Shape"];
    UILabel *transposeLabel = [nnKit makeLabelWithCenter:CGPointMake(threeCenter, labelOffset2) fontSize:SW()/20 text:@"Transpose"];
    UILabel *reverbLabel = [nnKit makeLabelWithCenter:CGPointMake(fourCenter, labelOffset2) fontSize:SW()/20 text:@"Reverb"];
    
    [durLabel setTextColor:[UIColor flatWhiteColor]];
    [minVolLabel setTextColor:[UIColor flatWhiteColor]];
    [maxVolLabel setTextColor:[UIColor flatWhiteColor]];
    [speedLabel setTextColor:[UIColor flatWhiteColor]];
    [grainSizeLabel setTextColor:[UIColor flatWhiteColor]];
    [winShapeLabel setTextColor:[UIColor flatWhiteColor]];
    [transposeLabel setTextColor:[UIColor flatWhiteColor]];
    [reverbLabel setTextColor:[UIColor flatWhiteColor]];
    
    [settingsView addSubview:durLabel];
    [settingsView addSubview:minVolLabel];
    [settingsView addSubview:maxVolLabel];
    [settingsView addSubview:speedLabel];
    [settingsView addSubview:grainSizeLabel];
    [settingsView addSubview:winShapeLabel];
    [settingsView addSubview:transposeLabel];
    [settingsView addSubview:reverbLabel];
}

- (void)slider1Action:(NNSlider*)slider {
    switch (menu) {
        case 1:
            self.dur1 = MAX(1, slider.value*100);
            break;
        case 2:
            self.dur2 = MAX(1, slider.value*100);
            break;
        case 3:
            self.dur3 = MAX(1, slider.value*100);
            break;
            
        default:
            break;
    }
}
- (void)slider2Action:(NNSlider*)slider {
    switch (menu) {
        case 1:
            self.minVol1 = slider.value*100;
            break;
        case 2:
            self.minVol2 = slider.value*100;
            break;
        case 3:
            self.minVol3 = slider.value*100;
            break;
            
        default:
            break;
    }
}
- (void)slider3Action:(NNSlider*)slider {
    switch (menu) {
        case 1:
            self.maxVol1 = (slider.value)*100;
            break;
        case 2:
            self.maxVol2 = (slider.value)*100;
            break;
        case 3:
            self.maxVol3 = (slider.value)*100;
            break;
            
        default:
            break;
    }
}
- (void)slider4Action:(NNSlider*)slider {
    float val;
    switch (menu) {
        case 1:
            self.speed1 = slider.value;
            [self.waveView1.player setRate:self.speed1];
            val = slider.value*100;
            [self.pd sendFloat:val toReceiver:@"1.main.speed"];
            break;
        case 2:
            self.speed2 = slider.value;
            [self.waveView2.player setRate:self.speed2];
            val = slider.value*100;
            [self.pd sendFloat:val toReceiver:@"2.main.speed"];
            break;
        case 3:
            self.speed3 = slider.value;
            [self.waveView3.player setRate:self.speed3];
            val = slider.value*100;
            [self.pd sendFloat:val toReceiver:@"3.main.speed"];
            break;
            
        default:
            break;
    }
}
- (void)slider5Action:(NNSlider*)slider {
    switch (menu) {
        case 1:
            if (slider.value != lastSlider5Value) {
                lastSlider5Value = slider.value;
                self.grainSize1 = slider.value;
                [self.pd sendFloat:self.grainSize1 toReceiver:@"1.main.preset"];
            }
            break;
        case 2:
            if (slider.value != lastSlider5Value) {
                lastSlider5Value = slider.value;
                self.grainSize2 = slider.value;
                [self.pd sendFloat:self.grainSize2 toReceiver:@"2.main.preset"];
            }
            break;
        case 3:
            if (slider.value != lastSlider5Value) {
                lastSlider5Value = slider.value;
                self.grainSize3 = slider.value;
                [self.pd sendFloat:self.grainSize3 toReceiver:@"3.main.preset"];
            }
            break;
            
        default:
            break;
    }
}
- (void)slider6Action:(NNSlider*)slider {
    switch (menu) {
        case 1:
            if (slider.value != lastSlider6Value) {
                lastSlider6Value = slider.value;
                self.winShape1 = slider.value;
                [self.pd sendFloat:self.winShape1 toReceiver:@"1.main.shape"];
            }
            break;
        case 2:
            if (slider.value != lastSlider6Value) {
                lastSlider6Value = slider.value;
                self.winShape2 = slider.value;
                [self.pd sendFloat:self.winShape2 toReceiver:@"2.main.shape"];
            }
            break;
        case 3:
            if (slider.value != lastSlider6Value) {
                lastSlider6Value = slider.value;
                self.winShape3 = slider.value;
                [self.pd sendFloat:self.winShape3 toReceiver:@"3.main.shape"];
            }
            break;
            
        default:
            break;
    }
}
- (void)slider7Action:(NNSlider*)slider {
    float val;
    switch (menu) {
        case 1:
            if (slider.value != lastSlider7Value) {
                lastSlider7Value = slider.value;
                self.transposition1 = slider.value;
                val = self.transposition1 - 25;
                [self.pd sendFloat:val toReceiver:@"1.transpose"];
            }
            break;
        case 2:
            if (slider.value != lastSlider7Value) {
                lastSlider7Value = slider.value;
                self.transposition2 = slider.value;
                val = self.transposition2 - 25;
                [self.pd sendFloat:val toReceiver:@"2.transpose"];
            }
            break;
        case 3:
            if (slider.value != lastSlider7Value) {
                lastSlider7Value = slider.value;
                self.transposition3 = slider.value;
                val = self.transposition3 - 25;
                [self.pd sendFloat:val toReceiver:@"3.transpose"];
            }
            break;
            
        default:
            break;
    }
}
- (void)slider8Action:(NNSlider*)slider {
    switch (menu) {
        case 1:
            self.reverb1 = slider.value;
            [self.pd sendFloat:self.reverb1 toReceiver:@"1.reverb"];
            break;
        case 2:
            self.reverb2 = slider.value;
            [self.pd sendFloat:self.reverb2 toReceiver:@"2.reverb"];
            break;
        case 3:
            self.reverb3 = slider.value;
            [self.pd sendFloat:self.reverb3 toReceiver:@"3.reverb"];
            break;
            
        default:
            break;
    }
}

- (void)resetDefaults:(UIButton*)button {
    [nnKit animateViewJiggle:button];
    
    float dur = 15.0;
    float minVol = 30;
    float maxVol = 80;
    float speed = 1.0;
    float grainSize = 2;
    float winShape = 0;
    float transposition = 25;
    float reverb = 0;
    
    switch (menu) {
        case 1:
            self.dur1 = dur;
            self.minVol1 = minVol;
            self.maxVol1 = maxVol;
            self.speed1 = speed;
            self.grainSize1 = grainSize;
            self.winShape1 = winShape;
            self.transposition1 = transposition;
            self.reverb1 = reverb;
            
            [self.waveView1.player setRate:self.speed1];
            speed = self.speed1*100;
            [self.pd sendFloat:speed toReceiver:@"1.main.speed"];
            [self.pd sendFloat:self.grainSize1 toReceiver:@"1.main.preset"];
            [self.pd sendFloat:self.winShape1 toReceiver:@"1.main.shape"];
            transposition = self.transposition1 - 25;
            [self.pd sendFloat:transposition toReceiver:@"1.transpose"];
            [self.pd sendFloat:self.reverb1 toReceiver:@"1.reverb"];
            break;
        case 2:
            self.dur2 = dur;
            self.minVol2 = minVol;
            self.maxVol2 = maxVol;
            self.speed2 = speed;
            self.grainSize2 = grainSize;
            self.winShape2 = winShape;
            self.transposition2 = transposition;
            self.reverb2 = reverb;
            
            [self.waveView2.player setRate:self.speed2];
            speed = self.speed2*100;
            [self.pd sendFloat:speed toReceiver:@"2.main.speed"];
            [self.pd sendFloat:self.grainSize2 toReceiver:@"2.main.preset"];
            [self.pd sendFloat:self.winShape2 toReceiver:@"2.main.shape"];
            transposition = self.transposition2 - 25;
            [self.pd sendFloat:transposition toReceiver:@"2.transpose"];
            [self.pd sendFloat:self.reverb2 toReceiver:@"2.reverb"];
            break;
        case 3:
            self.dur3 = dur;
            self.minVol3 = minVol;
            self.maxVol3 = maxVol;
            self.speed3 = speed;
            self.grainSize3 = grainSize;
            self.winShape3 = winShape;
            self.transposition3 = transposition;
            self.reverb3 = reverb;
            
            [self.waveView3.player setRate:self.speed3];
            speed = self.speed3*100;
            [self.pd sendFloat:speed toReceiver:@"3.main.speed"];
            [self.pd sendFloat:self.grainSize3 toReceiver:@"3.main.preset"];
            [self.pd sendFloat:self.winShape3 toReceiver:@"3.main.shape"];
            transposition = self.transposition3 - 25;
            [self.pd sendFloat:transposition toReceiver:@"3.transpose"];
            [self.pd sendFloat:self.reverb3 toReceiver:@"3.reverb"];
            break;
            
        default:
            break;
    }

    [self setupSliders:YES];
}

- (void)closeSettingsView:(UIButton*)button {
    [nnKit animateViewJiggle:button];
    [UIView animateWithDuration:kFadeTime/2
                          delay:kFadeDelay
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         settingsView.alpha = 0;
                     } completion:nil
     ];
    [UIView animateWithDuration:kFadeTime
                          delay:kFadeDelay
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         settingsView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, settingsView.frame.size.width, 0);
                     } completion:^(BOOL finished){
                         if (finished) {
                             [settingsView removeFromSuperview];
                             settingsView = nil;
                         }
                     }
     ];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *defaultsArray;
        NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        switch (menu) {
            case 1:
                path = [path stringByAppendingPathComponent:@"defaults1.plist"];
                defaultsArray = @[[NSNumber numberWithFloat:self.dur1],
                                  [NSNumber numberWithFloat:self.minVol1],
                                  [NSNumber numberWithFloat:self.maxVol1],
                                  [NSNumber numberWithFloat:self.speed1],
                                  [NSNumber numberWithFloat:self.grainSize1],
                                  [NSNumber numberWithFloat:self.winShape1],
                                  [NSNumber numberWithFloat:self.transposition1],
                                  [NSNumber numberWithFloat:self.reverb1],
                                  [NSNumber numberWithInt:self.isAccel1]];
                break;
            case 2:
                path = [path stringByAppendingPathComponent:@"defaults2.plist"];
                defaultsArray = @[[NSNumber numberWithFloat:self.dur2],
                                  [NSNumber numberWithFloat:self.minVol2],
                                  [NSNumber numberWithFloat:self.maxVol2],
                                  [NSNumber numberWithFloat:self.speed2],
                                  [NSNumber numberWithFloat:self.grainSize2],
                                  [NSNumber numberWithFloat:self.winShape2],
                                  [NSNumber numberWithFloat:self.transposition2],
                                  [NSNumber numberWithFloat:self.reverb2],
                                  [NSNumber numberWithInt:self.isAccel2]];
                break;
            case 3:
                path = [path stringByAppendingPathComponent:@"defaults3.plist"];
                defaultsArray = @[[NSNumber numberWithFloat:self.dur3],
                                  [NSNumber numberWithFloat:self.minVol3],
                                  [NSNumber numberWithFloat:self.maxVol3],
                                  [NSNumber numberWithFloat:self.speed3],
                                  [NSNumber numberWithFloat:self.grainSize3],
                                  [NSNumber numberWithFloat:self.winShape3],
                                  [NSNumber numberWithFloat:self.transposition3],
                                  [NSNumber numberWithFloat:self.reverb3],
                                  [NSNumber numberWithInt:self.isAccel3]];
                break;
            default:
                break;
        }
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        if ([fileManager fileExistsAtPath:path]) {
            [fileManager removeItemAtPath:path error:nil];
            
            [fileManager createFileAtPath:path
                                 contents:nil
                               attributes:nil];

            [defaultsArray writeToFile:path atomically:YES];
        }
    });
}

- (void)settingsHelp:(UIButton*)button {
    [nnKit animateViewJiggle:button];
}

#pragma mark - Tap transport button actions

- (void)tapTransportButton:(UIButton*)button {
    [nnKit animateViewBigJiggle:button];
    switch (button.tag) {
        case 1:
            if (self.waveView1) {
                if (oneIsPlaying) {
                    oneIsPlaying = NO;
                    [self.pd sendFloat:0 toReceiver:[NSString stringWithFormat:@"1.main.play"]];
                    [self.waveView1.player stop];
                    [self.transport1 setBackgroundImage:[UIImage imageNamed:@"play.pdf"] forState:UIControlStateNormal];
                } else {
                    oneIsPlaying = YES;
                    [self.waveView1.player play];
                    [self.pd sendFloat:1 toReceiver:[NSString stringWithFormat:@"1.main.play"]];
                    [self.transport1 setBackgroundImage:[UIImage imageNamed:@"stop.pdf"] forState:UIControlStateNormal];
                }
            }
            break;
        case 2:
            if (self.waveView2) {
                if (twoIsPlaying) {
                    twoIsPlaying = NO;
                    [self.waveView2.player stop];
                    [self.pd sendFloat:0 toReceiver:[NSString stringWithFormat:@"2.main.play"]];
                    [self.transport2 setBackgroundImage:[UIImage imageNamed:@"play.pdf"] forState:UIControlStateNormal];
                } else {
                    twoIsPlaying = YES;
                    [self.waveView2.player play];
                    [self.pd sendFloat:1 toReceiver:[NSString stringWithFormat:@"2.main.play"]];
                    [self.transport2 setBackgroundImage:[UIImage imageNamed:@"stop.pdf"] forState:UIControlStateNormal];
                }
            }
            break;
        case 3:
            if (self.waveView3) {
                if (threeIsPlaying) {
                    threeIsPlaying = NO;
                    [self.waveView3.player stop];
                    [self.pd sendFloat:0 toReceiver:[NSString stringWithFormat:@"3.main.play"]];
                    [self.transport3 setBackgroundImage:[UIImage imageNamed:@"play.pdf"] forState:UIControlStateNormal];
                } else {
                    threeIsPlaying = YES;
                    [self.waveView3.player play];
                    [self.pd sendFloat:1 toReceiver:[NSString stringWithFormat:@"3.main.play"]];
                    [self.transport3 setBackgroundImage:[UIImage imageNamed:@"stop.pdf"] forState:UIControlStateNormal];
                }
            }
            break;
            
        default:
            break;
    }
}

#pragma mark - Longpress transport button actions

- (void)lpTransportButton:(UILongPressGestureRecognizer *)sender {
    [nnKit animateViewBigJiggle:sender.view];
    switch (sender.view.tag) {
        case 1:
            if (sender.state == UIGestureRecognizerStateBegan) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self handleSpinner:1];
                    
                    closeView = [[UIView alloc] initWithFrame:self.view.frame];
                    closeView.tag = sender.view.tag;
                    UITapGestureRecognizer *tapCloseView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePopup:)];
                    [closeView addGestureRecognizer:tapCloseView];
                    
                    label1 = [nnKit makeLabelWithFrame:CGRectMake(0, 0, SW(), SH()*.2) fontSize:SW()/15 text:[NSString stringWithFormat:@""]];
                    [label1 setCenter:self.transport1.center];
                    [label1 setTextAlignment:NSTextAlignmentCenter];
                    [label1 setTextColor:[UIColor flatWhiteColor]];
                    [self.parentView addSubview:label1];
                    
                    [self.popupView addSubview:closeView];
                    
                    [self.popup1 showFromView:self.popupView animated:YES];
                    [self.popupView addSubview:self.popup1];
                    
                    [self.popupView setUserInteractionEnabled:YES];
                    [self.parentView setUserInteractionEnabled:NO];
                    [self.menuView setUserInteractionEnabled:NO];
                    [self.accel setUserInteractionEnabled:NO];
                });
            }
            break;
        case 2:
            if (sender.state == UIGestureRecognizerStateBegan) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self handleSpinner:2];
                    
                    closeView = [[UIView alloc] initWithFrame:self.view.frame];
                    closeView.tag = sender.view.tag;
                    UITapGestureRecognizer *tapCloseView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePopup:)];
                    [closeView addGestureRecognizer:tapCloseView];
                    
                    label2 = [nnKit makeLabelWithFrame:CGRectMake(0, 0, SW(), SH()*.2) fontSize:SW()/15 text:[NSString stringWithFormat:@""]];
                    [label2 setCenter:self.transport2.center];
                    [label2 setTextAlignment:NSTextAlignmentCenter];
                    [label2 setTextColor:[UIColor flatWhiteColor]];
                    [self.parentView addSubview:label2];
                    
                    [self.popupView addSubview:closeView];
                    
                    [self.popup2 showFromView:self.popupView animated:YES];
                    self.popup2.center = CGPointMake(SW()/2,self.transport3.center.y);
                    [self.popupView addSubview:self.popup2];
                    
                    [self.popupView setUserInteractionEnabled:YES];
                    [self.parentView setUserInteractionEnabled:NO];
                    [self.menuView setUserInteractionEnabled:NO];
                    [self.accel setUserInteractionEnabled:NO];
                });
            }
            break;
        case 3:
            if (sender.state == UIGestureRecognizerStateBegan){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self handleSpinner:3];

                    closeView = [[UIView alloc] initWithFrame:self.view.frame];
                    closeView.tag = sender.view.tag;
                    UITapGestureRecognizer *tapCloseView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closePopup:)];
                    [closeView addGestureRecognizer:tapCloseView];
                    
                    label3 = [nnKit makeLabelWithFrame:CGRectMake(0, 0, SW(), SH()*.2) fontSize:SW()/15 text:[NSString stringWithFormat:@""]];
                    [label3 setCenter:self.transport3.center];
                    [label3 setTextAlignment:NSTextAlignmentCenter];
                    [label3 setTextColor:[UIColor flatWhiteColor]];
                    [self.parentView addSubview:label3];
                    
                    [self.popupView addSubview:closeView];
                    
                    [self.popup3 showFromView:self.popupView animated:YES];
                    [self.popupView addSubview:self.popup3];
                    
                    [self.popupView setUserInteractionEnabled:YES];
                    [self.parentView setUserInteractionEnabled:NO];
                    [self.menuView setUserInteractionEnabled:NO];
                    [self.accel setUserInteractionEnabled:NO];
                });
            }
            break;
            
        default:
            break;
    }
}

- (void)globalCloseActions {
    [self.parentView setUserInteractionEnabled:YES];
    [self.menuView setUserInteractionEnabled:YES];
    [self.accel setUserInteractionEnabled:YES];
    [self.popupView setUserInteractionEnabled:NO];
    if (closeView) {
        [closeView removeFromSuperview];
        closeView = nil;
    }
}

- (void)closePopup:(UITapGestureRecognizer*)sender {
    switch (sender.view.tag) {
        case 1:
            [self.popup1 hideWithAnimated:YES];
            break;
        case 2:
            [self.popup2 hideWithAnimated:YES];
            break;
        case 3:
            [self.popup3 hideWithAnimated:YES];
            break;
            
        default:
            break;
    }
    [self globalCloseActions];
    isBusy = NO;
}

#pragma mark - nnSongPicker delegates
- (void)mediaLibraryPicked:(nnMediaPickerPopUp *)popup {
    NSLog(@"media library picked");
    isBusy = YES;
    closeView.userInteractionEnabled = NO;
}
- (void)songPickerDidFinish:(nnMediaPickerPopUp *)popup {
    NSLog(@"song picker did finish");
    dispatch_async(dispatch_get_main_queue(), ^{
        switch ([popup.ID integerValue]) {
            case 101:
                [self handleSpinner:1];
                [self.pd sendMessage:self.popup1.picker.songURL withArguments:nil toReceiver:[NSString stringWithFormat:@"1.file.url"]];
                [self drawWaveform1:self.popup1.picker.song.assetURL];

                progress1 = 0;
                [self.pd sendFloat:progress1 toReceiver:@"1.main.trans"];
                
                [label1 removeFromSuperview];
                
                [self globalCloseActions];
                isBusy = NO;
                
                break;
                
            case 102:
                [self handleSpinner:2];
                [self.pd sendMessage:self.popup2.picker.songURL withArguments:nil toReceiver:[NSString stringWithFormat:@"2.file.url"]];
                [self drawWaveform2:self.popup2.picker.song.assetURL];
                
                progress2 = 0;
                [self.pd sendFloat:progress2 toReceiver:@"2.main.trans"];
                
                [label2 removeFromSuperview];
                
                [self globalCloseActions];
                isBusy = NO;
                
                break;
                
            case 103:
                [self handleSpinner:3];
                [self.pd sendMessage:self.popup3.picker.songURL withArguments:nil toReceiver:[NSString stringWithFormat:@"3.file.url"]];
                [self drawWaveform3:self.popup3.picker.song.assetURL];
                
                progress1 = 0;
                [self.pd sendFloat:progress3 toReceiver:@"3.main.trans"];
                
                [label3 removeFromSuperview];
                
                [self globalCloseActions];
                isBusy = NO;
                
                break;
                
            default:
                break;
        }
    });
}

- (void)songPickerDidCancel:(nnMediaPickerPopUp *)popup {
    NSLog(@"song picker did cancel");
    isBusy = NO;
    closeView.userInteractionEnabled = YES;
}

- (void)songPickerIsConverting:(nnMediaPickerPopUp *)popup {
    switch ([popup.ID integerValue]) {
        case 101:
            if([self.popup1 isDescendantOfView:self.view]) {
                [self.popup1 removeFromSuperview];
            }
            label1.text = [NSString stringWithFormat:@"%.0f%%",popup.picker.conversionPercent];
            break;
            
        case 102:
            if([self.popup2 isDescendantOfView:self.view]) {
                [self.popup2 removeFromSuperview];
            }
            label2.text = [NSString stringWithFormat:@"%.0f%%",popup.picker.conversionPercent];
            break;
            
        case 103:
            if([self.popup3 isDescendantOfView:self.view]) {
                [self.popup3 removeFromSuperview];
            }
            label3.text = [NSString stringWithFormat:@"%.0f%%",popup.picker.conversionPercent];
            break;
            
        default:
            break;
    }
}

- (void)songPickerShouldStartConverting:(nnMediaPickerPopUp *)picker {
    NSLog(@"should start converting");
}

- (void)songPickerDidStartConverting:(nnMediaPickerPopUp *)popup {
    NSLog(@"song picker did start converting");
}

- (void)wavFilePicked:(nnMediaPickerPopUp *)popup row:(int)row {
    isBusy = YES;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString* str;
        NSURL *url;
            
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error;
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths firstObject];
        
        NSString *filePath;
        
        switch ([popup.ID integerValue]) {
            case 101:
                [self.pd sendMessage:self.popup1.wavURL withArguments:nil toReceiver:[NSString stringWithFormat:@"1.file.url"]];
                str = [NSString stringWithFormat:@"file://"];
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@",self.popup1.wavURL]];
                url = [NSURL URLWithString:str];
                [self drawWaveform1:url];
                
                progress1 = 0;
                [self.pd sendFloat:progress1 toReceiver:@"1.main.trans"];
                
                filePath = [documentsDirectory stringByAppendingPathComponent:@"player101.wav"];
                if ([fileManager fileExistsAtPath:filePath] == YES) {
                    [fileManager removeItemAtPath:filePath error:&error];
                }
                if ([fileManager fileExistsAtPath:filePath] == NO) {
                    [fileManager copyItemAtPath:self.popup1.wavURL toPath:filePath error:&error];
                }

                break;
                
            case 102:
                [self.pd sendMessage:self.popup2.wavURL withArguments:nil toReceiver:[NSString stringWithFormat:@"2.file.url"]];
                
                str = [NSString stringWithFormat:@"file://"];
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@",self.popup2.wavURL]];
                url = [NSURL URLWithString:str];
                [self drawWaveform2:url];
                
                progress2 = 0;
                [self.pd sendFloat:progress2 toReceiver:@"2.main.trans"];
                
                filePath = [documentsDirectory stringByAppendingPathComponent:@"player102.wav"];
                if ([fileManager fileExistsAtPath:filePath] == YES) {
                    [fileManager removeItemAtPath:filePath error:&error];
                }
                if ([fileManager fileExistsAtPath:filePath] == NO) {
                    [fileManager copyItemAtPath:self.popup2.wavURL toPath:filePath error:&error];
                }
                
                break;
                
            case 103:
                [self.pd sendMessage:self.popup3.wavURL withArguments:nil toReceiver:[NSString stringWithFormat:@"3.file.url"]];
                
                str = [NSString stringWithFormat:@"file://"];
                str = [str stringByAppendingString:[NSString stringWithFormat:@"%@",self.popup3.wavURL]];
                url = [NSURL URLWithString:str];
                [self drawWaveform3:url];
                
                progress3 = 0;
                [self.pd sendFloat:progress3 toReceiver:@"3.main.trans"];
                
                filePath = [documentsDirectory stringByAppendingPathComponent:@"player103.wav"];
                if ([fileManager fileExistsAtPath:filePath] == YES) {
                    [fileManager removeItemAtPath:filePath error:&error];
                }
                if ([fileManager fileExistsAtPath:filePath] == NO) {
                    [fileManager copyItemAtPath:self.popup3.wavURL toPath:filePath error:&error];
                }
                
                break;
                
            default:
                break;
        }
    });
    [self globalCloseActions];
    isBusy = NO;
}

#pragma mark - nnMediaPickerPopup delegate

- (void)popupDidCancel:(nnMediaPickerPopUp *)popup {
    NSLog(@"popup did cancel");
}
- (void)popupDidHide:(nnMediaPickerPopUp *)popup {
    NSLog(@"popup did hide");
    if (!isBusy) {
        switch ([popup.ID integerValue]) {
            case 101:
                [self handleSpinner:1];
                break;
                
            case 102:
                [self handleSpinner:2];
                break;
                
            case 103:
                [self handleSpinner:3];
                break;
                
            default:
                break;
        }
        [self globalCloseActions];
    }
}

#pragma mark - nnWaveformPlayerView delegate and other methods

- (void)progressDidChange:(nnWaveformPlayerView *)player {
    switch (player.tag) {
        case 1:
            progress1 = player.waveformView.progress;
            break;
        case 2:
            progress2 = player.waveformView.progress;
            break;
        case 3:
            progress3 = player.waveformView.progress;
            break;
            
        default:
            break;
    }
}

- (void)didReceiveTouch:(UIGestureRecognizer *)sender {
    NSTimer *timer;
    NSString *receiver;
    float gain;
    float opac;
    float radius;
    float maxVol;
    float minVol;
    
    switch (sender.view.tag) {
        case 1:
            timer = timer1;
            receiver = @"1.main.level";
            maxVol = self.maxVol1;
            minVol = self.minVol1;
            break;
        case 2:
            timer = timer2;
            receiver = @"2.main.level";
            maxVol = self.maxVol2;
            minVol = self.minVol2;
            break;
        case 3:
            timer = timer1;
            receiver = @"3.main.level";
            maxVol = self.maxVol3;
            minVol = self.minVol3;
            break;
            
        default:
            break;
    }
    
    if (sender.state == UIGestureRecognizerStateBegan) {
        switch (sender.view.tag) {
            case 1:
                if (!timer1) {
                    timer1 = [NSTimer scheduledTimerWithTimeInterval:1.0/self.dur1 target:self selector:@selector(sendToOne) userInfo:nil repeats:YES];
                }
                break;
            case 2:
                if (!timer2) {
                    timer2 = [NSTimer scheduledTimerWithTimeInterval:1.0/self.dur2 target:self selector:@selector(sendToTwo) userInfo:nil repeats:YES];
                }
                break;
            case 3:
                if (!timer3) {
                    timer3 = [NSTimer scheduledTimerWithTimeInterval:1.0/self.dur3 target:self selector:@selector(sendToThree) userInfo:nil repeats:YES];
                }
                break;
                
            default:
                break;
        }
    } else if (sender.state == UIGestureRecognizerStateEnded | sender.state == UIGestureRecognizerStateCancelled) {
        switch (sender.view.tag) {
            case 1:
                [timer1 invalidate];
                timer1 = nil;
                break;
            case 2:
                [timer2 invalidate];
                timer2 = nil;
                break;
            case 3:
                [timer3 invalidate];
                timer3 = nil;
                break;
                
            default:
                break;
        }
    }
    gain = [self getGainFromSender:sender];
    [self.pd sendFloat:gain toReceiver:receiver];
    
    opac = gain/(maxVol-minVol);
    sender.view.layer.shadowOpacity = opac;
    
    radius = SCALE(gain, minVol, maxVol, -40, 40);
    radius = CLIP(radius, 0, 60);
    sender.view.layer.shadowRadius = radius;
}

- (float)getGainFromSender:(UIGestureRecognizer *)sender {
    float y = [sender locationInView:sender.view].y;
    float maxY = sender.view.frame.size.height;
    y = MAX(0, MIN(maxY, y));
    float gain = y/maxY;
    gain = 1-gain;
    
    float minVol;
    float maxVol;
    float force;
    
    switch (sender.view.tag) {
        case 1:
            minVol = self.minVol1;
            maxVol = self.maxVol1;
            force = ft1;
            break;
        case 2:
            minVol = self.minVol2;
            maxVol = self.maxVol2;
            force = ft2;
            break;
        case 3:
            minVol = self.minVol3;
            maxVol = self.maxVol3;
            force = ft3;
            break;
            
        default:
            break;
    }
    
    gain = SCALE(gain, 0, 1, minVol, maxVol);
    gain = gain + force;

    return gain;
}

- (void)sendToOne {
    [timer1 invalidate];
    timer1 = nil;
    [self.pd sendFloat:progress1 toReceiver:@"1.main.trans"];
    if (!timer1) {
        timer1 = [NSTimer scheduledTimerWithTimeInterval:1.0/self.dur1 target:self selector:@selector(sendToOne) userInfo:nil repeats:YES];
    }
}
- (void)sendToTwo {
    [timer2 invalidate];
    timer2 = nil;
    [self.pd sendFloat:progress2 toReceiver:@"2.main.trans"];
    if (!timer2) {
        timer2 = [NSTimer scheduledTimerWithTimeInterval:1.0/self.dur2 target:self selector:@selector(sendToTwo) userInfo:nil repeats:YES];
    }
}
- (void)sendToThree {
    [timer3 invalidate];
    timer3 = nil;
    [self.pd sendFloat:progress3 toReceiver:@"3.main.trans"];
    if (!timer3) {
        timer3 = [NSTimer scheduledTimerWithTimeInterval:1.0/self.dur3 target:self selector:@selector(sendToThree) userInfo:nil repeats:YES];
    }
}

- (void)didStartPlaying:(nnWaveformPlayerView *)player {
    if (player == self.waveView1 && !oneIsPlaying) {
        [self.pd sendFloat:1 toReceiver:[NSString stringWithFormat:@"1.main.play"]];
        
        if (!oneIsPlaying) {
            oneIsPlaying = YES;
            [nnKit animateViewBigJiggle:self.transport1];
            [self.transport1 setBackgroundImage:[UIImage imageNamed:@"stop.pdf"] forState:UIControlStateNormal];
        }
    }
    if (player == self.waveView2 && !twoIsPlaying) {
        [self.pd sendFloat:1 toReceiver:[NSString stringWithFormat:@"2.main.play"]];
        
        if (!twoIsPlaying) {
            twoIsPlaying = YES;
            [nnKit animateViewBigJiggle:self.transport2];
            [self.transport2 setBackgroundImage:[UIImage imageNamed:@"stop.pdf"] forState:UIControlStateNormal];
        }
    }
    if (player == self.waveView3 && !threeIsPlaying) {
        [self.pd sendFloat:1 toReceiver:[NSString stringWithFormat:@"3.main.play"]];
        
        if (!threeIsPlaying) {
            threeIsPlaying = YES;
            [nnKit animateViewBigJiggle:self.transport3];
            [self.transport3 setBackgroundImage:[UIImage imageNamed:@"stop.pdf"] forState:UIControlStateNormal];
        }
    }
}

- (void)didPausePlaying:(nnWaveformPlayerView *)player {
    
}

- (void)ftRecognized:(nnWaveformPlayerView *)player {
    
}
- (void)ftDidStart:(nnWaveformPlayerView *)player withForce:(CGFloat)force maxForce:(CGFloat)maxForce {
    //NSLog(@"%ld, %f",player.tag,force);
}
- (void)ftDidMove:(nnWaveformPlayerView *)player withForce:(CGFloat)force maxForce:(CGFloat)maxForce {
    switch (player.tag) {
        case 1:
            ft1 = force * 8.;
            ft1 = [nnKit filterCurrentInput:force lastOutput:ft1 andK:.98];
            break;
        case 2:
            ft2 = force * 8.;
            ft2 = [nnKit filterCurrentInput:force lastOutput:ft2 andK:.98];
            break;
        case 3:
            ft3 = force * 8.;
            ft3 = [nnKit filterCurrentInput:force lastOutput:ft3 andK:.98];
            break;
            
        default:
            break;
    }
}
- (void)ftDidCancel:(nnWaveformPlayerView *)player withForce:(CGFloat)force maxForce:(CGFloat)maxForce {
    
}
- (void)ftDidEnd:(nnWaveformPlayerView *)player withForce:(CGFloat)force maxForce:(CGFloat)maxForce {
    
}
- (void)ftDidTimeout:(nnWaveformPlayerView *)player {
    
}

#pragma mark - Activity Indicator

- (void)handleSpinner:(int)spin {
    MONActivityIndicatorView *spinner;
    UIButton *transport;
    nnWaveformPlayerView *waveView;
    switch (spin) {
        case 1:
            spinner = spinner1;
            transport = self.transport1;
            waveView = self.waveView1;
            break;
        case 2:
            spinner = spinner2;
            transport = self.transport2;
            waveView = self.waveView2;
            break;
        case 3:
            spinner = spinner3;
            transport = self.transport3;
            waveView = self.waveView3;
            break;
        default:
            break;
    }
    
    if (!spinner) {
        
        int num = RAND(12);
        colorTheme = [nnKit colorTheme:num];
        
        spinner = [[MONActivityIndicatorView alloc] init];
        spinner.alpha = 0;
        spinner.delegate = self;
        spinner.numberOfCircles = 5;
        spinner.radius = SW()/16;
        spinner.internalSpacing = 3;
        
        CGFloat width = (spinner.numberOfCircles * ((2 * spinner.radius) + spinner.internalSpacing)) - spinner.internalSpacing;
        CGFloat height = spinner.radius * 2;
        
        if (waveView) {
            [spinner setCenter:CGPointMake(waveView.center.x-(width/2), waveView.center.y-(height/2))];
        } else {
            switch (spin) {
                case 1:
                    [spinner setCenter:CGPointMake(self.parentView.center.x-(width/2), self.parentView.center.y-(height/2))];
                    break;
                case 2:
                    [spinner setCenter:CGPointMake(self.parentView.center.x-(width/2), self.parentView.center.y-(height*2))];
                    break;
                case 3:
                    [spinner setCenter:CGPointMake(self.parentView.center.x-(width/2), self.parentView.center.y+(height))];
                    break;
                    
                default:
                    break;
            }
        }
        
        switch (spin) {
            case 1:
                spinner1 = spinner;
                [self.parentView addSubview:spinner1];
                [spinner1 startAnimating];
                break;
            case 2:
                spinner2 = spinner;
                [self.parentView addSubview:spinner2];
                [spinner2 startAnimating];
                break;
            case 3:
                spinner3 = spinner;
                [self.parentView addSubview:spinner3];
                [spinner3 startAnimating];
                break;
                
            default:
                break;
        }
        
        [UIView animateWithDuration:kFadeTime*3
                              delay:kFadeDelay
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^
         {
             [spinner setAlpha:1];
         } completion:nil];
        
        [UIView animateWithDuration:0.3
                              delay:0.1
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             if (transport) {
                                 [transport setAlpha:0];
                             }
                         } completion:nil
         ];
        
    } else {
        if (isLoaded) {
            [UIView animateWithDuration:0.3
                                  delay:0.1
                                options: (UIViewAnimationOptionAllowUserInteraction |
                                          UIViewAnimationOptionCurveEaseInOut)
                             animations:^{
                                 [transport setAlpha:1];
                             } completion:nil
             ];
        }
        
        [UIView animateWithDuration:kFadeTime/2
                              delay:0
                            options: UIViewAnimationOptionCurveEaseInOut
                         animations:^
         {
             spinner.alpha = 0;
         } completion:^(BOOL finished){
             if (finished) {
                 [spinner stopAnimating];
                 [spinner removeFromSuperview];
                 colorTheme = nil;
                 switch (spin) {
                     case 1:
                         spinner1 = nil;
                         self.transport1 = transport;
                         break;
                     case 2:
                         spinner2 = nil;
                         self.transport2 = transport;
                         break;
                     case 3:
                         spinner3 = nil;
                         self.transport3 = transport;
                         break;
                         
                     default:
                         break;
                 }
             }
         }];
    }
}

#pragma mark - CDSideBarController delegate

- (void)menuOpened {
    [self.parentView setUserInteractionEnabled:NO];
    [self.accel setUserInteractionEnabled:NO];
    closeView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.menuView insertSubview:closeView atIndex:0];
}

- (void)menuClosed {
    [closeView removeFromSuperview];
    closeView = nil;
    [self.parentView setUserInteractionEnabled:YES];
    [self.accel setUserInteractionEnabled:YES];
}

- (void)menuButtonClicked:(int)index {
    
    if (index == 3) {
        WebUploadViewController *vc = [[WebUploadViewController alloc] init];
        vc.modalTransitionStyle = UIModalTransitionStylePartialCurl;
        [self presentViewController:vc animated:YES completion:nil];
    } else {
        if (index == 5) {
            [self dismissViewControllerAnimated:YES completion:^(){
                [self.pd setActive:NO];
                [self.pd closePatch];
                if (udpSocket) {
                    udpSocket = nil;
                }
                isLoaded = nil;
            }];
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                switch (index) {
                    case 0:
                        [self createSettingsView:1];
                        break;
                    case 1:
                        [self createSettingsView:2];
                        break;
                    case 2:
                        [self createSettingsView:3];
                        break;
                    case 4:
                        [self makeUDPConnectPopup];
                        break;
                    case 6:
                        
                        break;
                    case 7:
                        [sideBar dismissMenu];
                        break;
                    default:
                        break;
                }
            });
        }
    }
}

#pragma mark - MONActivityIndicatorView delegate

- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView
      circleBackgroundColorAtIndex:(NSUInteger)index {

    UIColor *color = [colorTheme objectAtIndex:index%5];
    
    return color;
}

#pragma mark - GCD Async UDP

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

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
                                               fromAddress:(NSData *)address
                                         withFilterContext:(id)filterContext
{
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (msg)
    {

        NSArray *udp = [msg componentsSeparatedByString:@"/"];
        NSString *theString = [udp objectAtIndex:0];
        float value = [[udp objectAtIndex: 1] floatValue];
        int receiver = 10;
        
        for (NSString *string in pdReceives) {
            if ([string isEqualToString:theString]) {
                receiver = (int)[pdReceives indexOfObject:string];
            }
        };
        
        switch (receiver) {
            case 0:
                [self.pd sendFloat:value toReceiver:@"1.main.speed"];
                [self.pd sendFloat:value toReceiver:@"2.main.speed"];
                [self.pd sendFloat:value toReceiver:@"3.main.speed"];
                [self.waveView1.player setRate:value/100];
                [self.waveView2.player setRate:value/100];
                [self.waveView3.player setRate:value/100];
                
                break;
            case 1:
                [self.pd sendFloat:value toReceiver:@"master.level"];
                break;
            case 2:
                [self.pd sendFloat:value toReceiver:@"1.reverb"];
                break;
            case 3:
                [self.pd sendFloat:value toReceiver:@"2.reverb"];
                break;
            case 4:
                [self.pd sendFloat:value toReceiver:@"3.reverb"];
                break;
            case 5:
                [self.pd sendFloat:value toReceiver:@"1.delay"];
                [self.pd sendFloat:value toReceiver:@"2.delay"];
                [self.pd sendFloat:value toReceiver:@"3.delay"];
                break;
                
            default:
                break;
        }
    }
    
    else
    {
        NSString *host = nil;
        uint16_t port = 0;
        [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
        
        NSLog(@"RECV: Unknown message from: %@:%hu", host, port);
    }
}

#pragma mark - NNToggle delegate

- (void)toggleWasTapped:(NNToggle*)toggle {

}

- (void)toggleDidSwitchState:(NNToggle*)toggle {

    switch (toggle.tag) {
        case 1:
            self.isAccel1 = toggle.isOn;
            break;
        case 2:
            self.isAccel2 = toggle.isOn;
            break;
        case 3:
            self.isAccel3 = toggle.isOn;
            break;
        case 4:
            self.isUDP = toggle.isOn;
            [self toggleUDP:toggle];
            break;
        default:
            break;
    }
}

@end
