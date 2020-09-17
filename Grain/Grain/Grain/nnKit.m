//
//  nnKit.m
//
//  Created by Cady Holmes on 9/8/15.
//  Copyright © 2015-present Cady Holmes. All rights reserved.
//

#import "nnKit.h"

@implementation nnKit


/* --------------------------------------------------- */
+ (UIViewController *)currentTopViewController {
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

/* --------------------------------------------------- */
+ (double)filterCurrentInput:(double)x lastOutput:(double)y andK:(double)kk {
    
    double q = 0.1;
    double r = 0.1;
    double p = 0.1;
    double k;
    
    if (kk) {
        if (kk < 0.01) {
            k = 0.01;
        } else if (kk > .99) {
            k = .99;
        } else {
            k = kk;
        }
    } else {
        k = 0.8;
    }
    
    
    p = p + q;
    k = p / (p + r);
    x = x + k*(y - x);
    p = (1 - k)*p;
    
    return x;
}

+ (double)linearToExponential:(double)input inputMIN:(double)iMIN inputMAX:(double)iMAX outputMIN:(double)oMIN outputMAX:(double)oMAX {
    double minv = log(oMIN);
    double maxv = log(oMAX);
    
    double scale = (maxv - minv) / (iMAX - iMIN);
    
    return exp(minv + (scale * (input - iMIN)));
}

+ (void)delayThis: (void(^)(void))callback for: (double)delayInSeconds {
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
        if(callback){
            callback();
        }
    });
}

+ (void)wait:(double)delayInSeconds then:(void(^)(void))callback {
    dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(delayTime, dispatch_get_main_queue(), ^(void){
        if(callback){
            callback();
        }
    });
    
    /*
     [self wait:<#(double)#> then:^{
     
     }];
    */
}

/* --------------------------------------------------- */
static CAAnimation* showAnimation()
{
    CAKeyframeAnimation *transform = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    transform.values = values;
    
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [opacity setFromValue:@0.0];
    [opacity setToValue:@1.0];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 0.2;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [group setAnimations:@[transform, opacity]];
    return group;
}

static CAAnimation* hideAnimation()
{
    CAKeyframeAnimation *transform = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.00, 1.00, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1.0)]];
    transform.values = values;
    
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [opacity setFromValue:@1.0];
    [opacity setToValue:@0.0];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 0.2;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [group setAnimations:@[transform, opacity]];
    return group;
}

+ (void)animateViewGrowAndShow:(UIView*)view or:(UIImageView*)imageView completion:(completion)completionBlock {
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{}];
    if (view) {
        [view.layer addAnimation:showAnimation() forKey:nil];
        view.layer.opacity = 1;
    }
    if (imageView) {
        [imageView.layer addAnimation:showAnimation() forKey:nil];
        imageView.layer.opacity = 1;
    }
    [CATransaction commit];
}

+ (void)animateViewShrinkAndWink:(UIView*)view or:(UIImageView*)imageView andRemoveFromSuperview:(BOOL)removeFromSuperview completion:(completion)completionBlock {
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        if (view) {
            [view.layer removeAnimationForKey:@"opacity"];
            [view.layer removeAnimationForKey:@"transform"];
            if (removeFromSuperview) {
                [view removeFromSuperview];
            }
        }
        if (imageView) {
            [imageView.layer removeAnimationForKey:@"opacity"];
            [imageView.layer removeAnimationForKey:@"transform"];
            if (removeFromSuperview) {
                [imageView removeFromSuperview];
            }
        }
    }];
    
    if (view) {
        [view.layer addAnimation:hideAnimation() forKey:nil];
        view.layer.opacity = 0;
    }
    if (imageView) {
        [imageView.layer addAnimation:hideAnimation() forKey:nil];
        imageView.layer.opacity = 0;
    }
    
    [CATransaction commit];
}

+ (void)animateViewAlpha:(UIView*)view to:(CGFloat)alpha {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3f
                              delay:0.0f
             usingSpringWithDamping:.2f
              initialSpringVelocity:10.f
                            options:(UIViewAnimationOptionAllowUserInteraction |
                                     UIViewAnimationOptionCurveEaseInOut)
                         animations:^{
                             view.alpha = alpha;
                         }
                         completion:^(BOOL finished) {
                         }];
    });
}

