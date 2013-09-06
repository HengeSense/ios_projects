//
//  SelectionView.m
//  SmartHome
//
//  Created by Zhao yang on 9/6/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "SelectionView.h"
#import "LongButton.h"
#import "UIColor+ExtentionForHexString.h"

#define LOCK_VIEW_TAG 3001

@implementation SelectionView {
    UIButton *btnCancel;
    UITableView *tblItems;
    BOOL dismissing;
}

@synthesize items = _items_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    if(tblItems == nil) {
        tblItems = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height - 49 - 6 - 10)];
        tblItems.backgroundColor = [UIColor clearColor];
        tblItems.separatorStyle = UITableViewCellSeparatorStyleNone;
        tblItems.scrollEnabled = NO;
        tblItems.dataSource = self;
        tblItems.delegate = self;
        [self addSubview:tblItems];
    }
    
    if(btnCancel == nil) {
        btnCancel = [LongButton darkButtonWithPoint:CGPointMake(0, self.bounds.size.height - 49 - 6)];
        btnCancel.center = CGPointMake(self.center.x, btnCancel.center.y);
        [btnCancel addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnCancel];
    }
    
    self.backgroundColor = [UIColor colorWithHexString:@"222226"];
}

+ (void)showWithItems:(NSArray *)items selectedIndex:(NSInteger)index delegate:(id)target {
    CGFloat height = 5 * 45 + 49 + 6 + 10 + 30;
    
    UIView *lockView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    lockView.backgroundColor = [UIColor blackColor];
    lockView.alpha = 0.3f;
    lockView.tag = LOCK_VIEW_TAG;
    [[UIApplication sharedApplication].keyWindow addSubview:lockView];
    
    SelectionView *selectionView = [[SelectionView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, height)];
    [[UIApplication sharedApplication].keyWindow addSubview:selectionView];
    
    [UIView animateWithDuration:0.3f
         animations:^{
             selectionView.center = CGPointMake(selectionView.center.x, selectionView.center.y - height);
         }
         completion:^(BOOL finished) {
             UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:selectionView action:@selector(dismiss)];
             [lockView addGestureRecognizer:tapGesture];
         }];
}

- (void)dismiss {
    if(dismissing) return;
    dismissing = YES;
    [UIView animateWithDuration:0.3f
            animations:^{
                self.center = CGPointMake(self.center.x, self.center.y + self.bounds.size.height);
            }
            completion:^(BOOL finished) {
                UIView *lockView = [[UIApplication sharedApplication].keyWindow viewWithTag:LOCK_VIEW_TAG];
                if(lockView != nil) {
                    [lockView removeFromSuperview];
                }
                [self removeFromSuperview];
                dismissing = NO;
            }];
}
    
#pragma mark -
#pragma makr table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45.f;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
    if(self.items == nil || self.items.count == 0) return 0;
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"29292c"];
        
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 6, 300, 30)];
        lblTitle.font = [UIFont systemFontOfSize:17.f];
        lblTitle.backgroundColor = [UIColor clearColor];
        [cell addSubview:lblTitle];
        
        UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.bounds.size.height, cell.bounds.size.width, 2)];
        lineImageView.image = [UIImage imageNamed:@"line_cell_selection_view.png"];
        [cell addSubview:lineImageView];
        
        lblTitle.text = @"haha";
        lblTitle.textColor = [UIColor whiteColor];
    }
    return cell;
}

@end
