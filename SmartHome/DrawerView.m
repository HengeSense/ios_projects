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

#define ACCOUNT_VIEW_HEIGHT 80

@implementation DrawerView {
    UIView *accountView;
    UITableView *tblNavigationItems;
    NSArray *navigationItems;
    UIImageView *backgroundImageView;
    ViewsPool *viewsPool;
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
    entryHeight = ([UIScreen mainScreen].bounds.size.height - ACCOUNT_VIEW_HEIGHT - 20) / 4;
}

- (void)initUI {
    self.backgroundColor = [UIColor colorWithHexString:@"#3a3e47"];
    
    if(backgroundImageView == nil) {
        backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 120, self.frame.size.height)];
        backgroundImageView.image = [[UIImage imageNamed:@"bg_drawer_cell.png"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
        [self addSubview:backgroundImageView];
    }
    
    if(accountView == nil) {
        accountView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, ACCOUNT_VIEW_HEIGHT)];
        UIImageView *imgHeader = [[UIImageView alloc] initWithFrame:CGRectMake(12, 0, 30, 30)];
        imgHeader.image = [UIImage imageNamed:@"img_header.png"];
        imgHeader.center = CGPointMake(imgHeader.center.x, accountView.center.y);
        UILabel *lblMessage1 = [[UILabel alloc] initWithFrame:CGRectMake(50, 22, 60, 18)];
        UILabel *lblMessage2 = [[UILabel alloc] initWithFrame:CGRectMake(50, 42, 50, 18)];
        lblMessage1.backgroundColor = [UIColor clearColor];
        lblMessage2.backgroundColor = [UIColor clearColor];
        lblMessage1.font = [UIFont systemFontOfSize:13.f];
        lblMessage2.font = [UIFont systemFontOfSize:10.f];
        lblMessage1.textColor = [UIColor colorWithHexString:@"#898e9a"];
        lblMessage2.textColor = [UIColor colorWithHexString:@"#898e9a"];
        UIImageView *imgSeperatorLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, ACCOUNT_VIEW_HEIGHT-2, 120, 2)];
        imgSeperatorLine.image = [UIImage imageNamed:@"line_cell_seperator.png"];
        
        [accountView addSubview:imgHeader];
        [accountView addSubview:lblMessage1];
        [accountView addSubview:lblMessage2];
        UIButton *accountBackground = [[UIButton alloc] initWithFrame:accountView.bounds];
        accountBackground.backgroundColor = [UIColor clearColor];
        [accountBackground addTarget:self action:@selector(showAccountView:) forControlEvents:UIControlEventTouchUpInside];
        [accountView addSubview:accountBackground];
        [self addSubview:accountView];
        [self addSubview:imgSeperatorLine];
        
        lblMessage1.text = @"个人账号";
        lblMessage2.text = NSLocalizedString(@"account.setting", @"");
    }
    
    if(tblNavigationItems == nil) {
        tblNavigationItems = [[UITableView alloc]
            initWithFrame:CGRectMake(0, ACCOUNT_VIEW_HEIGHT, 120,
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

#pragma mark -
#pragma mark table view delegate && data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"DrawerNavItemCell";
    DrawerNavItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    DrawerNavigationItem *item = [navigationItems objectAtIndex:indexPath.row];
    if(cell == nil) {
        NSArray *arr = [[NSBundle mainBundle] loadNibNamed:@"DrawerNavItemCell" owner:self options:nil];
        cell = [arr objectAtIndex:0];
        CGRect imgRect = cell.imgPart.frame;
        cell.imgPart.frame = CGRectMake(imgRect.origin.x, 12, imgRect.size.width, imgRect.size.height);
        CGRect lblRect = cell.lblPart.frame;
        cell.lblPart.frame = CGRectMake(lblRect.origin.x, cell.frame.size.height - lblRect.size.height - 14, lblRect.size.width, lblRect.size.height);
        cell.lblPart.font = [UIFont systemFontOfSize:13.f];
        if(indexPath.row != navigationItems.count - 1) {
            UIImageView *imgSeperatorLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, cell.frame.size.height-2, 120, 2)];
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
    DrawerNavigationItem *item = [navigationItems objectAtIndex:indexPath.row];
    if(indexPath.row != checkedRowIndex) {
        DrawerNavItemCell *cell = (DrawerNavItemCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:checkedRowIndex inSection:0]];
        DrawerNavigationItem *oldItem = [navigationItems objectAtIndex:checkedRowIndex];
        [self setCell:cell isChecked:NO item:oldItem];
        cell = (DrawerNavItemCell *)[tableView cellForRowAtIndexPath:indexPath];
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
