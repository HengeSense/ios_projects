//
//  MySettingsView.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "MySettingsView.h"
#import "AlertView.h"
#import "LongButton.h"
#import "SMCell.h"

@implementation MySettingsView {
    UITableView *tblSettings;
    UIButton *btnLogout;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)initDefaults {
    [super initDefaults];
}

- (void)initUI {
    [super initUI];
    if(tblSettings == nil) {
        tblSettings = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbar.bounds.size.height + 5, SM_CELL_WIDTH / 2, self.bounds.size.height - self.topbar.bounds.size.height - 5) style:UITableViewStylePlain];
        tblSettings.separatorStyle = UITableViewCellSeparatorStyleNone;
        tblSettings.center = CGPointMake(self.center.x, tblSettings.center.y);
        tblSettings.backgroundColor = [UIColor clearColor];
        tblSettings.dataSource = self;
        tblSettings.delegate = self;
        [self addSubview:tblSettings];
    }
    
    if(btnLogout == nil) {
        btnLogout = [LongButton buttonWithPoint:CGPointMake(0, 0)];
        btnLogout.center = CGPointMake(self.bounds.size.width / 2, 222);
        [btnLogout setTitle:NSLocalizedString(@"account_logout", @"") forState:UIControlStateNormal];
        btnLogout.titleLabel.textColor = [UIColor whiteColor];
        [btnLogout addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnLogout];
    }
}

#pragma mark -
#pragma mark table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            break;
        case 1:
            break;
        case 2:
            break;
        default:
            break;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SM_CELL_HEIGHT / 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *topCellIdentifier = @"topCellIdentifier";
    static NSString *centerCellIdentifier = @"cellIdentifier";
    static NSString *bottomCellIdentifier = @"bottomCellIdentifier";
    
    NSString *cellIdentifier;
    
    if(indexPath.row == 0) {
        cellIdentifier = topCellIdentifier;
    } else if(indexPath.row == 3) {
        cellIdentifier = bottomCellIdentifier;
    } else {
        cellIdentifier = centerCellIdentifier;
    }
    
    SMCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[SMCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:17.f];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.imageView.image = [UIImage imageNamed:@"icon_notification.png"];
            cell.textLabel.text = [NSString stringWithFormat:@"  %@", NSLocalizedString(@"push_settings", @"")];
            break;
        case 1:
            cell.imageView.image = [UIImage imageNamed:@"icon_feed_back.png"];
            cell.textLabel.text = [NSString stringWithFormat:@"  %@", NSLocalizedString(@"feed_back", @"")];
            break;
        case 2:
            cell.imageView.image = [UIImage imageNamed:@"icon_about_us.png"];
            cell.textLabel.text = [NSString stringWithFormat:@"  %@", NSLocalizedString(@"about_us", @"")];
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)logout {
    [[SMShared current].settings clearAuth];
    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"please_wait", @"") forType:AlertViewTypeWaitting];
    [[AlertView currentAlertView] alertAutoDisappear:NO lockView:self.ownerController.view];
    [NSTimer scheduledTimerWithTimeInterval:0.7f target:self selector:@selector(reallyLogout) userInfo:nil repeats:NO];
}

- (void)reallyLogout {
    [[SMShared current].deliveryService stopService];
    //clear all subscriptions
    [[SMShared current].memory.subscriptions removeAllObjects];
    //clear all units
    [[SMShared current].memory clearUnits];
    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"has_logout", @"") forType:AlertViewTypeSuccess];
    [[AlertView currentAlertView] delayDismissAlertView];
    [self.ownerController.navigationController popToRootViewControllerAnimated:YES];
}

@end
