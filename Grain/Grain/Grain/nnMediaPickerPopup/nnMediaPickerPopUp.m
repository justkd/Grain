//
//  nnMediaPickerPopUp.m
//
//  Created by Cady Holmes on 9/13/15.
//  Copyright © 2015-present Cady Holmes. All rights reserved.
//

#import "nnMediaPickerPopUp.h"

@implementation nnMediaPickerPopUp

+ (nnMediaPickerPopUp *)initWithID:(int)ID {
    
    nnMediaPickerPopUp *popup = [[nnMediaPickerPopUp alloc] init];
    popup.ID = [NSString stringWithFormat:@"%d",ID];
    popup.layer.masksToBounds = YES;
    popup.picker = [nnSongPicker initWithID:ID];
    popup.picker.delegate = popup;
    
    return popup;
}

- (void)setupUI {
    self.containerView = [[UIView alloc] initWithFrame:self.bounds];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCancel:)];
    [self.containerView  addGestureRecognizer:tap];
    [self addSubview:self.containerView];
    
    UIImage *noteIcon = [UIImage imageNamed:@"note.pdf"];
    UIImage *fileIcon = [UIImage imageNamed:@"file.pdf"];
    UIImage *cancelIcon = [UIImage imageNamed:@"close.pdf"];
   
    UIButton *noteButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [noteButton addTarget:self action:@selector(pickSong:) forControlEvents:UIControlEventTouchUpInside];
    [noteButton setBackgroundImage:noteIcon forState:UIControlStateNormal];
    
    UIButton *fileButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [fileButton addTarget:self action:@selector(pickFile:) forControlEvents:UIControlEventTouchUpInside];
    [fileButton setBackgroundImage:fileIcon forState:UIControlStateNormal];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [cancelButton addTarget:self action:@selector(pickCancel:) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setBackgroundImage:cancelIcon forState:UIControlStateNormal];
    
    float dim = self.frame.size.height*.75;
    
    noteButton.frame = CGRectMake(0, 0, dim, dim);
    noteButton.center = CGPointMake(self.frame.size.width*.18, self.frame.size.height/2);
    
    fileButton.frame = CGRectMake(0, 0, dim, dim);
    fileButton.center = CGPointMake(self.frame.size.width*.5, self.frame.size.height/2);
    
    cancelButton.frame = CGRectMake(0, 0, dim, dim);
    cancelButton.center = CGPointMake(self.frame.size.width*.82, self.frame.size.height/2);
    
    [self.containerView addSubview:noteButton];
    [self.containerView addSubview:fileButton];
    [self.containerView addSubview:cancelButton];
    
    //NSLog(@"setup popup ui");
}

- (void)pickSong:(UIButton*)button {
    [self animateButtonTapped:button];
    id<nnMediaPickerPopUpDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(mediaLibraryPicked:)]) {
        [strongDelegate mediaLibraryPicked:self];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.picker openLibrary];
    });
}

- (void)pickFile:(UIButton*)button {
    [self animateButtonTapped:button];
    dispatch_async(dispatch_get_main_queue(), ^{
        //NSLog(@"make table");
        [self makeTableView]; 
    });
}

- (void)pickCancel:(UIButton*)button {
    [self animateButtonTapped:button];
    [self hideWithAnimated:YES];
    id<nnMediaPickerPopUpDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(popupDidCancel:)]) {
        [strongDelegate popupDidCancel:self];
    }
    //NSLog(@"%@",self.picker.songURL);
}

- (void)tapCancel:(UIGestureRecognizer *)sender {
    [self hideWithAnimated:YES];
    id<nnMediaPickerPopUpDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(popupDidCancel:)]) {
        [strongDelegate popupDidCancel:self];
    }
    //NSLog(@"%@",self.picker.songURL);
}

- (void)songPickerDidFinish:(nnSongPicker *)picker {
    id<nnMediaPickerPopUpDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(songPickerDidFinish:)]) {
        [strongDelegate songPickerDidFinish:self];
    }
    //NSLog(@"picker did finish");
}
- (void)songPickerDidCancel:(nnSongPicker *)picker {
    id<nnMediaPickerPopUpDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(songPickerDidCancel:)]) {
        [strongDelegate songPickerDidCancel:self];
    }
    //NSLog(@"picker did cancel");
}
- (void)songPickerDidStartConverting:(nnSongPicker *)picker {
    id<nnMediaPickerPopUpDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(songPickerDidStartConverting:)]) {
        [strongDelegate songPickerDidStartConverting:self];
    }
    //NSLog(@"picker did start converting");
}
- (void)songPickerShouldStartConverting:(nnSongPicker *)picker {
    id<nnMediaPickerPopUpDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(songPickerShouldStartConverting:)]) {
        [strongDelegate songPickerShouldStartConverting:self];
    }
}
- (void)songPickerIsConverting:(nnSongPicker *)picker {
    id<nnMediaPickerPopUpDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(songPickerIsConverting:)]) {
        [strongDelegate songPickerIsConverting:self];
    }
    //NSLog(@"picker is converting");
}

