//
//  NNPopUpTable.m
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


/*
Extended from: SGPopSelectView

The MIT License (MIT)

Copyright (c) 2014 Sagi

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


#import "NNPopUpTable.h"

#define DEFAULT_FONT_SIZE     14
#define DEFAULT_ROW_HEIHGT    33
#define DEFAULT_MAX_HEIGHT    200

@interface NNPopUpTable () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) NSInteger selectedIndex;
@end

@implementation NNPopUpTable

- (instancetype)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _selectedIndex = NSNotFound;
        
        self.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.95];
        self.layer.borderColor = [UIColor grayColor].CGColor;
        self.layer.borderWidth = 4;
        self.layer.cornerRadius = 60;
        self.layer.masksToBounds = YES;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.backgroundView = nil;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self addSubview:_tableView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect frame = CGRectMake(self.bounds.origin.x,self.bounds.origin.y,self.bounds.size.width,self.bounds.size.height-33);
    self.tableView.frame = frame;
//    self.layer.shadowColor = [UIColor blackColor].CGColor;
//    self.layer.shadowOffset = CGSizeMake(5, 5);
//    self.layer.shadowRadius = 10;
//    self.layer.shadowOpacity = 0.4;
//    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

- (void)setSelectedHandle:(PopViewSelectedHandle)handle
{
    _selectedHandle = handle;
}

- (void)showFromView:(UIView *)view atPoint:(CGPoint)point animated:(BOOL)animated
{
    if (self.visible) {
        [self removeFromSuperview];
    }
    [view addSubview:self];
    [self _setupFrameWithSuperView:view atPoint:point];
    [self _showFromView:view animated:animated];
}

- (void)hide:(BOOL)animated
{
    [self _hideWithAnimated:animated];
}

- (BOOL)visible
{
    if (self.superview) {
        return YES;
    }
    return NO;
}

- (void)setSelections:(NSArray *)selections
{
    _selections = selections;
    _selectedIndex = NSNotFound;
    [_tableView reloadData];
}

#pragma mark - Private Methods

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

- (void)_showFromView:(UIView *)view animated:(BOOL)animated
{
    if (animated) {
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [self.tableView flashScrollIndicators];
        }];
        [self.layer addAnimation:_showAnimation() forKey:nil];
        [CATransaction commit];
    }
    self.layer.opacity = 1;
}

- (void)_hideWithAnimated:(BOOL)animated
{
    if (animated) {
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            [self.layer removeAnimationForKey:@"opacity"];
            [self.layer removeAnimationForKey:@"transform"];
            [self removeFromSuperview];
        }];
        [self.layer addAnimation:_hideAnimation() forKey:nil];
        [CATransaction commit];
    }else {
        [self removeFromSuperview];
    }
    self.layer.opacity = 0;
}

- (void)_setupFrameWithSuperView:(UIView *)view atPoint:(CGPoint)point
{
    CGFloat totalHeight = _selections.count * DEFAULT_ROW_HEIHGT;
    CGFloat height = totalHeight > DEFAULT_MAX_HEIGHT ? DEFAULT_MAX_HEIGHT : totalHeight;
    CGFloat width = [self _preferedWidth];
    width = width > view.bounds.size.width * 0.9 ? view.bounds.size.width * 0.9 : width;
    
    CGFloat offsetX = ((point.x / view.bounds.size.width) - floor(point.x / view.bounds.size.width)) * view.bounds.size.width;
    CGFloat offsetY = ((point.y / view.bounds.size.height) - floor(point.y / view.bounds.size.height)) * view.bounds.size.height;
    
    CGFloat left = (offsetX + width) > view.bounds.size.width ? (point.x - offsetX + view.bounds.size.width - width - 10) : point.x;
    CGFloat y = point.y - height / 2;
    if (point.y - height / 2 < 20) {
        y = 20;
    }else if (offsetY + height / 2 > view.bounds.size.height - 10) {
        y = point.y - offsetY + view.bounds.size.height - height - 10;
    }
    self.frame = CGRectMake(left, y, width, height);
}

- (CGFloat)_preferedWidth
{
    NSPredicate *maxLength = [NSPredicate predicateWithFormat:@"SELF.length == %@.@max.length", _selections];
    NSString *maxString = [_selections filteredArrayUsingPredicate:maxLength][0];
    CGFloat strWidth;
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        strWidth = [maxString sizeWithAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Georgia" size:DEFAULT_FONT_SIZE]}].width;
    }else {
        strWidth = [maxString sizeWithFont:[UIFont fontWithName:@"Georgia" size:DEFAULT_FONT_SIZE]].width;
    }
    return strWidth + 15 * 2 + 30;
}

#pragma mark - UITableview DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _selections.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"SelectionCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = nil;
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"Georgia" size:DEFAULT_FONT_SIZE];
        cell.textLabel.textColor = [UIColor darkTextColor];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    if (_selectedIndex == indexPath.row) {
        //cell.textLabel.textColor = [UIColor cyanColor];
        //cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected"]];
    }else {
        //cell.textLabel.textColor = [UIColor darkTextColor];
        //cell.accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"notselected"]];
    }
    cell.textLabel.text = _selections[indexPath.row];
    return cell;
}

#pragma mark - UITableview Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return DEFAULT_ROW_HEIHGT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedIndex = indexPath.row;
    [tableView reloadData];
    [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    if (_selectedHandle) {
        _selectedHandle(indexPath.row);
    }
}

@end
