//
//  NNClock.h
//
//  Created by Cady Holmes on 6/5/15.
//  Copyright (c) 2015-present Cady Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NNClock : UIView {
    NSTimer *clockTimer;
    
    UILabel *label;
    UIImageView *clock;
    BOOL isTimerOn;
    int timerSeconds;
}

@property (nonatomic) BOOL isDark;

@end
