//
//  PushSettingViewController.m
//  SmartHome
//
//  Created by hadoop user account on 12/09/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "PushSettingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>
#import "SystemAudio.h"

#define ITEM_HEIGHT 50

@interface PushSettingViewController ()

@end

@implementation PushSettingViewController{
    
    UITableView *tblPushSettings;
    
    UIView *systemSettingView;
    UILabel *lblSystemSetting;
    UIView  *voiceAndShakeView;
    UISwitch *voiceSwitch;
    UISwitch *shakeSwitch;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
    
- (void)initDefaults {
    [super initDefaults];
}
    
- (void)initUI {
    [super initUI];
    
    self.topbar.titleLabel.text = NSLocalizedString(@"push_settings.title", @"");
    
    if(tblPushSettings == nil) {
        tblPushSettings = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbar.bounds.size.height, [UIScreen mainScreen].bounds.size.width, self.view.bounds.size.height - self.topbar.bounds.size.height - 5) style:UITableViewStyleGrouped];
        tblPushSettings.dataSource = self;
        tblPushSettings.delegate = self;
        tblPushSettings.backgroundView = nil;
        tblPushSettings.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 10)];
        tblPushSettings.sectionFooterHeight = 0;
        tblPushSettings.sectionHeaderHeight = 0;
        tblPushSettings.backgroundColor = [UIColor clearColor];
        [self.view addSubview:tblPushSettings];
    }
}

#pragma mark -
#pragma mark - Table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) return 1;
    if(section == 1) return 2;
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(section == 0) {
        return 90;
    } else if(section == 1) {
        return 50;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = nil;
    
    if(section == 0) {
        footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 90)];
        UILabel *lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 75)];
        lblDescription.font = [UIFont systemFontOfSize:14.f];
        lblDescription.numberOfLines = 3;
        lblDescription.textColor = [UIColor lightGrayColor];
        lblDescription.backgroundColor = [UIColor clearColor];
        lblDescription.text = NSLocalizedString(@"push.help1", @"");
        [footView addSubview:lblDescription];
    } if(section == 1) {
        footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
        UILabel *lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 300, 29)];
        lblDescription.font = [UIFont systemFontOfSize:14.f];
        lblDescription.textColor = [UIColor lightGrayColor];
        lblDescription.backgroundColor = [UIColor clearColor];
        lblDescription.text = NSLocalizedString(@"push.help2", @"");
        [footView addSubview:lblDescription];
    }
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *normalCellIdentifier = @"ncellIdentifier";
    static NSString *switchCellIdentifier = @"sCellIdentifier";
    
    UITableViewCell *cell = nil;

    cell = [tableView dequeueReusableCellWithIdentifier:indexPath.section == 0 ? normalCellIdentifier : switchCellIdentifier];

    if(cell == nil) {
        if(indexPath.section == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:normalCellIdentifier];
        } else {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:switchCellIdentifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView.backgroundColor = [UIColor lightGrayColor];
        
        if(![UIDevice systemVersionIsMoreThanOrEuqal7]) {
            cell.textLabel.font = [UIFont systemFontOfSize:16.f];
        }
        
        if(indexPath.section == 0) {
            if(![UIDevice systemVersionIsMoreThanOrEuqal7]) {
                cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            }
        } else {
            UISwitch *swh = [[UISwitch alloc] initWithFrame:CGRectMake([UIDevice systemVersionIsMoreThanOrEuqal7] ? 255 : 225, [UIDevice systemVersionIsMoreThanOrEuqal7] ? 5 : 8, 50, 29)];
            [cell addSubview:swh];
            [swh addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
            
            if(indexPath.row == 0) {
                swh.tag = 800;
            } else {
                swh.tag = 801;
            }
        }
    }
    
    if(indexPath.section == 0) {
        cell.textLabel.text = NSLocalizedString(@"receive_new_notification", @"");
        cell.detailTextLabel.text = [[UIApplication sharedApplication] enabledRemoteNotificationTypes]?NSLocalizedString(@"status_opened", @""):NSLocalizedString(@"status_closed", @"");
    } else if(indexPath.section == 1) {
        if(indexPath.row == 0) {
            UISwitch *sh = (UISwitch *)[cell viewWithTag:800];
            cell.textLabel.text = NSLocalizedString(@"voice", @"");
            [sh setOn:[SMShared current].settings.isVoice animated:NO];
        } else if(indexPath.row == 1) {
            UISwitch *sh = (UISwitch *)[cell viewWithTag:801];
            cell.textLabel.text = NSLocalizedString(@"shake", @"");
            [sh setOn:[SMShared current].settings.isShake animated:NO];
        }
    }
    
    return cell;
}
    
- (void)switchChanged:(UISwitch *)sender {
    if(sender == nil) return;
    if (sender.tag == 800) {
        if(sender.isOn) {
            [SystemAudio playClassicSmsSound];
        }
        [SMShared current].settings.isVoice = sender.isOn;
        [[SMShared current].settings saveSettings];
    } else if(sender.tag == 801) {
        if(sender.isOn) {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
        }
        [SMShared current].settings.isShake = sender.isOn;
        [[SMShared current].settings saveSettings];
    }
}
    
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
