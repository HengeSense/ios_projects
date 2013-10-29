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
    values = [[NSMutableArray alloc]initWithObjects:@"", @"", @"", nil];
    
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
        infoTable = [[UITableView alloc] initWithFrame:CGRectMake([UIDevice systemVersionIsMoreThanOrEuqal7] ? 5 : -5, self.topbar.bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - self.topbar.bounds.size.height) style:UITableViewStyleGrouped];
        infoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        infoTable.backgroundColor = [UIColor clearColor];
        infoTable.backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];;
        infoTable.scrollEnabled = NO;
        infoTable.delegate = self;
        infoTable.dataSource = self;
        
        [self.view addSubview:infoTable];
    }
    
    if(btnSubmit == nil) {
        btnSubmit = [LongButton buttonWithPoint:CGPointMake(0, [UIDevice systemVersionIsMoreThanOrEuqal7] ? 350 : 330)];
        btnSubmit.center = CGPointMake(self.view.center.x, btnSubmit.center.y);
        [btnSubmit setTitle:NSLocalizedString(@"submit", @"") forState:UIControlStateNormal];
        [self.view addSubview:btnSubmit];
        [btnSubmit addTarget:self action:@selector(btnSubmitClicked:) forControlEvents:UIControlEventTouchUpInside];
        btnSubmit.enabled = accountInfoIsModifed;
    }
    
    [[SMShared current].deliveryService executeDeviceCommand:[CommandFactory commandForType:CommandTypeGetAccount]];
}

- (void)updateUsername:(NSString *)username{
    UITableViewCell *usernameCell = [infoTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    UILabel *detailLabel = (UILabel *)[usernameCell viewWithTag:888];
    if (detailLabel)
    detailLabel.text = username;
}

#pragma mark -
#pragma mark UI Table View Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
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
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SM_CELL_WIDTH / 2, 40)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(12, 9, 280, 30)];
    lblTitle.textColor = [UIColor colorWithHexString:@"b8642d"];
    lblTitle.font = [UIFont boldSystemFontOfSize:16.f];
    lblTitle.backgroundColor = [UIColor clearColor];
    [view addSubview:lblTitle];
    if(section == 0) {
        lblTitle.text = NSLocalizedString(@"modify_account", @"");
    } else {
        lblTitle.text = NSLocalizedString(@"modify_profile", @"");
    }
    return view;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0) {
        return 1;
    } else {
        return values == nil ? 0 : values.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *topCellIdentifier = @"topCellIdentifier";
    static NSString *centerCellIdentifier = @"cellIdentifier";
    static NSString *bottomCellIdentifier = @"bottomCellIdentifier";
    static NSString *singleCellIdentifier = @"singleCellIdentifier";
    
    NSString *cellIdentifier;
    if(indexPath.section == 0) {
        cellIdentifier = singleCellIdentifier;
    } else {
        if(indexPath.row == 0) {
            cellIdentifier = topCellIdentifier;
        } else if(indexPath.row == titles.count - 1) {
            cellIdentifier = bottomCellIdentifier;
        } else {
            cellIdentifier = centerCellIdentifier;
        }
    }
    
    SMCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[SMCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier needFixed:![UIDevice systemVersionIsMoreThanOrEuqal7]];
        
        cell.backgroundColor = [UIColor clearColor];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 120, 40)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.tag = 999;
        [cell addSubview:titleLabel];
        
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(([UIDevice systemVersionIsMoreThanOrEuqal7] ? 115 : 130), 2, 160, 40)];
        detailLabel.textAlignment = NSTextAlignmentRight;
        detailLabel.textColor = [UIColor darkGrayColor];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.font = [UIFont systemFontOfSize:16.f];
        detailLabel.tag = 888;
        [cell addSubview:detailLabel];
    }
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:999];
    UILabel *detailLabel = (UILabel *)[cell viewWithTag:888];
    
    if(indexPath.section == 0) {
        titleLabel.text = NSLocalizedString(@"username", @"");
        detailLabel.text = [SMShared current].settings.account;
    } else if(indexPath.section == 1) {
        titleLabel.text = [titles objectAtIndex:indexPath.row];
        detailLabel.text = [values objectAtIndex:indexPath.row];
    }
    
    if(indexPath.section == 0) {
        cell.isSingle = YES;
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
                ((UILabel *)[[infoTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:1]] viewWithTag:888]).text = [NSString emptyString];
                
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
            UILabel *detailLabel = (UILabel *)[editCell viewWithTag:888];
            detailLabel.text = NSLocalizedString(@"pwd_edited", @"");
        }
    } else {
        if (string && ![string isEqualToString:[values objectAtIndex:editIndex.row]]) {
            [values setObject:string atIndexedSubscript:editIndex.row];
            accountInfoIsModifed = YES;
            btnSubmit.enabled = accountInfoIsModifed;
            UILabel *detailLabel = (UILabel *)[editCell viewWithTag:888];
            detailLabel.text = string;
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
