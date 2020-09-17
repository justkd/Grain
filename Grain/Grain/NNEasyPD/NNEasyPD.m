//
//  NNEasyPD.m
//
//  Created by Cady Holmes.
//  Copyright (c) 2015-present Cady Holmes.
//

#import "NNEasyPD.h"

@implementation NNEasyPD

- (void)sendFloat:(float)f toReceiver:(NSString*)r {
    [PdBase sendFloat:f toReceiver:r];
}
- (void)sendBangToReceiver:(NSString*)r {
    [PdBase sendBangToReceiver:r];
}
- (void)sendSymbol:(NSString*)s toReceiver:(NSString*)r {
    [PdBase sendSymbol:s toReceiver:r];
}
- (void)sendMessage:(NSString*)s withArguments:(NSArray*)a toReceiver:(NSString*)r {
    [PdBase sendMessage:s withArguments:a toReceiver:r];
}


- (void)initializeWithPatch:(NSString*)patchName {
    patchString = patchName;
    self.audioController = [[PdAudioController alloc] init];
    if ([self.audioController configureAmbientWithSampleRate:48000
                                              numberChannels:2
                                               mixingEnabled:YES] != PdAudioOK )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Audio Error"
                                                        message:@"Failed to initialize PD audio controller."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    } else {
        [self setActive:YES];
        dispatcher = [[PdDispatcher alloc] init];
        [PdBase setDelegate:dispatcher];
        patch = [PdBase openFile:patchString path:[[NSBundle mainBundle] resourcePath]];
        if (!patch) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"PD Error"
                                                            message:@"Failed to load patch."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (void)setActive:(BOOL)isActive {
    if (isActive == YES) {
        self.audioController.active = YES;
    } else {
        self.audioController.active = NO;
    }
}

- (void)closePatch {
    [PdBase closeFile:patch];
}

@end
