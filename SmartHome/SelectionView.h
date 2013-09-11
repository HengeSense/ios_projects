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

- (void)selectionViewNotifyItemSelected:(id)item from:(NSString *)source;

@end

@interface SelectionView : UIView<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSArray *items;
@property (strong, nonatomic) NSString *source;
@property (strong, nonatomic) NSString *selectedIdentifier;
@property (assign, nonatomic) id<SelectionViewDelegate> delegate;

+ (void)showWithItems:(NSArray *)items selectedIdentifier:(NSString *)identifier source:(NSString *)source delegate:(id)target;

@end
