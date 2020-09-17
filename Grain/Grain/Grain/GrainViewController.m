//
//  GrainViewController.m
//  Grain
//
//  Created by Cady Holmes on 9/17/15.
//  Copyright © 2015-present Cady Holmes. All rights reserved.
//

#import "GrainViewController.h"
#import "nnKit.h"
#import "PlayerViewController.h"
#import "ControllerViewController.h"

@interface GrainViewController () {
    UILabel *titleLabel;
    UIButton *playerButton;
    UIButton *controllerButton;
}

@property (nonatomic, retain) CAGradientLayer *gradient;

@end

@implementation GrainViewController

-(BOOL)shouldAutorotate {
    return NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadUI];
}

- (void)loadUI {
    UIColor *bgColor = [UIColor colorWithRed:96/255. green:100/255. blue:109/255. alpha:1];
    self.view.backgroundColor = bgColor;
    
    UIImage *playerImage;
    UIImage *controllerImage;
    int randNum = arc4random() % 2;
    if (randNum == 0) {
        playerImage = [UIImage imageNamed:@"player1.pdf"];
    } else {
        playerImage = [UIImage imageNamed:@"player2.pdf"];
    }
    randNum = arc4random() % 2;
    if (randNum == 0) {
        controllerImage = [UIImage imageNamed:@"controller1.pdf"];
    } else {
        controllerImage = [UIImage imageNamed:@"controller2.pdf"];
    }
    
    CGRect playerButtonFrame;
    CGRect controllerButtonFrame;
    
    if ([nnKit isIPad]) {
        playerButtonFrame = CGRectMake(0, 0, SW()/2, SW()/2);
        controllerButtonFrame = CGRectMake(0, 0, SW()/3.5, SW()/3.5);
    } else {
        playerButtonFrame = CGRectMake(0, 0, SW()/1.65, SW()/1.65);
        controllerButtonFrame = CGRectMake(0, 0, SW()/3, SW()/3);
    }

    playerButton = [nnKit makeButtonWithImage:playerImage frame:playerButtonFrame method:@"loadPlayer:" fromClass:self];
    
    controllerButton = [nnKit makeButtonWithImage:controllerImage frame:controllerButtonFrame method:@"loadController:" fromClass:self];
    
    UIButton *helpButton = [nnKit makeButtonWithImage:[UIImage imageNamed:@"question.pdf"] frame:CGRectMake(0, 0, SW()/10, SW()/10) method:@"showHelp:" fromClass:self];
    
    [playerButton setCenter:self.view.center];
    [controllerButton setCenter:CGPointMake(SW()/2, SH()-(SH()*.175))];
    [helpButton setCenter:CGPointMake(SW()/12, SH()-(SW()/12))];
    CGPoint titleCenter = CGPointMake(self.view.center.x, SH()*.175);
    
    titleLabel = [nnKit makeLabelWithCenter:titleCenter fontSize:120 text:@"Grain"];
    [titleLabel setTextColor:[UIColor whiteColor]];

    [self.view addSubview:titleLabel];
    [self.view addSubview:helpButton];
    [self.view addSubview:playerButton];
    [self.view addSubview:controllerButton];
}

- (void)loadPlayer:(UIButton *)button {
    [nnKit animateViewBigJiggle:button];
    PlayerViewController *vc = [[PlayerViewController alloc] init];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)loadController:(UIButton *)button {
    [self.view bringSubviewToFront:button];
    [nnKit animateViewBigJiggle:button];
    ControllerViewController *vc = [[ControllerViewController alloc] init];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)showHelp:(UIButton *)button {
    [nnKit animateViewBigJiggle:button];
}



@end
