//
//  PlayerViewController.h
//  Grain
//
//  Created by Cady Holmes on 9/8/15.
//  Copyright © 2015-present Cady Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebUploadViewController.h"
#import "PassThroughView.h"
#import "nnKit.h"
#import "UIColor+NNColors.h"
#import "NNEasyPD.h"
#import "CDSideBarController.h"
#import "nnWaveformPlayerView.h"
#import "nnMediaPickerPopUp.h"
#import "NNAccelView.h"
#import "NNClock.h"
#import "NNSlider.h"
#import "MONActivityIndicatorView.h"
#import "NNToggle.h"
#import "GCDAsyncUdpSocket.h"

@interface PlayerViewController : UIViewController <CDSideBarControllerDelegate, nnWaveformPlayerViewDelegate, nnMediaPickerPopUpDelegate, MONActivityIndicatorViewDelegate, NNToggleDelegate, GCDAsyncUdpSocketDelegate>
{
    BOOL isLoaded;
    BOOL isBusy;
    
    //BOOL file1Loaded;
    //BOOL file2Loaded;
    //BOOL file3Loaded;
    
    BOOL oneIsPlaying;
    BOOL twoIsPlaying;
    BOOL threeIsPlaying;
    
    UILabel* label1;
    UILabel* label2;
    UILabel* label3;
    
    float progress1;
    float progress2;
    float progress3;
    
    NSTimer* timer1;
    NSTimer* timer2;
    NSTimer* timer3;
    
    MONActivityIndicatorView* spinner1;
    MONActivityIndicatorView* spinner2;
    MONActivityIndicatorView* spinner3;
    
    CDSideBarController* sideBar;
    UIView* settingsView;
    UIView* closeView;
    UIView *udpView;
    UIView *udpCloseView;
    UILabel *instructLabel;
    UILabel *ipLabel;
    int menu;
    float lastAccel;
    NNClock* clock;
    UIImageView *signalIcon;
    
    float lastSlider5Value;
    float lastSlider6Value;
    float lastSlider7Value;
    
    NSArray* colorTheme;
    
    GCDAsyncUdpSocket *udpSocket;
    NSArray *pdReceives;
    
    float ft1;
    float ft2;
    float ft3;
}

@property (nonatomic) BOOL isAccel1;
@property (nonatomic) BOOL isAccel2;
@property (nonatomic) BOOL isAccel3;
@property (nonatomic) BOOL isUDP;

@property (nonatomic) float dur1;
@property (nonatomic) float minVol1;
@property (nonatomic) float maxVol1;
@property (nonatomic) float speed1;
@property (nonatomic) float grainSize1;
@property (nonatomic) float winShape1;
@property (nonatomic) float transposition1;
@property (nonatomic) float reverb1;

@property (nonatomic) float dur2;
@property (nonatomic) float minVol2;
@property (nonatomic) float maxVol2;
@property (nonatomic) float speed2;
@property (nonatomic) float grainSize2;
@property (nonatomic) float winShape2;
@property (nonatomic) float transposition2;
@property (nonatomic) float reverb2;

@property (nonatomic) float dur3;
@property (nonatomic) float minVol3;
@property (nonatomic) float maxVol3;
@property (nonatomic) float speed3;
@property (nonatomic) float grainSize3;
@property (nonatomic) float winShape3;
@property (nonatomic) float transposition3;
@property (nonatomic) float reverb3;

@property (nonatomic, strong) UIView *parentView;
@property (nonatomic, strong) PassThroughView *popupView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) PassThroughView *menuView;
@property (nonatomic, strong) NNEasyPD *pd;
@property (nonatomic, strong) NNAccelView *accel;
@property (nonatomic, strong) UIButton *transport1;
@property (nonatomic, strong) UIButton *transport2;
@property (nonatomic, strong) UIButton *transport3;
@property (nonatomic, strong) nnMediaPickerPopUp *popup1;
@property (nonatomic, strong) nnMediaPickerPopUp *popup2;
@property (nonatomic, strong) nnMediaPickerPopUp *popup3;
@property (nonatomic, strong) nnWaveformPlayerView *waveView1;
@property (nonatomic, strong) nnWaveformPlayerView *waveView2;
@property (nonatomic, strong) nnWaveformPlayerView *waveView3;

@end
