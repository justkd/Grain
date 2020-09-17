//
//  CDSideBarController.m
//  CDSideBar
//
//  Created by Christophe Dellac on 9/11/14.
//  Copyright (c) 2014 Christophe Dellac. All rights reserved.
//

#import "CDSideBarController.h"

#define kDur 0.2f

@implementation CDSideBarController

#pragma mark - 
#pragma mark Init

- (CDSideBarController*)initWithImages:(NSArray*)images andUpperMargin:(int)margin
{
    self.menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.menuButton.frame = CGRectMake(0, 0, 40, 40);
    [self.menuButton setImage:[UIImage imageNamed:@"menuIcon.png"] forState:UIControlStateNormal];
    [self.menuButton addTarget:self action:@selector(showMenu) forControlEvents:UIControlEventTouchUpInside];
    
    self.backgroundMenuView = [[UIView alloc] init];
    _buttonList = [[NSMutableArray alloc] initWithCapacity:images.count];
    
    int index = 0;
    for (UIImage *image in [images copy])
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:image forState:UIControlStateNormal];
        button.frame = CGRectMake(20, margin + (80 * index), 50, 50);
        button.tag = index;
        [button addTarget:self action:@selector(onMenuButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_buttonList addObject:button];
        ++index;
    }
    return self;
}

- (void)insertMenuButtonOnView:(UIView*)view atPosition:(CGPoint)position
{
    self.menuButton.frame = CGRectMake(position.x, position.y, self.menuButton.frame.size.width, self.menuButton.frame.size.height);
    [self.menuButton setAlpha:0];
    [view addSubview:self.menuButton];
    
    [UIView animateWithDuration:0.3
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^
     {
         [self.menuButton setAlpha:1];
         
     } completion:nil];
    
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissMenu)];
    [view addGestureRecognizer:singleTap];

    self.backgroundMenuView.frame = CGRectMake(view.frame.size.width, 0, 90, view.frame.size.height);
    
    //self.backgroundMenuView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:1.0f];
    //self.backgroundMenuView.backgroundColor = [UIColor colorWithRed:25.0/255.0 green:25.0/255.0 blue:25.0/255.0 alpha:.75];
    self.backgroundMenuView.backgroundColor = [UIColor clearColor];
    self.bgToolbar = [[UIToolbar alloc] initWithFrame:self.backgroundMenuView.bounds];
    self.bgToolbar.barStyle = UIBarStyleBlackTranslucent;
    [self.backgroundMenuView addSubview:self.bgToolbar];

    for (UIButton *button in _buttonList)
    {
        [self.backgroundMenuView addSubview:button];
    }
    
    [view addSubview:self.backgroundMenuView];
}

#pragma mark - 
#pragma mark Menu button action

- (void)dismissMenuWithSelection:(UIButton*)button
{
    [UIView animateWithDuration:0.2f
                          delay:0.0f
         usingSpringWithDamping:.2f
          initialSpringVelocity:10.f
                        options:0 animations:^{
                            button.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.2, 1.2);
                        }
                     completion:^(BOOL finished) {
                          [self dismissMenu];
                     }];
}

- (void)dismissMenu
{
    if (self.isOpen)
    {
        self.isOpen = !self.isOpen;
       [self performDismissAnimation];
        
        if ([self.delegate respondsToSelector:@selector(menuClosed)])
            [self.delegate menuClosed];
    }
}

- (void)showMenu
{
    if (!self.isOpen)
    {
        self.isOpen = !self.isOpen;
        [self performSelectorInBackground:@selector(performOpenAnimation) withObject:nil];
        
        if ([self.delegate respondsToSelector:@selector(menuOpened)])
            [self.delegate menuOpened];
    }
}

- (void)onMenuButtonClick:(UIButton*)button
{
    if ([self.delegate respondsToSelector:@selector(menuButtonClicked:)])
        [self.delegate menuButtonClicked:(int)button.tag];
    [self dismissMenuWithSelection:button];
}

#pragma mark -
#pragma mark - Animations

- (void)performDismissAnimation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:kDur animations:^{
            self.menuButton.alpha = 1.0f;
            self.menuButton.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
            self.backgroundMenuView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
        }];
    });
}

- (void)performOpenAnimation
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:kDur animations:^{
            self.menuButton.alpha = 0.0f;
            self.menuButton.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -90, 0);
            self.backgroundMenuView.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, -90, 0);
        }];
    });
    for (UIButton *button in _buttonList)
    {
        //[NSThread sleepForTimeInterval:0.01f];
        dispatch_async(dispatch_get_main_queue(), ^{
            button.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 20, 0);
            [UIView animateWithDuration:0.75f
                                  delay:0.1f
                 usingSpringWithDamping:.5f
                  initialSpringVelocity:1.5f
                                options:UIViewAnimationOptionAllowUserInteraction
                             animations:^{
                                    button.transform = CGAffineTransformTranslate(CGAffineTransformIdentity, 0, 0);
                                }
                             completion:^(BOOL finished) {
                             }];
        });
    }
}

@end

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net
