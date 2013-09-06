//
//  SelectionView.h
//  SmartHome
//
//  Created by Zhao yang on 9/6/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SelectionViewDelegate <NSObject>

- (void)selectionViewNotifyItemSelected:(id)item;

@end

@interface SelectionView : UIView<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *items;


+ (void)showWithItems:(NSArray *)items selectedIndex:(NSInteger)index delegate:(id)target;

@end
