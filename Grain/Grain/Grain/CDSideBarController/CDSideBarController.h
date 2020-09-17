//
//  CDSideBarController.h
//  CDSideBar
//
//  Created by Christophe Dellac on 9/11/14.
//  Copyright (c) 2014 Christophe Dellac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol CDSideBarControllerDelegate <NSObject>

- (void)menuOpened;
- (void)menuClosed;
- (void)menuButtonClicked:(int)index;

@end

@interface CDSideBarController : NSObject
{
    NSMutableArray      *_buttonList;
}

@property (nonatomic) BOOL isOpen;
@property (nonatomic, strong) UIView *backgroundMenuView;
@property (nonatomic, strong) UIButton *menuButton;
@property (nonatomic, strong) UIToolbar *bgToolbar;

@property (nonatomic, retain) id<CDSideBarControllerDelegate> delegate;

- (CDSideBarController*)initWithImages:(NSArray*)buttonList andUpperMargin:(int)margin;
- (void)insertMenuButtonOnView:(UIView*)view atPosition:(CGPoint)position;
- (void)dismissMenu;

@end

// Copyright belongs to original author
// http://code4app.net (en) http://code4app.com (cn)
// From the most professional code share website: Code4App.net
