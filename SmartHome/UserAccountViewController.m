//
//  UserAccountViewController.m
//  SmartHome
//
//  Created by hadoop user account on 2/09/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "UserAccountViewController.h"
#import "CommandFactory.h"
#import "LongButton.h"
#import "DeviceCommandUpdateAccount.h"
#import "ViewsPool.h"
#import "NavigationView.h"
#import "MainViewController.h"
#import "VerificationCodeSendViewController.h"
#import "UIColor+ExtentionForHexString.h"

@interface UserAccountViewController ()

@end

@implementation UserAccountViewController {
    UITableView *infoTable;
    NSArray *titles;
    NSMutableArray *values;
    
    UITableViewCell *editCell;
    NSIndexPath *editIndex;
    
    BOOL accountInfoIsModifed;
    NSString *password;
    UIButton *btnSubmit;
    
    NSTimer *timeoutTimer;
}

@synthesize infoDictionary;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initDefaults {
    [super initDefaults];
    values = [[NSMutableArray alloc] initWithObjects:@"", @"", @"", nil];
    
    titles = [[NSArray alloc] initWithObjects:NSLocalizedString(@"nick_name", @""),NSLocalizedString(@"mail", @""),NSLocalizedString(@"modify_pwd", @""), nil];
    
    if (infoDictionary == nil) {
        infoDictionary = [[NSMutableDictionary alloc] initWithObjects:values forKeys:titles];
    }
    
    [[SMShared current].memory subscribeHandler:[DeviceCommandGetAccountHandler class] for:self];
    [[SMShared current].memory subscribeHandler:[DeviceCommandUpdateAccountHandler class] for:self];
}

- (void)initUI {
    [super initUI];
    
    self.topbar.titleLabel.text = NSLocalizedString(@"account_info.title", @"");

    if(infoTable == nil) {
        infoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbar.bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - self.topbar.bounds.size.height) style:UITableViewStyleGrouped];
        infoTable.delegate = self;
        infoTable.dataSource = self;
        infoTable.backgroundView = nil;
        infoTable.backgroundColor = [UIColor clearColor];
        infoTable.sectionHeaderHeight = 0;
        infoTable.sectionFooterHeight = 0;
        infoTable.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 10)];
        [self.view addSubview:infoTable];
    }
    
    [[SMShared current].deliveryService executeDeviceCommand:[CommandFactory commandForType:CommandTypeGetAccount]];
}

- (void)updateUsername:(NSString *)username{
    UITableViewCell *usernameCell = [infoTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    usernameCell.detailTextLabel.text = username;
}

#pragma mark -
#pragma mark UI Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"detailTextLabel%@",editCell.detailTextLabel);
    NSLog(@"detailTextLabel text%@",editCell.detailTextLabel.text);

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.section == 0) {
        VerificationCodeSendViewController *verificationCodeSendViewController = [[VerificationCodeSendViewController alloc] initAsModify:YES];
        [self.navigationController pushViewController:verificationCodeSendViewController animated:YES];
    } else if(indexPath.section == 1) {
        editCell = [tableView cellForRowAtIndexPath:indexPath];
        editIndex = indexPath;
        ModifyInfoViewController *modifyView = [[ModifyInfoViewController alloc] initWithKey:[titles objectAtIndex:indexPath.row] forValue:[values objectAtIndex:indexPath.row] from:self];
        modifyView.textDelegate = self;
        [self presentViewController:modifyView animated:YES completion:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if(section == 0) {
        return 50;
    } else if(section == 1) {
        return 130;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footView = nil;
   
    if(section == 0) {
        footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 50)];
        UILabel *lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 29)];
        lblDescription.font = [UIFont systemFontOfSize:14.f];
        lblDescription.textColor = [UIColor lightGrayColor];
        lblDescription.backgroundColor = [UIColor clearColor];
        lblDescription.text = NSLocalizedString(@"modify_account_tips", @"");
        [footView addSubview:lblDescription];
    } if(section == 1) {
        footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 130)];
        UILabel *lblDescription = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 300, 58)];
        lblDescription.font = [UIFont systemFontOfSize:14.f];
        lblDescription.textColor = [UIColor lightGrayColor];
        lblDescription.backgroundColor = [UIColor clearColor];
        lblDescription.numberOfLines = 2;
        lblDescription.text = NSLocalizedString(@"modify_profile_tips", @"");
        [footView addSubview:lblDescription];
        if(btnSubmit == nil) {
            btnSubmit = [LongButton buttonWithPoint:CGPointMake(0, 70)];
            btnSubmit.center = CGPointMake(footView.center.x, btnSubmit.center.y);
            [btnSubmit setTitle:NSLocalizedString(@"submit", @"") forState:UIControlStateNormal];
            [btnSubmit addTarget:self action:@selector(btnSubmitClicked:) forControlEvents:UIControlEventTouchUpInside];
            btnSubmit.enabled = accountInfoIsModifed;
        }
        [footView addSubview:btnSubmit];
    }
    footView.backgroundColor = [UIColor clearColor];
    return footView;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return 1;
    } else if(section == 1) {
        return values == nil ? 0 : values.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        if(![UIDevice systemVersionIsMoreThanOrEuqal7]) {
            cell.textLabel.font = [UIFont systemFontOfSize:17.f];
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        }
    }
    
    if(indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
        cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView.backgroundColor = [UIColor lightGrayColor];
        cell.textLabel.text = NSLocalizedString(@"username", @"");
        cell.detailTextLabel.text = [SMShared current].settings.account;
    } else if(indexPath.section == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor whiteColor];
        cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView.backgroundColor = [UIColor lightGrayColor];
        cell.textLabel.text = [titles objectAtIndex:indexPath.row];
        if (indexPath.row == 2) {
            cell.detailTextLabel.text = @"********";
        }else{
            cell.detailTextLabel.text = [values objectAtIndex:indexPath.row];
        }
    }
    
    return cell;
}

