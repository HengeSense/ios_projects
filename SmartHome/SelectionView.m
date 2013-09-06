//
//  SelectionView.m
//  SmartHome
//
//  Created by Zhao yang on 9/6/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "SelectionView.h"
#import "LongButton.h"

@implementation SelectionView {
    UIButton *btnCancel;
    UITableView *tblItems;
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
    if(btnCancel == nil) {
        btnCancel = [LongButton darkButtonWithPoint:CGPointMake(0, 0)];
        [self addSubview:btnCancel];
    }
}

+ (void)showWithItems:(NSArray *)items selectedIndex:(NSInteger)index delegate:(id)target {
    SelectionView *selectionView = [[SelectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    
    [[UIApplication sharedApplication].keyWindow addSubview:selectionView];
}

- (void)show {
    
    
    
    
    
    
}

@end
