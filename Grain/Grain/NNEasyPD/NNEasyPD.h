//
//  NNEasyPD.h
//
//  Created by Cady Holmes.
//  Copyright (c) 2015-present Cady Holmes.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#include <AudioToolbox/AudioToolbox.h>
#import "PdAudioController.h"
#import "PdDispatcher.h"

@interface NNEasyPD : UIControl <PdReceiverDelegate> {
    PdDispatcher *dispatcher;
    NSString *patchString;
    void *patch;
}

@property (nonatomic, strong) PdAudioController *audioController;

- (void)initializeWithPatch:(NSString*)patchName;
- (void)closePatch;
- (void)setActive:(BOOL)isActive;
- (void)sendFloat:(float)f toReceiver:(NSString*)receiver;
- (void)sendBangToReceiver:(NSString*)r;
- (void)sendSymbol:(NSString*)s toReceiver:(NSString*)r;
- (void)sendMessage:(NSString*)s withArguments:(NSArray*)a toReceiver:(NSString*)r;

@end