#pragma mark -
#pragma mark Get account 

- (void)getAccountOnComplete:(DeviceCommandUpdateAccount *)updateCommand {
    if(updateCommand != nil) {
        [values setObject:updateCommand.screenName atIndexedSubscript:0];
        [values setObject:updateCommand.email atIndexedSubscript:1];
        for (int i=0;i<titles.count;++i) {
            [infoDictionary setValue:[values objectAtIndex:i] forKey:[titles objectAtIndex:i]];
        }
        [infoTable reloadData];
    }
    return;
}

#pragma mark -
#pragma mark Submit Changes

- (void)btnSubmitClicked:(id)sender {
    UIAlertView  *needPwdAlertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"password_valid", @"") message:NSLocalizedString(@"enter_old_pwd", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"") otherButtonTitles:NSLocalizedString(@"ok", @""), nil];
    [needPwdAlertView setAlertViewStyle:UIAlertViewStyleSecureTextInput];
    [needPwdAlertView textFieldAtIndex:0].text = [NSString emptyString];
    [needPwdAlertView show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag == 1023 && buttonIndex == 1) {
        [self reallyBackToPreViewController];
    } else if(buttonIndex == 1) {
        password = [alertView textFieldAtIndex:0].text;
        [NSTimer scheduledTimerWithTimeInterval:0.6f target:self selector:@selector(delayProcess) userInfo:nil repeats:NO];
    }
}

- (void)delayProcess {
    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"processing", @"") forType:AlertViewTypeWaitting];
    [[AlertView currentAlertView] alertAutoDisappear:NO lockView:self.view];
    
    timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(delayDimiss) userInfo:nil repeats:NO];
    
    if ([self checkExternalNetwork]) {
        DeviceCommandUpdateAccount *command = (DeviceCommandUpdateAccount *)[CommandFactory commandForType:CommandTypeUpdateAccount];
        command.email = [infoDictionary objectForKey:NSLocalizedString(@"mail", @"")];
        command.screenName = [infoDictionary objectForKey:NSLocalizedString(@"nick_name", @"")];
        command.pwdToUpdate = [infoDictionary objectForKey:NSLocalizedString(@"modify_pwd", @"")];
        command.oldPwd = password;
        [[SMShared current].deliveryService executeDeviceCommand:command];
    }
    
    password = [NSString emptyString];
}

- (void)delayDimiss {
    @synchronized(self){
        if ([AlertView currentAlertView].alertViewState != AlertViewStateReady) {
            [[AlertView currentAlertView] setMessage:NSLocalizedString(@"unknow_error", @"") forType:AlertViewTypeFailed];
            [[AlertView currentAlertView] delayDismissAlertView];
        }
    }
}
    
