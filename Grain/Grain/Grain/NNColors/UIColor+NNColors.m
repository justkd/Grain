//
//  UIColor+NNColors.m
//
//  Created by Cady Holmes.
//  Copyright (c) 2015-present Cady Holmes.
//

/*
The MIT License (MIT)

Copyright (c) 2015.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

/*
UIColor+MLPFlatColors.m

Created by Eddy Borja on 4/10/13.
Copyright (c) 2013 Mainloop LLC. All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

/*
UIColor+HBVHarmonies.m

The MIT License (MIT)

Copyright (c) 2014 Travis Henspeter

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/



#import "UIColor+NNColors.h"

@implementation UIColor (NNColors)

+ (NSString*)colorToWeb:(UIColor*)color
{
    NSString *webColor = nil;
    
    // This method only works for RGB colors
    if (color &&
        CGColorGetNumberOfComponents(color.CGColor) == 4)
    {
        // Get the red, green and blue components
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        
        // These components range from 0.0 till 1.0 and need to be converted to 0 till 255
        CGFloat red, green, blue;
        red = roundf(components[0] * 255.0);
        green = roundf(components[1] * 255.0);
        blue = roundf(components[2] * 255.0);
        
        // Convert with %02x (use 02 to always get two chars)
        webColor = [[NSString alloc]initWithFormat:@"%02x%02x%02x", (int)red, (int)green, (int)blue];
    }
    
    return webColor;
}
















/* From http://flatui.com/flat-ui-color-palette/ by Designmodo */
+ (UIColor *)nnTurqoise
{
    return UIColorFromHex(0x1ABC9C);
}
+ (UIColor *)nnGreenSea
{
    return UIColorFromHex(0x16A085);
}
+ (UIColor *)nnEmerald
{
    return UIColorFromHex(0x2ECC71);
}
+ (UIColor *)nnNephritisGreen
{
    return UIColorFromHex(0x27AE60);
}
+ (UIColor *)nnPeterRiverBlue
{
    return UIColorFromHex(0x3498DB);
}
+ (UIColor *)nnBelizeHoleBlue
{
    return UIColorFromHex(0x2980B9);
}
+ (UIColor *)nnAmethystPurple
{
    return UIColorFromHex(0x9B59B6);
}
+ (UIColor *)nnWisteriaTwoPurple
{
    return UIColorFromHex(0x8E44AD);
}
+ (UIColor *)nnWetAsphaltBlue
{
    return UIColorFromHex(0x34495E);
}
+ (UIColor *)nnMidnightBlue
{
    return UIColorFromHex(0x2C3E50);
}
+ (UIColor *)nnSunflowerYellow
{
    return UIColorFromHex(0xF1C40F);
}
+ (UIColor *)nnOrange
{
    return UIColorFromHex(0xF39C12);
}
+ (UIColor *)nnCarrotOrange
{
    return UIColorFromHex(0xE67E22);
}
+ (UIColor *)nnPumpkinOrange
{
    return UIColorFromHex(0xD35400);
}
+ (UIColor *)nnAlizarinCoral
{
    return UIColorFromHex(0xE74C3C);
}
+ (UIColor *)nnPomegranateCoral
{
    return UIColorFromHex(0xC0392B);
}
+ (UIColor *)nnCloudWhite
{
    return UIColorFromHex(0xECF0F1);
}
+ (UIColor *)nnSilver
{
    return UIColorFromHex(0xBDC3C7);
}
+ (UIColor *)nnConcreteGray
{
    return UIColorFromHex(0x95A5A6);
}
+ (UIColor *)nnAsbestosGray
{
    return UIColorFromHex(0x7F8C8D);
}

