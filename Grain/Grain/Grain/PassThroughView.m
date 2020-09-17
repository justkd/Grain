//
//  PassThroughView.m
//
//  Created by Cady Holmes on 9/15/15.
//  Copyright © 2015-present Cady Holmes. All rights reserved.
//

#import "PassThroughView.h"

@implementation PassThroughView

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    for (UIView *view in self.subviews) {
        if (!view.hidden && view.alpha > 0 && view.userInteractionEnabled && [view pointInside:[self convertPoint:point toView:view] withEvent:event])
            return YES;
    }
    return NO;
}

@end