- (void)updateAccountOnComplete:(DeviceCommand *)command {
    @synchronized(self){
        [timeoutTimer invalidate];
        timeoutTimer = nil;

        if (command == nil) {
            [[AlertView currentAlertView] setMessage:NSLocalizedString(@"unknow_error", @"") forType:AlertViewTypeFailed];
            [[AlertView currentAlertView] delayDismissAlertView];
            return;
        }

        switch (command.resultID) {
            case 1:
                [[AlertView currentAlertView] setMessage:NSLocalizedString(@"update_success", @"") forType:AlertViewTypeSuccess];
                [[AlertView currentAlertView] delayDismissAlertView];
                accountInfoIsModifed = NO;
                btnSubmit.enabled = NO;
                password = [NSString emptyString];
                [self notifyMainViewScreenNameChanged];
                break;
            case -1:
                [[AlertView currentAlertView] setMessage:NSLocalizedString(@"pwd_invalid", @"") forType:AlertViewTypeFailed];
                [[AlertView currentAlertView] delayDismissAlertView];
                break;
            case -2:
                [[AlertView currentAlertView] setMessage:NSLocalizedString(@"mail_name_blank", @"") forType:AlertViewTypeFailed];
                [[AlertView currentAlertView] delayDismissAlertView];
                break;
            case -3:
                [[AlertView currentAlertView] setMessage:NSLocalizedString(@"format_error", @"") forType:AlertViewTypeFailed];
                [[AlertView currentAlertView] delayDismissAlertView];
                break;
            case -4:
                [[AlertView currentAlertView] setMessage:NSLocalizedString(@"request_frequently", @"") forType:AlertViewTypeFailed];
                [[AlertView currentAlertView] delayDismissAlertView];
                break;
            default:
                break;
        }
    }
}

- (void)notifyMainViewScreenNameChanged {
    NavigationView *view = (NavigationView *)[[ViewsPool sharedPool] viewWithIdentifier:@"mainView"];
    if(view != nil) {
        MainViewController *controller = (MainViewController *)view.ownerController;
        if(controller != nil) {
            DrawerView *dv = (DrawerView *)controller.leftView;
            if(dv != nil) {
                [dv setScreenName:[infoDictionary stringForKey:NSLocalizedString(@"nick_name", @"")]];
            }
        }
    }
}

- (void)textViewHasBeenSetting:(NSString *)string {
    if(editIndex == nil || editCell == nil) {
        editCell = nil;
        editIndex = nil;
        return;
    }
    
    if ([[titles objectAtIndex:editIndex.row] isEqualToString:NSLocalizedString(@"modify_pwd", @"")]) {
        if(![NSString isBlank:string]) {
            accountInfoIsModifed = YES;
            btnSubmit.enabled = accountInfoIsModifed;
        }
    } else {
        if (string && ![string isEqualToString:[values objectAtIndex:editIndex.row]]) {
            [values setObject:string atIndexedSubscript:editIndex.row];
            accountInfoIsModifed = YES;
            btnSubmit.enabled = accountInfoIsModifed;
            editCell.detailTextLabel.text = string;
        }
    }
    [infoDictionary setValue:string forKey:[titles objectAtIndex:editIndex.row]];
    
    editCell = nil;
    editIndex = nil;
}

- (BOOL)checkExternalNetwork {
    if([[SMShared current].deliveryService.tcpService isConnectted]) {
        return YES;
    } else{
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"offline", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] delayDismissAlertView];
        return NO;
    }
}

- (void)backToPreViewController {
    if(accountInfoIsModifed) {
        UIAlertView  *promptAlertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"prompt", @"") message:NSLocalizedString(@"profile_changed_tips", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"") otherButtonTitles:NSLocalizedString(@"discard", @""), nil];
        promptAlertView.tag = 1023;
        [promptAlertView show];
        return;
    }
    
    [self reallyBackToPreViewController];
}

- (void)reallyBackToPreViewController {
    [[SMShared current].memory unSubscribeHandler:[DeviceCommandGetAccountHandler class] for:self];
    [[SMShared current].memory unSubscribeHandler:[DeviceCommandUpdateAccountHandler class] for:self];
    [super backToPreViewController];
}

@end
