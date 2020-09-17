//
//  NNColorThemes.h
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
#import "UIColor+NNColors.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                                                 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                                                  blue:((float)(rgbValue & 0xFF))/255.0 \
                                                alpha:1.0]

@interface NNColorThemes : NSObject

+(NSArray *)nnLamplight;
+(NSArray *)nnGirlByTheWindow;
+(NSArray *)nnTheGirlInRed;


/*https://color.adobe.com/explore/*/
+(NSArray *)nnSandyStoneBeachOceanDiver;
+(NSArray *)nnFirenze;
+(NSArray *)nnPhaedra;

/*http://www.dtelepathy.com/blog/inspiration/24-flat-designs-with-compelling-color-palettes*/
+(NSArray *)nnBananaCafe;
+(NSArray *)nnCarbonCrayon;
+(NSArray *)nnTheSelfieRevolution;
+(NSArray *)nnHydrosys;
+(NSArray *)nnSvkariburnu;
+(NSArray *)nnVVI;
+(NSArray *)nnMySuccess;
+(NSArray *)nnGimmiiMagazine;
+(NSArray *)nnBlogIn;
+(NSArray *)nnReadymag;
+(NSArray *)nnPresentPlus;
+(NSArray *)nnTemper;
+(NSArray *)nnAdSempre;
+(NSArray *)nnConnectMania;
+(NSArray *)nnBarCamp2013;
+(NSArray *)nnFullEnglish;
+(NSArray *)nnKarlyn;
+(NSArray *)nnUsertify;
+(NSArray *)nnAlchemy;
+(NSArray *)nnKarrieGurnow;
+(NSArray *)nnGrausArquitecturaTecnica;
+(NSArray *)nnAgenceUzik;
+(NSArray *)nnGratisography;
+(NSArray *)nnBellsDesign;

/*http://www.dtelepathy.com/blog/inspiration/beautiful-color-palettes-for-your-next-web-project*/
+(NSArray *)nnGiantGoldfish;
+(NSArray *)nnCampfire;
+(NSArray *)nnAlladin;
+(NSArray *)nnChromeSports;
+(NSArray *)nnPapuaNewGuinea;
+(NSArray *)nnBarniDesign;
+(NSArray *)nnInstapuzzle;
+(NSArray *)nnOurLittleProjects;
+(NSArray *)nnStateOfTheOwner;
+(NSArray *)nnSoftwareMill;
+(NSArray *)nnIGaranti;
+(NSArray *)nnVintageRomantic;
+(NSArray *)nnNicholasJacksonDesign;
+(NSArray *)nn1920Leyendecker;
+(NSArray *)nnWerkPress;
+(NSArray *)nnSilmoParis;
+(NSArray *)nnDarkSunset;
+(NSArray *)nnTheColorOfTraffic;
+(NSArray *)nnMandLoys;
+(NSArray *)nnSaBarcaDeFormentera;
+(NSArray *)nnContad;
+(NSArray *)nnMagme;
+(NSArray *)nnEnterpriseFoundation;
+(NSArray *)nnRSCollab;
+(NSArray *)nnMohiuddinParekh;
+(NSArray *)nnBoyCoy;
+(NSArray *)nnDrupalCon;
+(NSArray *)nnWindowsOfNewYork;
+(NSArray *)nnLorenzoVerzini;
+(NSArray *)nnRaspberryTheme;
+(NSArray *)nnPawStudio;
+(NSArray *)nnVisuallyColumbia;
+(NSArray *)nnAndaz;
+(NSArray *)nnSecretKey;
+(NSArray *)nnFIG;
+(NSArray *)nnViximo;
+(NSArray *)nnOsaki;
+(NSArray *)nnKashi;
+(NSArray *)nnBassenettes;
+(NSArray *)nnAdamHartwig;
+(NSArray *)nnAlexandraKubanWebDesign;
+(NSArray *)nnGravual;
+(NSArray *)nnScottMcCarthyDesign;
+(NSArray *)nnMadeTogether;
+(NSArray *)nnAestheticInvention;
+(NSArray *)nnLRXD;
+(NSArray *)nnEnso;
+(NSArray *)nnElDesigno;

@end
