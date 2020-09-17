//
//  nnAudioConverter.h
//
//  Created by Cady Holmes on 9/1/15.
//  Copyright © 2015-present Cady Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@protocol nnAudioConverterDelegate;
@interface nnAudioConverter : UIView

//@property (nonatomic, strong) UIButton *button;
@property (nonatomic, weak) id<nnAudioConverterDelegate> delegate;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) NSString *urlString;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic) float percentFinished;

- (id)initWithFontSize:(CGFloat)size andOrigin:(CGPoint)origin andID:(int)ID;
+ (nnAudioConverter *)initWithID:(int)ID;
- (void)convertToWavFromFilePath:(NSURL *)url;
- (void)convertToWavFromFilePathInBackground:(NSURL *)assetURL;

@end

@protocol nnAudioConverterDelegate <NSObject>
- (void)audioConverterDidStart:(nnAudioConverter *)converter;
- (void)audioConverterDidFinish:(nnAudioConverter *)converter;
- (void)loadPercentageUpdated:(float)percent;
@end
