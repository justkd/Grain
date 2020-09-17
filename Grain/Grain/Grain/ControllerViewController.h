//
//  ControllerViewController.h
//
//  Created by Cady Holmes on 9/8/15.
//  Copyright © 2015-present Cady Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "nnKit.h"
#import "NNAccelView.h"
#import "CDSideBarController.h"
#import "WebUploadViewController.h"
#import "GCDAsyncUdpSocket.h"

@class CAEmitterLayer;

@interface ControllerViewController : UIViewController <CDSideBarControllerDelegate, GCDAsyncUdpSocketDelegate, UITextFieldDelegate>
{
    CDSideBarController* sideBar;
    GCDAsyncUdpSocket *udpSocket;
    UIView *ipPopup;
    UIView *ipPopupBackground;
    UITextField *textFieldIP;
    NSString *ipAddress;
    NNAccelView *accel;
    float lastAcc;
    UIImageView *signalIcon;
    
    //NSMutableString *log;
    int tag;
    
    NSString *speedString;
    NSString *levelString;
    NSString *pitchString;
    NSString *rollString;
    NSString *yawString;
    NSString *accString;
    
}

- (void) touchAtPosition:(CGPoint)position;

@end