- (void)makeTableView {
    table = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
    [self getTableData];
    
    table.delegate = self;
    table.dataSource = self;
    
    table.allowsSelectionDuringEditing = YES;
    table.allowsSelection = YES;
    
    table.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
    
    [table setAlpha:0];
    [self addSubview:table];
    
    [UIView animateWithDuration:0.3
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [table setAlpha:1];
                         [self setFrame: CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, [[UIScreen mainScreen] bounds].size.height*.4)];
                         [self setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height/2)];
                         [table setFrame:self.bounds];
                         
                     } completion:^(BOOL finished){
                         if (finished) {
                         }
                     }
     ];
}

- (void)getTableData {
    NSArray *array = [self listDocumentsDirectoryContents];
    array = [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.wav'"]];
    NSMutableArray *arr = [NSMutableArray arrayWithArray:array];
    
    if ([arr containsObject:@"player101.wav"]) {
        [arr removeObject:@"player101.wav"];
    }
    if ([arr containsObject:@"player102.wav"]) {
        [arr removeObject:@"player102.wav"];
    }
    if ([arr containsObject:@"player103.wav"]) {
        [arr removeObject:@"player103.wav"];
    }
    
    NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
    NSError * error;
    NSArray * array2 = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:resourcePath error:&error];
    array2 = [array2 filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self ENDSWITH '.wav'"]];
    
    [arr addObjectsFromArray:array2];
    tableData = [NSArray arrayWithArray:arr];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)theTableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)theTableView numberOfRowsInSection:(NSInteger)section
{
    int rows = (int)[tableData count];
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell.textLabel setText:[tableData objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)theTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *component = [tableData objectAtIndex:indexPath.row];
    NSArray *array = [tableData filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"self BEGINSWITH 'GRAIN__'"]];
    if ([array containsObject:component]) {
        component = [[NSBundle mainBundle] pathForResource:component ofType:nil];
    } else {
        NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        component = [documentsPath stringByAppendingPathComponent:component];
    }
    self.wavURL = component;
    
    id<nnMediaPickerPopUpDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(wavFilePicked:row:)]) {
        [strongDelegate wavFilePicked:self row:(int)indexPath.row];
    }
    
    [table removeFromSuperview];
    table = nil;
    [self hideWithAnimated:YES];
}

-(NSArray *)listDocumentsDirectoryContents
{
    NSString* path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    return directoryContent;
}

- (void)showFromView:(UIView *)view animated:(BOOL)animated
{
    self.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width*.95, [[UIScreen mainScreen] bounds].size.height*.2);
    self.center = CGPointMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height/2);
    self.backgroundColor = [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1];
    self.layer.cornerRadius = 12;
    
    [self setupUI];
    
    if (animated) {
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{

        }];
        [self.layer addAnimation:_showAnimation() forKey:nil];
        [CATransaction commit];
    }
    self.layer.opacity = 1;
}

- (void)hideWithAnimated:(BOOL)animated
{
    if (animated) {
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [self.layer removeAnimationForKey:@"opacity"];
            [self.layer removeAnimationForKey:@"transform"];
            [self removeFromSuperview];
            if (table) {
                [table removeFromSuperview];
            }
        }];
        [self.layer addAnimation:_hideAnimation() forKey:nil];
        [CATransaction commit];
    }else {
        [self removeFromSuperview];
    }
    self.layer.opacity = 0;
    
    id<nnMediaPickerPopUpDelegate> strongDelegate = self.delegate;
    if ([strongDelegate respondsToSelector:@selector(popupDidHide:)]) {
        [strongDelegate popupDidHide:self];
    }
}

- (void)animateButtonTapped:(UIView*)view {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.15f
                              delay:0.0f
             usingSpringWithDamping:.2f
              initialSpringVelocity:10.f
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{
                             view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.05, 1.05);
                         }
                         completion:^(BOOL finished) {
                             [UIView animateWithDuration:0.3f
                                                   delay:0.0f
                                  usingSpringWithDamping:.3f
                                   initialSpringVelocity:10.0f
                                                 options:UIViewAnimationOptionAllowUserInteraction
                                              animations:^{
                                                  view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                                              }
                                              completion:^(BOOL finished) {
                                              }];
                         }];
    });
}

static CAAnimation* _showAnimation()
{
    CAKeyframeAnimation *transform = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    transform.values = values;
    
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [opacity setFromValue:@0.0];
    [opacity setToValue:@1.0];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 0.2;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [group setAnimations:@[transform, opacity]];
    return group;
}

static CAAnimation* _hideAnimation()
{
    CAKeyframeAnimation *transform = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.00, 1.00, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1.0)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1.0)]];
    transform.values = values;
    
    CABasicAnimation *opacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [opacity setFromValue:@1.0];
    [opacity setToValue:@0.0];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.duration = 0.2;
    group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    [group setAnimations:@[transform, opacity]];
    return group;
}

@end