/* From http://www.flatdesigncolors.com/ by Froala */
+ (UIColor *)nnFernGreen
{
    return UIColorFromHex(0x61BD6D);
}
+ (UIColor *)nnChateauGreen
{
    return UIColorFromHex(0x41A85F);
}
+ (UIColor *)nnMountainMeadowGreen
{
    return UIColorFromHex(0x1ABC9C);
}
+ (UIColor *)nnPersianGreen
{
    return UIColorFromHex(0x00A885);
}
+ (UIColor *)nnPictonBlue
{
    return UIColorFromHex(0x54ACD2);
}
+ (UIColor *)nnCuriousBlue
{
    return UIColorFromHex(0x3D8EB9);
}
+ (UIColor *)nnMarinerBlue
{
    return UIColorFromHex(0x2C82C9);
}
+ (UIColor *)nnDenimBlue
{
    return UIColorFromHex(0x2969B0);
}
+ (UIColor *)nnWisteriaPurple
{
    return UIColorFromHex(0x9365B8);
}
+ (UIColor *)nnGemPurple
{
    return UIColorFromHex(0x553982);
}
+ (UIColor *)nnChambrayBlueGray
{
    return UIColorFromHex(0x475577);
}
+ (UIColor *)nnWhaleBlueGray
{
    return UIColorFromHex(0x28324E);
}
+ (UIColor *)nnEnergyYellow
{
    return UIColorFromHex(0xF7DA64);
}
+ (UIColor *)nnTurboYellow
{
    return UIColorFromHex(0xFAC51C);
}
+ (UIColor *)nnNeonCarrotOrange
{
    return UIColorFromHex(0xFBA026);
}
+ (UIColor *)nnSunOrange
{
    return UIColorFromHex(0xF37934);
}
+ (UIColor *)nnTerraCottaCoral
{
    return UIColorFromHex(0xEB6B56);
}
+ (UIColor *)nnValenciaCoral
{
    return UIColorFromHex(0xD14841);
}
+ (UIColor *)nnCinnabarRed
{
    return UIColorFromHex(0xE25041);
}
+ (UIColor *)nnWellReadRed
{
    return UIColorFromHex(0xB8312F);
}
+ (UIColor *)nnAlmostFrostGray
{
    return UIColorFromHex(0xA38F84);
}
+ (UIColor *)nnDarkIronGray
{
    return UIColorFromHex(0x75706B);
}
+ (UIColor *)nnIronGray
{
    return UIColorFromHex(0xD1D5D8);
}
+ (UIColor *)nnWhiteSmoke
{
    return UIColorFromHex(0xEFEFEF);
}

//+ (UIColor *)nn
//{
//    return UIColorFromHex(0x);
//}



#pragma mark - MLPFlatColors
+ (UIColor *)flatRedColor
{
    return UIColorFromHex(0xE74C3C);
}
+ (UIColor *)flatDarkRedColor
{
    return UIColorFromHex(0xC0392B);
}
+ (UIColor *)flatGreenColor
{
    return UIColorFromHex(0x2ECC71);
}
+ (UIColor *)flatDarkGreenColor
{
    return UIColorFromHex(0x27AE60);
}
+ (UIColor *)flatBlueColor
{
    return UIColorFromHex(0x3498DB);
}
+ (UIColor *)flatDarkBlueColor
{
    return UIColorFromHex(0x2980B9);
}
+ (UIColor *)flatTealColor
{
    return UIColorFromHex(0x1ABC9C);
}
+ (UIColor *)flatDarkTealColor
{
    return UIColorFromHex(0x16A085);
}
+ (UIColor *)flatPurpleColor
{
    return UIColorFromHex(0x9B59B6);
}
+ (UIColor *)flatDarkPurpleColor
{
    return UIColorFromHex(0x8E44AD);
}
+ (UIColor *)flatYellowColor
{
    return UIColorFromHex(0xF1C40F);
}
+ (UIColor *)flatDarkYellowColor
{
    return UIColorFromHex(0xF39C12);
}
+ (UIColor *)flatOrangeColor
{
    return UIColorFromHex(0xE67E22);
}
+ (UIColor *)flatDarkOrangeColor
{
    return UIColorFromHex(0xD35400);
}
+ (UIColor *)flatGrayColor
{
    return UIColorFromHex(0x95A5A6);
}
+ (UIColor *)flatDarkGrayColor
{
    return UIColorFromHex(0x7F8C8D);
}
+ (UIColor *)flatWhiteColor
{
    return UIColorFromHex(0xECF0F1);
}
+ (UIColor *)flatDarkWhiteColor
{
    return UIColorFromHex(0xBDC3C7);
}
+ (UIColor *)flatBlackColor
{
    return UIColorFromHex(0x34495E);
}
+ (UIColor *)flatDarkBlackColor
{
    return UIColorFromHex(0x2C3E50);
}
// Random
+ (UIColor *)flatRandomColor
{
    return [UIColor randomFlatColorIncludeLightShades:YES darkShades:YES];
}

+ (UIColor *)flatRandomLightColor
{
    return [UIColor randomFlatColorIncludeLightShades:YES darkShades:NO];
}

+ (UIColor *)flatRandomDarkColor
{
    return [UIColor randomFlatColorIncludeLightShades:NO darkShades:YES];
}