+ (void)animateViewJiggle:(UIView*)view {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.15f
                              delay:0.0f
             usingSpringWithDamping:.2f
              initialSpringVelocity:10.f
                            options:(UIViewAnimationOptionAllowUserInteraction |
                                     UIViewAnimationOptionCurveEaseOut)
                         animations:^{
                             view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.05, 1.05);
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.3f
                                                   delay:0.0f
                                  usingSpringWithDamping:.3f
                                   initialSpringVelocity:10.0f
                                                 options:(UIViewAnimationOptionAllowUserInteraction |
                                                          UIViewAnimationOptionCurveEaseOut)
                                              animations:^{
                                                  view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                                              }
                                              completion:^(BOOL finished) {
                                              }];
                         }];
    });
}

+ (void)animateViewBigJiggle:(UIView *)view {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.3f
                              delay:0.0f
             usingSpringWithDamping:.3f
              initialSpringVelocity:8.f
                            options:(UIViewAnimationOptionAllowUserInteraction |
                                     UIViewAnimationOptionCurveEaseOut)
                         animations:^{
                             view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.2f
                                                   delay:0.0f
                                  usingSpringWithDamping:.3f
                                   initialSpringVelocity:7.0f
                                                 options:(UIViewAnimationOptionAllowUserInteraction |
                                                          UIViewAnimationOptionCurveEaseOut)
                                              animations:^{
                                                  view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                                              }
                                              completion:^(BOOL finished) {
                                              }];
                         }];
    });

}

+ (void)animateViewBigJiggleAlt:(UIView *)view {
    [UIView animateWithDuration:0.3f
                          delay:0.0f
         usingSpringWithDamping:.2f
          initialSpringVelocity:10.f
                        options:(UIViewAnimationOptionAllowUserInteraction |
                                 UIViewAnimationOptionCurveEaseOut)
                     animations:^{
                         view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                     }
                     completion:^(BOOL finished) {
                     }];
}

/* --------------------------------------------------- */

+ (UIButton *)makeButtonWithImage:(UIImage *)image frame:(CGRect)rect method:(NSString *)selector fromClass:(id)class {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:class
               action:NSSelectorFromString(selector)
     forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setFrame:rect];
    
    return button;
}

+ (UIButton *)makeButtonWithFrame:(CGRect)frame fontSize:(CGFloat)size title:(NSString *)title method:(NSString *)selector fromClass:(id)class {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:class
               action:NSSelectorFromString(selector)
     forControlEvents:UIControlEventTouchUpInside];
    [button.titleLabel setFont:[UIFont fontWithName:nnKitGlobalFont size:size]];
    [button setTitle:title forState:UIControlStateNormal];
    [button setFrame:frame];
    
    return button;
}

+ (UIButton *)makeButtonWithCenter:(CGPoint)center fontSize:(CGFloat)size title:(NSString *)title method:(NSString *)selector fromClass:(id)class {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:class
               action:NSSelectorFromString(selector)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:nnKitGlobalFont size:size]];
    [button setFrame:CGRectMake(0, 0, 0, 0)];
    [button sizeToFit];
    [button setCenter:center];

    return button;
}

+ (UIButton *)makeButtonWithOrigin:(CGPoint)origin fontSize:(CGFloat)size title:(NSString *)title method:(NSString *)selector fromClass:(id)class {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:class
               action:NSSelectorFromString(selector)
     forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont fontWithName:nnKitGlobalFont size:size]];
    [button setFrame:CGRectMake(origin.x, origin.y, 0, 0)];
    [button sizeToFit];
    
    return button;
}

/* --------------------------------------------------- */

+ (UILabel *)makeLabelWithFrame:(CGRect)rect fontSize:(CGFloat)size text:(NSString *)text {
    
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    [label setFont:[UIFont fontWithName:nnKitGlobalFont size:size]];
    [label setText:text];
    
    return label;
}

+ (UILabel *)makeLabelWithCenter:(CGPoint)center fontSize:(CGFloat)size text:(NSString *)text {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [label setFont:[UIFont fontWithName:nnKitGlobalFont size:size]];
    [label setText:text];
    [label sizeToFit];
    [label setCenter:center];
    
    return label;
}

