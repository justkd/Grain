//
//  NNColorThemePicker.m
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

#import "NNColorThemePicker.h"

@implementation NNColorThemePicker

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setDefaults];
    }
    return self;
}
-(void)drawRect:(CGRect)rect {
    [self makeViewWithRect:rect];
}
-(void)setDefaults {
    self.theme = [NSArray arrayWithArray:[NNColorThemes nnLamplight]];
}
-(void)makeViewWithRect:(CGRect)rect {
    [self loadSelections];
    [self initPopView];
    [self addColorsTo:rect];
//    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapThemeView:)];
    [self addGestureRecognizer:tap];
}
//-(void)orientationChanged:(NSNotificationCenter*)note {
//    [self setNeedsDisplay];
//}
-(void)initPopView {
    self.popVisible = NO;
    self.popView = [[NNPopUpTable alloc] init];
    self.popView.selections = self.selections;
    __weak typeof(self) weakSelf = self;
    self.popView.selectedHandle = ^(NSInteger selectedIndex){
        //NSLog(@"selected index %ld, content is %@", selectedIndex, weakSelf.themes[selectedIndex]);

        SEL selector = NSSelectorFromString(weakSelf.themes[selectedIndex]);
        IMP imp = [NNColorThemes methodForSelector:selector];
        NSArray *(*func)(id, SEL) = (void *)imp;
        weakSelf.theme = func([NNColorThemes class], selector);
        float w = weakSelf.popView.tableView.frame.size.width;
        float h = weakSelf.popView.tableView.frame.size.height;
        float x = weakSelf.popView.tableView.frame.origin.x;
        float y = weakSelf.popView.tableView.frame.origin.y;
        
//        if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait | [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {
//            w = weakSelf.popView.tableView.frame.size.width;
//            h = weakSelf.popView.tableView.frame.size.height;
//        } else {
//            h = weakSelf.popView.tableView.frame.size.width;
//            w = weakSelf.popView.tableView.frame.size.height;
//        }

        y = y+(h*.95);
        h = h-(h*.05);
        float c  = weakSelf.theme.count-1;
        for (int i=0; i<c; i++) {
            UIView *v = [[UIView alloc] initWithFrame:CGRectMake(x+((w/c)*i), y, w/c, h)];
            v.backgroundColor = weakSelf.theme[i+1];
            v.userInteractionEnabled = NO;
            [weakSelf.popView addSubview:v];
            //[weakSelf.popView insertSubview:v belowSubview:weakSelf.popView.tableView];
        }
    };
}
-(void)addColorsTo:(CGRect)rect {
    float x = rect.origin.x;
    float y = rect.origin.y;
    float w = rect.size.width;
    float h = rect.size.height;
    float c  = self.theme.count-1;
    
//    if ([[UIDevice currentDevice] orientation] == UIDeviceOrientationPortrait | [[UIDevice currentDevice] orientation] == UIDeviceOrientationPortraitUpsideDown) {
//        w = rect.size.width;
//        h = rect.size.height;
//    } else {
//        h = rect.size.width;
//        w = rect.size.height;
//    }
    
    for (int i=0; i<c; i++) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(x+((w/c)*i), y, w/c, h)];
        v.backgroundColor = self.theme[i+1];
        v.tag = i;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panSubViews:)];
        [v addGestureRecognizer:pan];
        [self addSubview:v];
    }
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(x, y, 0, 0)];
    self.label.font = [UIFont fontWithName:@"Georgia" size:self.frame.size.width/40];
    self.s0 = [NSString stringWithFormat:@"%@",[UIColor colorToWeb:self.theme[1]]];
    self.s1 = [NSString stringWithFormat:@"%@",[UIColor colorToWeb:self.theme[2]]];
    self.s2 = [NSString stringWithFormat:@"%@",[UIColor colorToWeb:self.theme[3]]];
    self.s3 = [NSString stringWithFormat:@"%@",[UIColor colorToWeb:self.theme[4]]];
    self.s4 = [NSString stringWithFormat:@"%@",[UIColor colorToWeb:self.theme[5]]];
    self.c0 = self.theme[1];
    self.c1 = self.theme[2];
    self.c2 = self.theme[3];
    self.c3 = self.theme[4];
    self.c4 = self.theme[5];
    NSString *text = [NSString stringWithFormat:@"%@: %@ | %@ | %@ | %@ | %@",self.theme[0],self.s0,self.s1,self.s2,self.s3,self.s4];
    self.label.text = text;
    self.label.backgroundColor = [UIColor whiteColor];
    [self.label sizeToFit];
    self.label.frame = CGRectMake(x, self.frame.size.height-self.label.frame.size.height*1, self.frame.size.width, self.label.frame.size.height);
    self.label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.label];
    [self sizeToFit];
}
-(void)panSubViews:(UIPanGestureRecognizer *)sender {
    float y = [sender locationInView:sender.view].y;
    float p = (y/sender.view.frame.size.height)*5;
    UIColor *c = [sender.view.backgroundColor jitterWithPercent:p];
    
    switch (sender.view.tag) {
        case 0:
            self.s0 = [UIColor colorToWeb:c];
            self.c0 = c;
            break;
        case 1:
            self.s1 = [UIColor colorToWeb:c];
            self.c1 = c;
            break;
        case 2:
            self.s2 = [UIColor colorToWeb:c];
            self.c2 = c;
            break;
        case 3:
            self.s3 = [UIColor colorToWeb:c];
            self.c3 = c;
            break;
        case 4:
            self.s4 = [UIColor colorToWeb:c];
            self.c4 = c;
            break;
        default:
            break;
    }
    NSArray *a = @[self.theme[0],self.c0,self.c1,self.c2,self.c3,self.c4];
    self.theme = a;
    
    NSString *text = [NSString stringWithFormat:@"%@: %@ | %@ | %@ | %@ | %@", self.theme[0],self.s0,self.s1,self.s2,self.s3,self.s4];
    self.label.text = text;
    [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1.6];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        sender.view.backgroundColor = c;
    [UIView commitAnimations];
    
    //NSLog(@"%lu: %f",sender.view.tag,p);
}
-(void)tapThemeView:(UITapGestureRecognizer *)sender {
    CGPoint p = [sender locationInView:self];
    if (self.popVisible == YES && CGRectContainsPoint(self.popView.frame, p)) {
        float y = [sender locationInView:self.popView.tableView].y;
        y = roundf(y/33);
        y = MIN(y, self.themes.count-1);
        NSIndexPath *index = [NSIndexPath indexPathForRow:y inSection:0];
        [self.popView.tableView.delegate tableView:self.popView.tableView didSelectRowAtIndexPath:index];
        //NSLog(@"%@",self.theme);
    } else {
        if (self.popVisible == YES) {
            [self.popView hide:YES];
            self.popVisible = NO;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [NSThread sleepForTimeInterval:0.2];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self setNeedsDisplay];
                    [self sendActionsForControlEvents:UIControlEventValueChanged];
                });
            });
        } else {
            [self.popView showFromView:self atPoint:p animated:YES];
            self.popVisible = YES;
        }
    }
}
-(void)loadSelections {
        self.themes = @[
                        @"nnLamplight",
                        @"nnGirlByTheWindow",
                        @"nnTheGirlInRed",
                        
                        /*https://color.adobe.com/explore/*/
                        @"nnSandyStoneBeachOceanDiver",
                        @"nnFirenze",
                        @"nnPhaedra",
                        
                        /*http://www.dtelepathy.com/blog/inspiration/24-flat-designs-with-compelling-color-palettes*/
                        @"nnBananaCafe",
                        @"nnCarbonCrayon",
                        @"nnTheSelfieRevolution",
                        @"nnHydrosys",
                        @"nnSvkariburnu",
                        @"nnVVI",
                        @"nnMySuccess",
                        @"nnGimmiiMagazine",
                        @"nnBlogIn",
                        @"nnReadymag",
                        @"nnPresentPlus",
                        @"nnTemper",
                        @"nnAdSempre",
                        @"nnConnectMania",
                        @"nnBarCamp2013",
                        @"nnFullEnglish",
                        @"nnKarlyn",
                        @"nnUsertify",
                        @"nnAlchemy",
                        @"nnKarrieGurnow",
                        @"nnGrausArquitecturaTecnica",
                        @"nnAgenceUzik",
                        @"nnGratisography",
                        @"nnBellsDesign",
                        
                        /*http://www.dtelepathy.com/blog/inspiration/beautiful-color-palettes-for-your-next-web-project*/
                        @"nnGiantGoldfish",
                        @"nnCampfire",
                        @"nnAlladin",
                        @"nnChromeSports",
                        @"nnPapuaNewGuinea",
                        @"nnBarniDesign",
                        @"nnInstapuzzle",
                        @"nnOurLittleProjects",
                        @"nnStateOfTheOwner",
                        @"nnSoftwareMill",
                        @"nnIGaranti",
                        @"nnVintageRomantic",
                        @"nnNicholasJacksonDesign",
                        @"nn1920Leyendecker",
                        @"nnWerkPress",
                        @"nnSilmoParis",
                        @"nnDarkSunset",
                        @"nnTheColorOfTraffic",
                        @"nnMandLoys",
                        @"nnSaBarcaDeFormentera",
                        @"nnContad",
                        @"nnMagme",
                        @"nnEnterpriseFoundation",
                        @"nnRSCollab",
                        @"nnMohiuddinParekh",
                        @"nnBoyCoy",
                        @"nnDrupalCon",
                        @"nnWindowsOfNewYork",
                        @"nnLorenzoVerzini",
                        @"nnRaspberryTheme",
                        @"nnPawStudio",
                        @"nnVisuallyColumbia",
                        @"nnAndaz",
                        @"nnSecretKey",
                        @"nnFIG",
                        @"nnViximo",
                        @"nnOsaki",
                        @"nnKashi",
                        @"nnBassenettes",
                        @"nnAdamHartwig",
                        @"nnAlexandraKubanWebDesign",
                        @"nnGravual",
                        @"nnScottMcCarthyDesign",
                        @"nnMadeTogether",
                        @"nnAestheticInvention",
                        @"nnLRXD",
                        @"nnEnso",
                        @"nnElDesigno"
                        ];
    
    self.selections = @[
                        @"Lamplight",
                        @"Girl by the Window",
                        @"The Girl in Red",
                        
                        /*https://color.adobe.com/explore/*/
                        @"Sandy Stone Beach Ocean Diver",
                        @"Firenze",
                        @"Phaedra",
                        
                        /*http://www.dtelepathy.com/blog/inspiration/24-flat-designs-with-compelling-color-palettes*/
                        @"Banana Cafe",
                        @"Carbon Canyon",
                        @"The Selfie Revolution",
                        @"Hydrosys",
                        @"svkariburnu",
                        @"VVI",
                        @"My Success",
                        @"Gimmii Magazine",
                        @"Blog In",
                        @"Readymag",
                        @"Present Plus",
                        @"Temper",
                        @"Ad Sempre",
                        @"Connect Mania",
                        @"Bar Camp 2013",
                        @"Full English",
                        @"Karlyn",
                        @"Usertify",
                        @"Alchemy",
                        @"Karrie Gurnow",
                        @"Graus Arquitectura Tecnica",
                        @"Agence Uzik",
                        @"Gratisography",
                        @"Bells Design",
                        
                        /*http://www.dtelepathy.com/blog/inspiration/beautiful-color-palettes-for-your-next-web-project*/
                        @"Giant Goldfish",
                        @"Campfire",
                        @"Alladin",
                        @"Chrome Sports",
                        @"Papua New Guinea",
                        @"Barni Design",
                        @"Instapuzzle",
                        @"Our Little Projects",
                        @"State of the Owner",
                        @"Software Mill",
                        @"iGaranti",
                        @"Vintage Romantic",
                        @"Nicholas Jackson Design",
                        @"1920 Leyendecker",
                        @"Werk Press",
                        @"Silmo Paris",
                        @"Dark Sunset",
                        @"The Color of Traffic",
                        @"Mand Loys",
                        @"Sa Barca de Formentera",
                        @"Contad",
                        @"Magme",
                        @"Enterprise Foundation",
                        @"RS Collab",
                        @"Mohiuddin Parekh",
                        @"Boy Coy",
                        @"Drupal Con",
                        @"Windows of New York",
                        @"Lorenzo Verzini",
                        @"Raspberry Theme",
                        @"Paw Studio",
                        @"Visually Columbia",
                        @"Andaz",
                        @"Secret Key",
                        @"FIG",
                        @"Viximo",
                        @"Osaki",
                        @"Kashi",
                        @"Bassenettes",
                        @"Adam Hartwig",
                        @"Alexandra Kuban Web Design",
                        @"Gravual",
                        @"Scott McCarthy Design",
                        @"Made Together",
                        @"Aesthetic Invention",
                        @"LRXD",
                        @"Enso",
                        @"El Designo"
                        ];
}


@end
