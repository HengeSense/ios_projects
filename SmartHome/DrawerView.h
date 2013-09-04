//
//  DrawerView.h
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawerNavigationItem.h"

@protocol DrawerNavigationItemChangedDelegate <NSObject>

- (void)drawerNavigationItemChanged:(DrawerNavigationItem *)item isFirstTime:(BOOL)isFirst;

@end
@protocol AccountInfoDelegate <NSObject>

-(void) toModifyAccountInfo;

@end
@interface DrawerView : UIView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) id<DrawerNavigationItemChangedDelegate> drawerNavigationItemChangedDelegate;
@property (nonatomic,assign) id<AccountInfoDelegate> accountInfoDelegate;
- (id)initWithFrame:(CGRect)frame andItems:(NSArray *)items;

@end