+ (UILabel *)makeLabelWithOrigin:(CGPoint)origin fontSize:(CGFloat)size text:(NSString *)text {
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(origin.x, origin.y, 0, 0)];
    [label setFont:[UIFont fontWithName:nnKitGlobalFont size:size]];
    [label setText:text];
    [label sizeToFit];
    
    return label;
}

/* --------------------------------------------------- */

+ (UIColor *)randomColor {
    float red = ((arc4random() % 205) + 25.0) / 205.0;
    float green = ((arc4random() % 205) + 25.0) / 205.0;
    float blue = ((arc4random() % 205) + 25.0) / 205.0;
    UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];

    return color;
}
+ (NSArray *)colorTheme:(int)selection {
    NSArray *theme;
    UIColor *color0;
    UIColor *color1;
    UIColor *color2;
    UIColor *color3;
    UIColor *color4;

/*
case 0:
    color0 = UIColorFromHex(0x);
    color1 = UIColorFromHex(0x);
    color2 = UIColorFromHex(0x);
    color3 = UIColorFromHex(0x);
    color4 = UIColorFromHex(0x);
    break;
*/
    
    switch (selection) {
        case 0: //http://flatcolors.net/palette/451-i-too-know-beauty
            color0 = UIColorFromHex(0x4D545E);
            color1 = UIColorFromHex(0x586474);
            color2 = UIColorFromHex(0x72CCCA);
            color3 = UIColorFromHex(0xE2D6BE);
            color4 = UIColorFromHex(0xBD3C4E);
            break;
        case 1: //http://flatcolors.net/palette/996-flat-earth-therapy
            color0 = UIColorFromHex(0xEB6361);
            color1 = UIColorFromHex(0xEBBD63);
            color2 = UIColorFromHex(0x6C8784);
            color3 = UIColorFromHex(0x45362E);
            color4 = UIColorFromHex(0x87766C);
            break;
        case 2: //http://flatcolors.net/palette/522-my-crazyflat-ui
            color0 = UIColorFromHex(0x3E4651);
            color1 = UIColorFromHex(0xF1654C);
            color2 = UIColorFromHex(0x00B5B5);
            color3 = UIColorFromHex(0xFFFFFF);
            color4 = UIColorFromHex(0xD4D4D4);
            break;
        case 3: //http://flatcolors.net/palette/820-flat-moderne
            color0 = UIColorFromHex(0xD33257);
            color1 = UIColorFromHex(0x3D8EB9);
            color2 = UIColorFromHex(0x71BA51);
            color3 = UIColorFromHex(0xFEC606);
            color4 = UIColorFromHex(0xE75926);
            break;
        case 4: //http://flatcolors.net/palette/940-flat-design-2
            color0 = UIColorFromHex(0xFF6766);
            color1 = UIColorFromHex(0x60646D);
            color2 = UIColorFromHex(0xFFFFF7);
            color3 = UIColorFromHex(0x83D6DE);
            color4 = UIColorFromHex(0x97CE68);
            break;
        case 5: //http://flatcolors.net/palette/573-that-retro-flat
            color0 = UIColorFromHex(0x4CD4B0);
            color1 = UIColorFromHex(0xFFFCE6);
            color2 = UIColorFromHex(0xEDD834);
            color3 = UIColorFromHex(0xF24D16);
            color4 = UIColorFromHex(0x7D1424);
            break;
        case 6: //http://flatcolors.net/palette/266-muse
            color0 = UIColorFromHex(0xD4DBC8);
            color1 = UIColorFromHex(0xDBD880);
            color2 = UIColorFromHex(0xF9AE74);
            color3 = UIColorFromHex(0xCD6B97);
            color4 = UIColorFromHex(0x557780);
            break;
        case 7: //http://flatcolors.net/palette/534-flat-hip
            color0 = UIColorFromHex(0x462446);
            color1 = UIColorFromHex(0xB05F6D);
            color2 = UIColorFromHex(0xEB6B56);
            color3 = UIColorFromHex(0xFFC153);
            color4 = UIColorFromHex(0x47B39D);
            break;
        case 8: //http://flatcolors.net/palette/948-retro-70s
            color0 = UIColorFromHex(0xFCEBB6);
            color1 = UIColorFromHex(0x5E412F);
            color2 = UIColorFromHex(0xF07818);
            color3 = UIColorFromHex(0xF0A830);
            color4 = UIColorFromHex(0x78C0A8);
            break;
        case 9: //http://flatcolors.net/palette/203-flat-wbuttons
            color0 = UIColorFromHex(0xD1D5D8);
            color1 = UIColorFromHex(0x3498DB);
            color2 = UIColorFromHex(0xF1C40F);
            color3 = UIColorFromHex(0xE74C3C);
            color4 = UIColorFromHex(0x1ABC9C);
            break;
        case 10: //http://flatcolors.net/palette/327-float-flatly
            color0 = UIColorFromHex(0x4A4E4D);
            color1 = UIColorFromHex(0x0E9AA7);
            color2 = UIColorFromHex(0x3DA4AB);
            color3 = UIColorFromHex(0xF6CD61);
            color4 = UIColorFromHex(0xFE8A71);
            break;
        case 11: //http://flatcolors.net/palette/460-iam-truckburger
            color0 = UIColorFromHex(0xF2F8EA);
            color1 = UIColorFromHex(0x6797A1);
            color2 = UIColorFromHex(0xFABFA1);
            color3 = UIColorFromHex(0xE3E7B1);
            color4 = UIColorFromHex(0xECEFA9);
            break;
        case 12: //http://flatcolors.net/palette/982-flat
            color0 = UIColorFromHex(0x2C82C9);
            color1 = UIColorFromHex(0x2CC990);
            color2 = UIColorFromHex(0xEEE657);
            color3 = UIColorFromHex(0xFCB941);
            color4 = UIColorFromHex(0xFC6042);
            break;
            
        default:
            break;
    }
    
    theme = @[color0,color1,color2,color3,color4];
    return theme;
}

