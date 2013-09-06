//
//  SelectionView.h
//  SmartHome
//
//  Created by Zhao yang on 9/6/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectionItem.h"

@protocol SelectionViewDelegate <NSObject>

- (void)selectionViewNotifyItemSelected:(id)item;

@end

@interface SelectionView : UIView<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *items;


+ (void)showWithItems:(NSArray *)items selectedIdentifier:(NSString *)identifier delegate:(id)target;

@end