+ (UIColor *)randomFlatColorIncludeLightShades:(BOOL)useLightShades
                                    darkShades:(BOOL)useDarkShades;
{
    const NSInteger numberOfLightColors = 10;
    const NSInteger numberOfDarkColors = 10;
    NSAssert(useLightShades || useDarkShades, @"Must choose random color using at least light shades or dark shades.");
    
    
    u_int32_t numberOfColors = 0;
    if(useLightShades){
        numberOfColors += numberOfLightColors;
    }
    if(useDarkShades){
        numberOfColors += numberOfDarkColors;
    }
    
    u_int32_t chosenColor = arc4random_uniform(numberOfColors);
    
    if(!useLightShades){
        chosenColor += numberOfLightColors;
    }
    
    UIColor *color;
    switch (chosenColor) {
        case 0:
            color = [UIColor flatRedColor];
            break;
        case 1:
            color = [UIColor flatGreenColor];
            break;
        case 2:
            color = [UIColor flatBlueColor];
            break;
        case 3:
            color = [UIColor flatTealColor];
            break;
        case 4:
            color = [UIColor flatPurpleColor];
            break;
        case 5:
            color = [UIColor flatYellowColor];
            break;
        case 6:
            color = [UIColor flatOrangeColor];
            break;
        case 7:
            color = [UIColor flatGrayColor];
            break;
        case 8:
            color = [UIColor flatWhiteColor];
            break;
        case 9:
            color = [UIColor flatBlackColor];
            break;
        case 10:
            color = [UIColor flatDarkRedColor];
            break;
        case 11:
            color = [UIColor flatDarkGreenColor];
            break;
        case 12:
            color = [UIColor flatDarkBlueColor];
            break;
        case 13:
            color = [UIColor flatDarkTealColor];
            break;
        case 14:
            color = [UIColor flatDarkPurpleColor];
            break;
        case 15:
            color = [UIColor flatDarkYellowColor];
            break;
        case 16:
            color = [UIColor flatDarkOrangeColor];
            break;
        case 17:
            color = [UIColor flatDarkGrayColor];
            break;
        case 18:
            color = [UIColor flatDarkWhiteColor];
            break;
        case 19:
            color = [UIColor flatDarkBlackColor];
            break;
        case 20:
        default:
            NSAssert(0, @"Unrecognized color selected as random color");
            break;
    }
    
    return color;
}


#pragma mark - HBVHarmonies

- (UIColor *)jitterWithPercent:(CGFloat)percent
{
    UIColor *result = nil;
    CGFloat newComponents[3];
    for (NSInteger index = 0; index < 3; index ++) {
        CGFloat oldComponent = CGColorGetComponents(self.CGColor)[index];
        CGFloat random = ((CGFloat)arc4random_uniform(200) - 100.0f) * 0.01;
        CGFloat newComponent = oldComponent + random * percent * 0.01;
        newComponents[index] = [UIColor clipValue:newComponent withMin:0 max:1.0f];
    }
    
    result = [UIColor colorWithRed:newComponents[0] green:newComponents[1] blue:newComponents[2] alpha:1.0];
    return result;
}

- (UIColor *)complement
{
    return [self colorHarmonyWithExpression:^CGFloat(CGFloat value) {
        return 1.0f - value;
    } alpha:1.0];
}

