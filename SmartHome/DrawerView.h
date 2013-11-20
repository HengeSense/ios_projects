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

@interface DrawerView : UIView<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, assign) id<DrawerNavigationItemChangedDelegate> drawerNavigationItemChangedDelegate;
@property (strong, nonatomic) UIViewController *ownerViewController;

- (id)initWithFrame:(CGRect)frame andItems:(NSArray *)items;

- (void)setScreenName:(NSString *)name;

- (void)changeItemToIndexPath:(NSIndexPath *)indexPath;

@end
