//
//  UIColor+NNColors.h
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
UIColor+MLPFlatColors.h

Created by Eddy Borja on 4/10/13.
Copyright (c) 2013 Mainloop LLC. All rights reserved.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

/*
UIColor+HBVHarmonies.h

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

#import <UIKit/UIKit.h>

#define UIColorFromHex(hexvalue_replace_hash_with_0x) [UIColor colorWithRed:((float)((hexvalue_replace_hash_with_0x & 0xFF0000) >> 16))/255.0 \
                                                 green:((float)((hexvalue_replace_hash_with_0x & 0xFF00) >> 8))/255.0 \
                                                  blue:((float)(hexvalue_replace_hash_with_0x & 0xFF))/255.0 \
                                                 alpha:1.0]

@interface UIColor (NNColors)

+ (NSString*)colorToWeb:(UIColor*)color;

+ (UIColor *)nnTurqoise;
+ (UIColor *)nnGreenSea;
+ (UIColor *)nnEmerald;
+ (UIColor *)nnNephritisGreen;
+ (UIColor *)nnPeterRiverBlue;
+ (UIColor *)nnBelizeHoleBlue;
+ (UIColor *)nnAmethystPurple;
+ (UIColor *)nnWisteriaTwoPurple;
+ (UIColor *)nnWetAsphaltBlue;
+ (UIColor *)nnMidnightBlue;
+ (UIColor *)nnSunflowerYellow;
+ (UIColor *)nnOrange;
+ (UIColor *)nnCarrotOrange;
+ (UIColor *)nnPumpkinOrange;
+ (UIColor *)nnAlizarinCoral;
+ (UIColor *)nnPomegranateCoral;
+ (UIColor *)nnCloudWhite;
+ (UIColor *)nnSilver;
+ (UIColor *)nnConcreteGray;
+ (UIColor *)nnAsbestosGray;

+ (UIColor *)nnFernGreen;
+ (UIColor *)nnChateauGreen;
+ (UIColor *)nnMountainMeadowGreen;
+ (UIColor *)nnPersianGreen;
+ (UIColor *)nnPictonBlue;
+ (UIColor *)nnCuriousBlue;
+ (UIColor *)nnMarinerBlue;
+ (UIColor *)nnDenimBlue;
+ (UIColor *)nnWisteriaPurple;
+ (UIColor *)nnGemPurple;
+ (UIColor *)nnChambrayBlueGray;
+ (UIColor *)nnWhaleBlueGray;
+ (UIColor *)nnEnergyYellow;
+ (UIColor *)nnTurboYellow;
+ (UIColor *)nnNeonCarrotOrange;
+ (UIColor *)nnSunOrange;
+ (UIColor *)nnTerraCottaCoral;
+ (UIColor *)nnValenciaCoral;
+ (UIColor *)nnCinnabarRed;
+ (UIColor *)nnWellReadRed;
+ (UIColor *)nnAlmostFrostGray;
+ (UIColor *)nnDarkIronGray;
+ (UIColor *)nnIronGray;
+ (UIColor *)nnWhiteSmoke;

+ (UIColor *)flatRedColor;
+ (UIColor *)flatDarkRedColor;
+ (UIColor *)flatGreenColor;
+ (UIColor *)flatDarkGreenColor;
+ (UIColor *)flatBlueColor;
+ (UIColor *)flatDarkBlueColor;
+ (UIColor *)flatTealColor;
+ (UIColor *)flatDarkTealColor;
+ (UIColor *)flatPurpleColor;
+ (UIColor *)flatDarkPurpleColor;
+ (UIColor *)flatBlackColor;
+ (UIColor *)flatDarkBlackColor;
+ (UIColor *)flatYellowColor;
+ (UIColor *)flatDarkYellowColor;
+ (UIColor *)flatOrangeColor;
+ (UIColor *)flatDarkOrangeColor;
+ (UIColor *)flatWhiteColor;
+ (UIColor *)flatDarkWhiteColor;
+ (UIColor *)flatGrayColor;
+ (UIColor *)flatDarkGrayColor;
+ (UIColor *)flatRandomColor;
+ (UIColor *)flatRandomLightColor;
+ (UIColor *)flatRandomDarkColor;

//Create a color harmony from the caller by applying one expression to each color component (R,G,B, range 0.0 - 1.0) of a UIColor instance. Expression block must return a CGFloat, double, or float. Alpha is set directly.
- (UIColor *)colorHarmonyWithExpression:(CGFloat(^)(CGFloat value))expression alpha:(CGFloat)alpha;

//Create a color harmony from the caller by apply an abitrary expression to each color component and alpha channel. Expression block must return a C array containing 4 CGFloats, doubles, or floats.
- (UIColor *)colorHarmonyWithExpressionOnComponents:(CGFloat*(^)(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha))componentsExpression;

//Same as above, but expression block must return an NSArray containing NSNumber instances representing the R-G-B-A components of the desired return instance. For those squeamish about using malloc.
- (UIColor *)colorHarmonyWithComponentArray:(NSArray*(^)(CGFloat red, CGFloat green, CGFloat blue, CGFloat alpha))componentsExpression;

//Class method, returns an instance of UIColor composed of random (uniform) R-G-B components
+ (UIColor *)randomColor;

//Convenience method returns color complement of the calling instance by applying the expression (1-x) to each color component
- (UIColor *)complement;

//Returns an instance of UIColor in which the caller's RGB components are jittered by a proportion (percent, range 0.0 - 100.0) of the caller's RGB component values.
- (UIColor *)jitterWithPercent:(CGFloat)percent;
@end
