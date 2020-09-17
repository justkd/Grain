//
//  nnKit.h
//
//  Created by Cady Holmes on 9/8/15.
//  Copyright © 2015-present Cady Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

typedef void(^completion)(BOOL);
static NSString* const nnKitGlobalFont = @"HelveticaNeue-CondensedBold";

#ifdef DEBUG
#define clog(FORMAT, ...) fprintf(stderr,"%s\n", [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define NSLog(...)
#endif

//#define CLIP(x, low, high) ({\
//__typeof__(x) __x = (x);\
//__typeof__(low) __low = (low);\
//__typeof__(high) __high = (high);\
//__x > __high ? __high : (__x < __low ? __low : __x);\
//})

//#define SCALE(x, min1, max1, min2, max2) ({\
//__typeof__(x) __x = (x); \
//__typeof__(min1) __min1 = (min1);\
//__typeof__(max1) __max1 = (max1);\
//__typeof__(min2) __min2 = (min2);\
//__typeof__(max2) __max2 = (max2);\
//(__max2 - __min2) * __x / (__max1 - __min1) + __min2; \
//})

#define RADIANS(degrees) ((degrees * M_PI) / 180.0)

#define RAND(max) (arc4random() % ((unsigned)max + 1))

#define UIColorFromHex(hexvalue_replace_hash_with_0x) [UIColor colorWithRed:((float)((hexvalue_replace_hash_with_0x & 0xFF0000) >> 16))/255.0 \
green:((float)((hexvalue_replace_hash_with_0x & 0xFF00) >> 8))/255.0 \
blue:((float)(hexvalue_replace_hash_with_0x & 0xFF))/255.0 \
alpha:1.0]

// xf = k * xf + (1.0 - k) * x;
//acceleration = .9 * self.lastAcceleration + (1.0 - .9) * acceleration;

static inline float FILTER(float input,float lastInput,float k) {return k*lastInput+(1.0-k)*input;}
static inline float CLIP(float input,float min,float max) {return MAX(min,MIN(max,input));}
static inline float SCALE(float input,float min1,float max1,float min2,float max2) {return (((input-min1)*(max2-min2))/(max1-min1))+min2;}
static inline int CLIPI(int input,int min,int max) {return MAX(min,MIN(max,input));}
static inline int SCALEI(int input,int min1,int max1,int min2,int max2) {return (((input-min1)*(max2-min2))/(max1-min1))+min2;}

static inline CGFloat SH() { return [[UIScreen mainScreen] bounds].size.height; }
static inline CGFloat SW() { return [[UIScreen mainScreen] bounds].size.width; }
static inline CGFloat SB() { return [UIApplication sharedApplication].statusBarFrame.size.height; }
static inline CGFloat OX(UIView *view) { return view.frame.origin.x; }
static inline CGFloat OY(UIView *view) { return view.frame.origin.y; }
static inline CGFloat VH(UIView *view) { return view.frame.size.height; }
static inline CGFloat VW(UIView *view) { return view.frame.size.width; }

@interface nnKit : NSObject

//@property (nonatomic, strong) NSMutableArray *UI;

/* --------------------------------------------------- */
+ (UIViewController *)currentTopViewController;
/* --------------------------------------------------- */
+ (double)filterCurrentInput:(double)x lastOutput:(double)y andK:(double)kk;
+ (double)linearToExponential:(double)input inputMIN:(double)iMIN inputMAX:(double)iMAX outputMIN:(double)oMIN outputMAX:(double)oMAX;
+ (void)delayThis: (void(^)(void))callback for: (double)delayInSeconds;
/* --------------------------------------------------- */
+ (void)animateViewGrowAndShow:(UIView*)view or:(UIImageView*)imageView completion:(completion)completionBlock;
+ (void)animateViewShrinkAndWink:(UIView*)view or:(UIImageView*)imageView andRemoveFromSuperview:(BOOL)removeFromSuperview completion:(completion)completionBlock;
+ (void)animateViewAlpha:(UIView*)view to:(CGFloat)alpha;
+ (void)animateViewJiggle:(UIView *)view;
+ (void)animateViewBigJiggle:(UIView *)view;
+ (void)animateViewBigJiggleAlt:(UIView *)view;
/* --------------------------------------------------- */
+ (UIButton *)makeButtonWithImage:(UIImage *)image frame:(CGRect)rect method:(NSString *)selector fromClass:(id)class;
+ (UIButton *)makeButtonWithFrame:(CGRect)frame fontSize:(CGFloat)size title:(NSString *)title method:(NSString *)selector fromClass:(id)class;
+ (UIButton *)makeButtonWithCenter:(CGPoint)center fontSize:(CGFloat)size title:(NSString *)title method:(NSString *)selector fromClass:(id)class;
+ (UIButton *)makeButtonWithOrigin:(CGPoint)origin fontSize:(CGFloat)size title:(NSString *)title method:(NSString *)selector fromClass:(id)class;
/* --------------------------------------------------- */
+ (UILabel *)makeLabelWithFrame:(CGRect)rect fontSize:(CGFloat)size text:(NSString *)text;
+ (UILabel *)makeLabelWithCenter:(CGPoint)center fontSize:(CGFloat)size text:(NSString *)text;
+ (UILabel *)makeLabelWithOrigin:(CGPoint)origin fontSize:(CGFloat)size text:(NSString *)text;
/* --------------------------------------------------- */
+ (UIColor *)randomColor;
+ (NSArray *)colorTheme:(int)selection;
/* --------------------------------------------------- */
+ (void)addParallaxToView:(UIView *)view withAmount:(int)amount;
+ (void)addBlurToView:(UIView *)view isDark:(BOOL)dark withAlpha:(float)alpha;
+ (UIView *)resizeView:(UIView *)view inViewBounds:(CGRect)bounds withRatio:(CGFloat)ratio;
+ (UIImageView *)resizeImageView:(UIImageView *)view inViewBounds:(CGRect)bounds withRatio:(CGFloat)ratio;
+ (UIImage *)resizeImage:(UIImage *)image inViewBounds:(CGRect)bounds withRatio:(CGFloat)ratio;
/* --------------------------------------------------- */
+ (NSString *)getIPAddress:(BOOL)preferIPv4;
+ (BOOL)isValidIpAddress:(NSString *)ip;
/* --------------------------------------------------- */
// Use these to only check screen sizes
// It's better to check for individual device functions like telephone calls or camera rather than to check for specific devices
+(BOOL)isIPad;
+(BOOL)isRetina;
+(BOOL)isIPhone4;
+(BOOL)isIPhone5orIPodTouch;
+(BOOL)isIPhone6;
+(BOOL)isIPhone6P;
/* --------------------------------------------------- */

@end
