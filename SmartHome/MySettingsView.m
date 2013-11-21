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
#import "PushSettingViewController.h"
#import "WelcomeViewController.h"
#import "AboutUsViewController.h"

@implementation MySettingsView {
    UITableView *tblSettings;
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
        tblSettings = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbar.bounds.size.height + 5, [UIScreen mainScreen].bounds.size.width, self.bounds.size.height - self.topbar.bounds.size.height - 5) style:UITableViewStylePlain];
        tblSettings.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tblSettings.center = CGPointMake(self.center.x, tblSettings.center.y);
        tblSettings.backgroundColor = [UIColor clearColor];
        tblSettings.dataSource = self;
        tblSettings.delegate = self;
        [self addSubview:tblSettings];
    }
    
    [[SMShared current].memory subscribeHandler:[DeviceCommandCheckVersionHandler class] for:self];
}

#pragma mark -
#pragma mark table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            [self.ownerController.navigationController pushViewController:[[PushSettingViewController alloc]init] animated:YES];
            break;
        case 1:
            [self checkVersion];
            break;
        case 2:
            [self.ownerController.navigationController pushViewController:[[AboutUsViewController alloc] init] animated: YES];
            break;
        case 3:
            [self.ownerController.navigationController pushViewController:[[WelcomeViewController alloc] init] animated:YES];
            break;
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SM_CELL_HEIGHT / 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(section == 0) {
        return 49 + 15;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    if(section == 0) {
        UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 49+15)];
        footView.backgroundColor = [UIColor clearColor];
        LongButton *btnLogout = [LongButton buttonWithPoint:CGPointMake(0, 10)];
        btnLogout.center = CGPointMake(160, btnLogout.center.y);
        [btnLogout setTitle:NSLocalizedString(@"account_logout", @"") forState:UIControlStateNormal];
        btnLogout.titleLabel.textColor = [UIColor whiteColor];
        [btnLogout addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
        [footView addSubview:btnLogout];
        return footView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView.backgroundColor = [UIColor lightGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:17.f];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.imageView.image = [UIImage imageNamed:@"icon_notification.png"];
            cell.textLabel.text = [NSString stringWithFormat:@"  %@", NSLocalizedString(@"push_settings", @"")];
            break;
        case 1:
            cell.imageView.image = [UIImage imageNamed:@"icon_feed_back.png"];
            cell.textLabel.text = [NSString stringWithFormat:@"  %@", NSLocalizedString(@"update_product", @"")];
            break;
        case 2:
            cell.imageView.image = [UIImage imageNamed:@"icon_about_us.png"];
            cell.textLabel.text = [NSString stringWithFormat:@"  %@", NSLocalizedString(@"about_us", @"")];
            break;
        case 3:
            cell.imageView.image = [UIImage imageNamed:@"help.png"];
            cell.textLabel.text = [NSString stringWithFormat:@"  %@", NSLocalizedString(@"help", @"")];
            break;
        default:
            break;
    }
    
    return cell;
}

- (void)logout {
    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"please_wait", @"") forType:AlertViewTypeWaitting];
    [[AlertView currentAlertView] alertAutoDisappear:NO lockView:self.ownerController.view];
    [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(reallyLogout) userInfo:nil repeats:NO];
}

- (void)reallyLogout {
    [[SMShared current].app logout];
    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"has_logout", @"") forType:AlertViewTypeSuccess];
    [[AlertView currentAlertView] delayDismissAlertView];
    [self.ownerController.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark Check app verion

- (void)checkVersion {
    DeviceCommandCheckVersion *command = (DeviceCommandCheckVersion *)[CommandFactory commandForType:CommandTypeCheckVersion];
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    command.curVersion = [NSNumber numberWithDouble:[infoDict doubleForKey:@"CFBundleVersion"]];
    [[SMShared current].deliveryService executeDeviceCommand:command];
}

- (void)didCheckVersionComplete:(DeviceCommand *)command {
    switch (command.resultID) {
        case 1:
            [[AlertView currentAlertView] setMessage:NSLocalizedString(@"app_is_not_lasted_version", @"") forType:AlertViewTypeFailed];
            [[AlertView currentAlertView] alertAutoDisappear:YES lockView:nil];
            break;
        case -1:
            [[AlertView currentAlertView] setMessage:NSLocalizedString(@"app_is_lasted_version", @"") forType:AlertViewTypeSuccess];
            [[AlertView currentAlertView] alertAutoDisappear:YES lockView:nil];
            break;
        case -2:
        default:
            [[AlertView currentAlertView] setMessage:NSLocalizedString(@"unknow_error", @"") forType:AlertViewTypeFailed];
            [[AlertView currentAlertView] alertAutoDisappear:YES lockView:nil];
            break;
    }
}

#pragma mark - 
#pragma mark Override

- (void)destory {
    [[SMShared current].memory unSubscribeHandler:[DeviceCommandCheckVersionHandler class] for:self];
}

@end
