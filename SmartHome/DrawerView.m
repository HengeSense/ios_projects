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
#import "UIColor+ExtentionForHexString.h"
#import "UserAccountViewController.h"

#define DRAWER_WIDTH 140

#define ACCOUNT_VIEW_HEIGHT 70
#define LOGO_VIEW_HEIGHT    57/2

@implementation DrawerView {
    UIView *accountView;
    UIImageView *logoView;
    UIImageView *backgroundImageView;
    UITableView *tblNavigationItems;
    NSArray *navigationItems;
    ViewsPool *viewsPool;
    UILabel *lblMessage1;
    CGFloat entryHeight;
    BOOL isChanging;
    NSUInteger checkedRowIndex;
}

@synthesize ownerViewController;

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
    entryHeight = 40;
}

- (void)initUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#3a3e47"];
    
    if(backgroundImageView == nil) {
        backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, DRAWER_WIDTH + 2, self.frame.size.height)];
        backgroundImageView.image = [[UIImage imageNamed:@"bg_drawer_cell.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
        [self addSubview:backgroundImageView];
    }
    
    if(logoView == nil) {
        logoView = [[UIImageView alloc] initWithFrame:CGRectMake(33, [UIDevice systemVersionIsMoreThanOrEuqal7] ? 30 : 10, 148/2, LOGO_VIEW_HEIGHT)];
        logoView.image = [UIImage imageNamed:@"logo3.png"];
        [self addSubview:logoView];
        
        UIImageView *imgSeperatorLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, logoView.frame.origin.y + logoView.bounds.size.height + 15, DRAWER_WIDTH + 10, 2)];
        imgSeperatorLine.image = [UIImage imageNamed:@"line_cell_seperator.png"];
        [self addSubview:imgSeperatorLine];
    }
    
    if(accountView == nil) {
        accountView = [[UIView alloc] initWithFrame:CGRectMake(0, logoView.frame.origin.y + logoView.bounds.size.height + 5, DRAWER_WIDTH + 10, ACCOUNT_VIEW_HEIGHT)];
        lblMessage1 = [[UILabel alloc] initWithFrame:CGRectMake(20, 22, 100, 18)];
        UILabel *lblMessage2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 42, 100, 18)];
        lblMessage1.backgroundColor = [UIColor clearColor];
        lblMessage2.backgroundColor = [UIColor clearColor];
        lblMessage1.font = [UIFont systemFontOfSize:13.f];
        lblMessage2.font = [UIFont systemFontOfSize:11.f];
        lblMessage1.textAlignment = NSTextAlignmentCenter;
        lblMessage2.textAlignment = NSTextAlignmentCenter;
        lblMessage1.textColor = [UIColor colorWithHexString:@"#898e9a"];
        lblMessage2.textColor = [UIColor colorWithHexString:@"#898e9a"];

        [accountView addSubview:lblMessage1];
        [accountView addSubview:lblMessage2];
        UIButton *accountBackground = [[UIButton alloc] initWithFrame:accountView.bounds];
        accountBackground.backgroundColor = [UIColor clearColor];
        [accountBackground addTarget:self action:@selector(showAccountView:) forControlEvents:UIControlEventTouchUpInside];
        [accountView addSubview:accountBackground];
        [self addSubview:accountView];
        
        UIImageView *imgSeperatorLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, accountView.frame.origin.y + accountView.bounds.size.height, DRAWER_WIDTH + 10, 2)];
        imgSeperatorLine.image = [UIImage imageNamed:@"line_cell_seperator.png"];
        [self addSubview:imgSeperatorLine];

        lblMessage1.text = [SMShared current].settings.account;
        lblMessage2.text = NSLocalizedString(@"edit_profile", @"");
    }
    
    if(tblNavigationItems == nil) {
        tblNavigationItems = [[UITableView alloc]
            initWithFrame:CGRectMake(0, ACCOUNT_VIEW_HEIGHT + accountView.frame.origin.y, DRAWER_WIDTH,
            self.frame.size.height - ACCOUNT_VIEW_HEIGHT) style:UITableViewStylePlain];
        tblNavigationItems.dataSource = self;
        tblNavigationItems.delegate = self;
        tblNavigationItems.scrollEnabled = NO;
        tblNavigationItems.separatorStyle = UITableViewCellSeparatorStyleNone;
        tblNavigationItems.backgroundColor = [UIColor clearColor];
        [self addSubview:tblNavigationItems];
    }
}

