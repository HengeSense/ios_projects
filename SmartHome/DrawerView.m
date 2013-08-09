//
//  DrawerView.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DrawerView.h"
#import "DrawerNavItemCell.h"
#import "DrawerNavigationItem.h"
#import "ViewsPool.h"

@implementation DrawerView {
    UITableView *tblNavigationItems;
    NSArray *navigationItems;
    ViewsPool *viewsPool;
    CGFloat entryHeight;
    BOOL isChanging;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefaults];
        [self initUI];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andItems:(NSArray *)items {
    navigationItems = items;
    return [self initWithFrame:frame];
}

- (void)initDefaults {
    entryHeight = ([UIScreen mainScreen].bounds.size.height - 20) / 4;
}

- (void)initUI {
    if(tblNavigationItems == nil) {
        tblNavigationItems = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
        tblNavigationItems.dataSource = self;
        tblNavigationItems.delegate = self;
        tblNavigationItems.scrollEnabled = NO;
        [self addSubview:tblNavigationItems];
    }
}

#pragma mark -
#pragma mark table view delegate && data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"DrawerNavItemCell";
    DrawerNavItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"DrawerNavItemCell" owner:self options:nil];
        cell = [arr objectAtIndex:0];
        DrawerNavigationItem *item = [navigationItems objectAtIndex:indexPath.row];
        if(item) {
            cell.lblPart.text = item.itemTitle;
        }
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(navigationItems && navigationItems.count > 0) {
        return navigationItems.count;
    }
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(navigationItems) {
        return 1;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return entryHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DrawerNavigationItem *item = [navigationItems objectAtIndex:indexPath.row];
    if(item) {
        if(self.drawerNavigationItemChangedDelegate != nil &&
           [self.drawerNavigationItemChangedDelegate respondsToSelector:@selector(drawerNavigationItemChanged:isFirstTime:)]) {
            [self.drawerNavigationItemChangedDelegate drawerNavigationItemChanged:item isFirstTime:NO];
        }
    }
}

@end
