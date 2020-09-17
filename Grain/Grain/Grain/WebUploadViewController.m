//
//  WebUploadViewController.m
//
//  Created by Cady Holmes on 9/15/15.
//  Copyright © 2015-present. All rights reserved.
//

#import "WebUploadViewController.h"
#import "GCDWebUploader.h"
#import "nnKit.h"
#import "UIColor+NNColors.h"

@interface WebUploadViewController () {
    GCDWebUploader* _webUploader;
    UILabel *ipLabel;
}

@end

@implementation WebUploadViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidAppear:(BOOL)animated {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        _webUploader = [[GCDWebUploader alloc] initWithUploadDirectory:documentsPath];
        [_webUploader start];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
            ipLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", _webUploader.serverURL]
                                                                     attributes:underlineAttribute];
        });
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

    //[self.view setBackgroundColor:[UIColor flatWhiteColor]];
    UIColor *textColor = UIColorFromHex(0xFEFEFE);
    UIColor *backgroundColor = UIColorFromHex(0x87766C);
    //UIColor *backgroundColor = UIColorFromHex(0x8CBEB2);
    [self.view setBackgroundColor:backgroundColor];
    
    float height;
    float smallHeight;
    
    if ([nnKit isIPad]) {
        height = 80;
        smallHeight = 50;
    } else {
        if ([nnKit isIPhone5orIPodTouch]) {
            height = 40;
        } else {
            height = 44;
        }
        smallHeight = 24;
    }
    
    float fontSize1;
    float fontSize2;
    float fontSize3;
    float fontSize4;
    
    if ([nnKit isIPad]) {
        fontSize1 = SW()/14;
        fontSize2 = SW()/16;
        fontSize3 = SW()/18;
        fontSize4 = SW()/20;
    } else {
        fontSize1 = SW()/11;
        fontSize2 = SW()/12;
        fontSize3 = SW()/14;
        fontSize4 = SW()/16;
    }

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                               height,
                                                               self.view.frame.size.width,
                                                               height)];
    
    [label setCenter:CGPointMake(self.view.frame.size.width/2, label.center.y)];
    [label setTextAlignment:NSTextAlignmentCenter];
    [label setTextColor:textColor];
    [label setFont:[UIFont fontWithName:nnKitGlobalFont size:fontSize1]];
    
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    label.attributedText = [[NSAttributedString alloc] initWithString:@"Upload files to Grain"
                                                             attributes:underlineAttribute];
    
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                (height*1.8),
                                                                self.view.frame.size.width,
                                                                height)];
    
    [label1 setCenter:CGPointMake(self.view.frame.size.width/2, label1.center.y)];
    [label1 setTextAlignment:NSTextAlignmentCenter];
    [label1 setTextColor:textColor];
    [label1 setFont:[UIFont fontWithName:nnKitGlobalFont size:fontSize3]];
    label1.attributedText = [[NSAttributedString alloc] initWithString:@"using a desktop browser"
                                                           attributes:underlineAttribute];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0,
                                                                        (height*3),
                                                                        self.view.frame.size.width,
                                                                        self.view.frame.size.height/2)];
    
    [textView setCenter:CGPointMake(self.view.frame.size.width/2, textView.center.y)];
    [textView setBackgroundColor:[UIColor clearColor]];
    [textView setTextAlignment:NSTextAlignmentCenter];
    [textView setTextColor:textColor];
    [textView setFont:[UIFont fontWithName:nnKitGlobalFont size:fontSize4]];
    [textView setText:[NSString stringWithFormat:@"Although this tool will let you upload any file type, Grain will only recognize .wav audio files.\nAlso, please ensure the extension .wav is included in the file name.\n\nConnect your mobile device and computer to the same WiFi network, and keep Grain open to this page in order to upload files."]];
    
    
    UILabel *label2 = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                (self.view.frame.size.height-(height*4.5)),
                                                                self.view.frame.size.width,
                                                                smallHeight)];
    
    [label2 setCenter:CGPointMake(self.view.frame.size.width/2, label2.center.y)];
    [label2 setTextAlignment:NSTextAlignmentCenter];
    [label2 setTextColor:textColor];
    [label2 setFont:[UIFont fontWithName:nnKitGlobalFont size:fontSize1]];
    [label2 setText:[NSString stringWithFormat:@"Visit this address"]];
    
    UILabel *label3 = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                (self.view.frame.size.height-(height*3.7)),
                                                                self.view.frame.size.width,
                                                                smallHeight)];
    
    [label3 setCenter:CGPointMake(self.view.frame.size.width/2, label3.center.y)];
    [label3 setTextAlignment:NSTextAlignmentCenter];
    [label3 setTextColor:textColor];
    [label3 setFont:[UIFont fontWithName:nnKitGlobalFont size:fontSize3]];
    [label3 setText:[NSString stringWithFormat:@"in your desktop browser:"]];
    
    ipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                (self.view.frame.size.height-(height*3.1)),
                                                                self.view.frame.size.width,
                                                                height)];
    
    [ipLabel setCenter:CGPointMake(self.view.frame.size.width/2, ipLabel.center.y)];
    [ipLabel setTextAlignment:NSTextAlignmentCenter];
    [ipLabel setTextColor:textColor];
    [ipLabel setFont:[UIFont fontWithName:nnKitGlobalFont size:fontSize2]];
    
    UIButton *button = [nnKit makeButtonWithImage:[UIImage imageNamed:@"back.pdf"] frame:CGRectMake(0, self.view.frame.size.height-75, 60, 60) method:@"goBack:" fromClass:self];
    [button setCenter:CGPointMake(self.view.frame.size.width/2, button.center.y)];

    [self.view addSubview:label];
    [self.view addSubview:label1];
    [self.view addSubview:textView];
    [self.view addSubview:label2];
    [self.view addSubview:label3];
    [self.view addSubview:ipLabel];
    [self.view addSubview:button];
}

- (void)goBack:(UIButton*)button {
    [nnKit animateViewBigJiggleAlt:button];
    [self dismissViewControllerAnimated:YES completion:^(){
        [_webUploader stop];
        _webUploader = nil;
        ipLabel = nil;
    }];
}

@end