- (void)showAccountView:(id)sender {
    if(self.ownerViewController != nil) {
        [self.ownerViewController.navigationController pushViewController:[[UserAccountViewController alloc] init] animated:YES];
    }
}

- (void)setScreenName:(NSString *)name {
    if(lblMessage1 == nil) return;
    if([NSString isBlank:name]) lblMessage1.text = [NSString emptyString];
    lblMessage1.text = name;
}

- (void)changeItemToIndexPath:(NSIndexPath *)indexPath {
    if(tblNavigationItems == nil) return;
    DrawerNavigationItem *item = [navigationItems objectAtIndex:indexPath.row];
    if(indexPath.row != checkedRowIndex) {
        DrawerNavItemCell *cell = (DrawerNavItemCell *)[tblNavigationItems cellForRowAtIndexPath:[NSIndexPath indexPathForRow:checkedRowIndex inSection:0]];
        DrawerNavigationItem *oldItem = [navigationItems objectAtIndex:checkedRowIndex];
        [self setCell:cell isChecked:NO item:oldItem];
        cell = (DrawerNavItemCell *)[tblNavigationItems cellForRowAtIndexPath:indexPath];
        [self setCell:cell isChecked:YES item:item];
        checkedRowIndex = indexPath.row;
    }
    if(item) {
        if(self.drawerNavigationItemChangedDelegate != nil &&
           [self.drawerNavigationItemChangedDelegate respondsToSelector:@selector(drawerNavigationItemChanged:isFirstTime:)]) {
            [self.drawerNavigationItemChangedDelegate drawerNavigationItemChanged:item isFirstTime:NO];
        }
    }
}

#pragma mark -
#pragma mark table view delegate && data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"DrawerNavItemCell";
    DrawerNavItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    DrawerNavigationItem *item = [navigationItems objectAtIndex:indexPath.row];
    if(cell == nil) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"DrawerNavItemCell" owner:self options:nil];
        cell = [arr objectAtIndex:0];
        cell.backgroundColor = [UIColor clearColor];
        cell.lblPart.font = [UIFont systemFontOfSize:13.f];
        if(indexPath.row != navigationItems.count - 1) {
            UIImageView *imgSeperatorLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-2, DRAWER_WIDTH + 10, 2)];
            imgSeperatorLine.image = [UIImage imageNamed:@"line_cell_seperator.png"];
            [cell addSubview:imgSeperatorLine];
        }
        cell.lblPart.textColor = [UIColor colorWithHexString:@"#898e9a"];
    }
    
    [self setCell:cell isChecked:checkedRowIndex == indexPath.row item:item];
    cell.lblPart.text = item.itemTitle;
    
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
    [self changeItemToIndexPath:indexPath];
}

- (void)setCell:(DrawerNavItemCell *)cell isChecked:(BOOL)checked item:(DrawerNavigationItem *)item {
    if(cell == nil || item == nil) return;
    if(checked) {
        cell.imgPart.image = [UIImage imageNamed:item.itemCheckedImageName];
        cell.lblPart.textColor = [UIColor colorWithHexString:@"#eff4ff"];
    } else {
        cell.imgPart.image = [UIImage imageNamed:item.itemImageName];
        cell.lblPart.textColor = [UIColor colorWithHexString:@"#898e9a"];
    }
}

@end