+ (UIColor *)randomColor
{
    CGFloat red = (CGFloat)arc4random_uniform(255)/255.0f;
    CGFloat green = (CGFloat)arc4random_uniform(255)/255.0f;
    CGFloat blue = (CGFloat)arc4random_uniform(255)/255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

- (UIColor *)colorHarmonyWithExpression:(CGFloat(^)(CGFloat value))expression alpha:(CGFloat)alpha
{
    UIColor *result = nil;
    CGFloat newComponents[3];
    for (NSInteger index = 0; index < 3; index ++) {
        CGFloat oldComponent = CGColorGetComponents(self.CGColor)[index];
        CGFloat expressionResult = expression(oldComponent);
        newComponents[index] = [UIColor clipValue:expressionResult withMin:0 max:1.0f];
    }
    
    result = [UIColor colorWithRed:newComponents[0] green:newComponents[1] blue:newComponents[2] alpha:alpha];
    return result;
}

- (UIColor *)colorHarmonyWithExpressionOnComponents:(CGFloat*(^)(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha))componentsExpression;
{
    UIColor *result = nil;
    CGFloat oldComponents[4];
    for (NSInteger index = 0; index < 4; index ++) {
        CGFloat oldComponent = CGColorGetComponents(self.CGColor)[index];
        oldComponents[index] = oldComponent;
    }
    
    CGFloat *expressionResult = malloc(sizeof(CGFloat) * 4);
    expressionResult = componentsExpression(oldComponents[0],oldComponents[1],oldComponents[2],oldComponents[3]);
    CGFloat newComponents[4];
    for (NSInteger index = 0; index < 4; index ++) {
        newComponents[index] = [UIColor clipValue:expressionResult[index] withMin:0.0 max:1.0];
    }
    
    result = [UIColor colorWithRed:newComponents[0] green:newComponents[1] blue:newComponents[2] alpha:newComponents[3]];
    return result;
}

- (UIColor *)colorHarmonyWithComponentArray:(NSArray*(^)(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha))componentsExpression
{
    UIColor *result = nil;
    CGFloat oldComponents[4];
    for (NSInteger index = 0; index < 4; index ++) {
        CGFloat oldComponent = CGColorGetComponents(self.CGColor)[index];
        oldComponents[index] = oldComponent;
    }
    
    NSArray *expressionResult = componentsExpression(oldComponents[0],oldComponents[1],oldComponents[2],oldComponents[3]);
    CGFloat newComponents[4];
    for (NSInteger index = 0; index < expressionResult.count; index++) {
        newComponents[index] = [expressionResult[index] doubleValue];
    }
    
    result = [UIColor colorWithRed:newComponents[0] green:newComponents[1] blue:newComponents[2] alpha:newComponents[3]];
    return result;
}

+ (CGFloat)clipValue:(CGFloat)value withMin:(CGFloat)min max:(CGFloat)max
{
    CGFloat result;
    
    result = MIN(value, max);
    result = MAX(value, min);

    return result;
}






/*  Example implementation
 
 - (void)doDemo
 {
 UIColor *red = [UIColor redColor];
 UIColor *burgundy = [self burgundy];
 UIColor *blue = [UIColor blueColor];
 UIColor *aqua = [self aqua];
 UIColor *aquaComplement = [aqua complement];
 UIColor *jitter10 = [aquaComplement jitterWithPercent:10];
 UIColor *jitter50 = [jitter10 jitterWithPercent:50];
 UIColor *random1 = [UIColor randomColor];
 UIColor *random2 = [UIColor randomColor];
 self.demoColors = @[red,burgundy,blue,aqua,aquaComplement,jitter10,jitter50,random1,random2];
 self.colorNames = @[@"system red",@"Red component * 0.4 = burgundy",@"system blue",@"Blue + math = aqua",@"aqua complement",@"jitter by 10%",@"jitter by 50%",@"just a random color",@"just another random color"];
 [self nextColor];
 self.demoTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(nextColor) userInfo:nil repeats:YES];
 }
 
 - (void)nextColor
 {
 static NSInteger index;
 if (index >= self.demoColors.count) {
 [self.demoTimer invalidate];
 self.demoTimer = nil;
 self.view.backgroundColor = [UIColor whiteColor];
 self.demoLabel.text = @"That's all folks!";
 self.demoLabel.textColor = [UIColor blackColor];
 return;
 }
 
 __weak ViewController *weakself =self;
 
 [UIView animateWithDuration:0.3 animations:^{
 weakself.view.backgroundColor = self.demoColors[index];
 weakself.demoLabel.text = self.colorNames[index];
 weakself.demoLabel.textColor = [self.view.backgroundColor complement];
 }];
 
 index++;
 }
 
 - (UIColor *)burgundy
 {
 UIColor *red = [UIColor redColor];
 UIColor *burgundy = [red colorHarmonyWithExpressionOnComponents:^CGFloat *(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha) {
 CGFloat *result = malloc(sizeof(CGFloat) * 4);
 result[0] = red * 0.4;
 result[1] = green;
 result[2] = blue;
 result[3] = alpha;
 return result;
 }];
 
 return burgundy;
 }
 
 - (UIColor *)aqua
 {
 UIColor *blue = [UIColor blueColor];
 UIColor *aqua = [blue colorHarmonyWithComponentArray:^NSArray *(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha) {
 CGFloat newRed = red;
 CGFloat newBlue = (blue-0.1)*(blue-0.1);
 CGFloat newGreen = newBlue * 0.9;
 CGFloat newAlpha = alpha;
 return @[@(newRed),@(newGreen),@(newBlue),@(newAlpha)];
 }];
 
 return aqua;
 }
 */


@end