/* --------------------------------------------------- */

+ (void)addParallaxToView:(UIView *)view withAmount:(int)amount {
    
    view.frame = CGRectMake(view.frame.origin.x-amount, view.frame.origin.y-amount, view.frame.size.width+(amount*4), view.frame.size.height+(amount*4));
    
    for (UIView *sub in view.subviews) {
        sub.frame = CGRectMake(sub.frame.origin.x-amount, sub.frame.origin.y-amount, sub.frame.size.width+(amount*4), sub.frame.size.height+(amount*4));
    }
    
    // Set vertical effect
    UIInterpolatingMotionEffect *verticalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.y"
     type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
    verticalMotionEffect.minimumRelativeValue = @(-amount);
    verticalMotionEffect.maximumRelativeValue = @(amount);
    
    // Set horizontal effect
    UIInterpolatingMotionEffect *horizontalMotionEffect =
    [[UIInterpolatingMotionEffect alloc]
     initWithKeyPath:@"center.x"
     type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
    horizontalMotionEffect.minimumRelativeValue = @(-amount);
    horizontalMotionEffect.maximumRelativeValue = @(amount);
    
    // Create group to combine both
    UIMotionEffectGroup *group = [UIMotionEffectGroup new];
    group.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
    
    // Add both effects to your view
    [view addMotionEffect:group];
}

+ (void)addBlurToView:(UIView *)view isDark:(BOOL)dark withAlpha:(float)alpha {
    view.backgroundColor = [UIColor clearColor];
    UIToolbar* bgToolbar = [[UIToolbar alloc] initWithFrame:view.frame];
    if (dark) {
        bgToolbar.barStyle = UIBarStyleBlackTranslucent;
    } else {
        bgToolbar.barStyle = UIBarStyleDefault;
    }
    
    bgToolbar.alpha = alpha;
    [view addSubview:bgToolbar];
}

+ (UIView *)resizeView:(UIView *)view inViewBounds:(CGRect)bounds withRatio:(CGFloat)ratio {
    view.bounds = CGRectMake(bounds.size.width*((1-ratio)/2),
                             bounds.size.height*((1-ratio)/2),
                             bounds.size.width*ratio,
                             bounds.size.height*ratio);
    return view;
}

+ (UIImageView *)resizeImageView:(UIImageView *)view inViewBounds:(CGRect)bounds withRatio:(CGFloat)ratio {
    view.bounds = CGRectMake(bounds.size.width*((1-ratio)/2),
                             bounds.size.height*((1-ratio)/2),
                             bounds.size.width*ratio,
                             bounds.size.height*ratio);
    return view;
}

+ (UIImage *)resizeImage:(UIImage *)image inViewBounds:(CGRect)bounds withRatio:(CGFloat)ratio {
    
    UIGraphicsBeginImageContext(bounds.size);
    [image drawInRect:CGRectMake(bounds.size.width*((1-ratio)/2),
                                 bounds.size.height*((1-ratio)/2),
                                 bounds.size.width*ratio,
                                 bounds.size.height*ratio)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/* --------------------------------------------------- */

+ (NSString *)getIPAddress:(BOOL)preferIPv4
{
    NSArray *searchArray = preferIPv4 ?
    @[ IOS_WIFI @"/" IP_ADDR_IPv4, IOS_WIFI @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6 ] :
    @[ IOS_WIFI @"/" IP_ADDR_IPv6, IOS_WIFI @"/" IP_ADDR_IPv4, IOS_CELLULAR @"/" IP_ADDR_IPv6, IOS_CELLULAR @"/" IP_ADDR_IPv4 ] ;
    
    
    NSMutableDictionary *addresses1 = [NSMutableDictionary dictionaryWithCapacity:8];
    
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) || (interface->ifa_flags & IFF_LOOPBACK)) {
                continue;
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                char addrBuf[INET6_ADDRSTRLEN];
                if(inet_ntop(addr->sin_family, &addr->sin_addr, addrBuf, sizeof(addrBuf))) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, addr->sin_family == AF_INET ? IP_ADDR_IPv4 : IP_ADDR_IPv6];
                    addresses1[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        freeifaddrs(interfaces);
    }
    
    NSDictionary *addresses = [addresses1 count] ? addresses1 : nil;
    //NSLog(@"addresses: %@", addresses);
    
    __block NSString *address;
    [searchArray enumerateObjectsUsingBlock:^(NSString *key, NSUInteger idx, BOOL *stop)
     {
         address = addresses[key];
         if(address) *stop = YES;
     } ];
    return address ? address : @"0.0.0.0";
}

+ (BOOL)isValidIpAddress:(NSString *)ip {
    const char *utf8 = [ip UTF8String];
    
    struct in_addr dst;
    int success = inet_pton(AF_INET, utf8, &(dst.s_addr));
    if (success != 1) {
        struct in6_addr dst6;
        success = inet_pton(AF_INET6, utf8, &dst6);
    }
    return (success);
}

/* --------------------------------------------------- */
// Use these to only check screen sizes
// It's better to check for individual device functions like telephone calls or camera rather than to check for specific devices

//NSString *deviceType = [UIDevice currentDevice].model;
//if([deviceType isEqualToString:@"iPhone"])

+(BOOL)isIPad {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    } else {
        return NO;
    }
}
+(BOOL)isRetina {
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2.0)
        return YES;
    else
        return NO;
}
+(BOOL)isIPhone4 {
    if ([self isIPad] == NO && MAX(([[UIScreen mainScreen] bounds].size.width), ([[UIScreen mainScreen] bounds].size.height)) < 568.0) {
        return YES;
    } else {
        return NO;
    }
}
+(BOOL)isIPhone5orIPodTouch {
    if ([self isIPad] == NO && MAX(([[UIScreen mainScreen] bounds].size.width), ([[UIScreen mainScreen] bounds].size.height)) == 568.0) {
        return YES;
    } else {
        return NO;
    }
}
+(BOOL)isIPhone6 {
    if ([self isIPad] == NO && MAX(([[UIScreen mainScreen] bounds].size.width), ([[UIScreen mainScreen] bounds].size.height)) == 667.0) {
        return YES;
    } else {
        return NO;
    }
}
+(BOOL)isIPhone6P {
    if ([self isIPad] == NO && MAX(([[UIScreen mainScreen] bounds].size.width), ([[UIScreen mainScreen] bounds].size.height)) == 736.0) {
        return YES;
    } else {
        return NO;
    }
}

/* --------------------------------------------------- */

- (void)simpleAlert:(NSString*)title message:(NSString*)message {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:title
                                  message:message
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction
                         actionWithTitle:@"OK"
                         style:UIAlertActionStyleDefault
                         handler:^(UIAlertAction * action)
                         {
                             [alert dismissViewControllerAnimated:YES completion:nil];
                             
                         }];
    
    [alert addAction:ok];
    
    [[nnKit currentTopViewController] presentViewController:alert animated:YES completion:nil];
}

@end
