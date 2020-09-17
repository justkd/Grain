//
//  nnMediaPickerPopUp.h
//
//  Created by Cady Holmes on 9/13/15.
//  Copyright © 2015-present Cady Holmes. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "nnSongPicker.h"

@protocol nnMediaPickerPopUpDelegate;
@interface nnMediaPickerPopUp : UIView <UITableViewDataSource,UITableViewDelegate,nnSongPickerDelegate> {
    UITableView *table;
    NSArray *tableData;
}

@property (nonatomic, weak) id<nnMediaPickerPopUpDelegate> delegate;
@property (nonatomic, strong) nnSongPicker *picker;
//@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *wavURL;

- (void)showFromView:(UIView *)view animated:(BOOL)animated;
- (void)hideWithAnimated:(BOOL)animated;
+ (nnMediaPickerPopUp *)initWithID:(int)ID;

@end


@protocol nnMediaPickerPopUpDelegate <NSObject>
- (void)songPickerDidFinish:(nnMediaPickerPopUp *)popup;
- (void)songPickerDidCancel:(nnMediaPickerPopUp *)popup;
- (void)songPickerShouldStartConverting:(nnMediaPickerPopUp *)popup;
- (void)songPickerDidStartConverting:(nnMediaPickerPopUp *)popup;
- (void)songPickerIsConverting:(nnMediaPickerPopUp *)popup;
- (void)wavFilePicked:(nnMediaPickerPopUp *)popup row:(int)row;
- (void)mediaLibraryPicked:(nnMediaPickerPopUp *)popup;
- (void)popupDidCancel:(nnMediaPickerPopUp *)popup;
- (void)popupDidHide:(nnMediaPickerPopUp *)popup;
@end
