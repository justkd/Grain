//
//  NNColorThemePicker.h
//
//  Created by Danny Holmes.
//  Copyright (c) 2015 Danny Holmes, notnatural.co.
//

/*
The MIT License (MIT)

Copyright (c) 2015 Danny Holmes, notnatural.co.

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
#import "NNColorThemes.h"
#import "NNPopUpTable.h"

@interface NNColorThemePicker : UIControl

@property (nonatomic, strong) NSArray *theme;
@property (nonatomic, strong) NSArray *themes;
@property (nonatomic, strong) NSArray *selections;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSString *s0;
@property (nonatomic, strong) NSString *s1;
@property (nonatomic, strong) NSString *s2;
@property (nonatomic, strong) NSString *s3;
@property (nonatomic, strong) NSString *s4;
@property (nonatomic, strong) UIColor *c0;
@property (nonatomic, strong) UIColor *c1;
@property (nonatomic, strong) UIColor *c2;
@property (nonatomic, strong) UIColor *c3;
@property (nonatomic, strong) UIColor *c4;
@property (nonatomic, strong) NNPopUpTable *popView;
@property (nonatomic) BOOL popVisible;
@property (nonatomic) BOOL portait;

-(void)makeViewWithRect:(CGRect)rect;

@end
