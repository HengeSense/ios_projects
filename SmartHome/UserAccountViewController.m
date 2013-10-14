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
#import <QuartzCore/QuartzCore.h>

@interface UserAccountViewController ()

@end

@implementation UserAccountViewController{
    UITableView *infoTable;
    NSArray *titles;
    NSMutableArray *values;
    UITableViewCell *editCell;
    NSIndexPath *editIndex;
    UIAlertView *checkPassword;
    NSString *password;
    UIButton *btnSubmit;
    BOOL passwordIsModified;
    
    UIButton *btnModifyUsername;
    UILabel *lblUsername;
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

- (void)viewDidAppear:(BOOL)animated {
}

- (void)initDefaults {
    [super initDefaults];
    values = [[NSMutableArray alloc]initWithObjects:@"",@"",@"",nil];
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
    
    if (btnModifyUsername == nil) {
        btnModifyUsername = [[UIButton alloc] initWithFrame:CGRectMake(0, self.topbar.frame.size.height+5, SM_CELL_WIDTH/2, SM_CELL_HEIGHT/2)];
        btnModifyUsername.layer.cornerRadius = 5;
        btnModifyUsername.center = CGPointMake(self.view.center.x, btnModifyUsername.center.y);
        btnModifyUsername.backgroundColor = [UIColor whiteColor];
        
        UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,80 , SM_CELL_HEIGHT/2)];
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.text = NSLocalizedString(@"username", @"");
        lblTitle.font = [UIFont systemFontOfSize:16.f];
        [btnModifyUsername addSubview:lblTitle];
        
        lblUsername = [[UILabel alloc] initWithFrame:CGRectMake(85, 0,200 ,SM_CELL_HEIGHT/2)];
        lblUsername.textAlignment = NSTextAlignmentRight;
        [lblUsername setBackgroundColor:[UIColor clearColor]];
        [lblUsername setTextColor:[UIColor grayColor]];
        [lblUsername setFont:[UIFont systemFontOfSize:16]];
        lblUsername.text = [SMShared current].settings.account;
        [btnModifyUsername addSubview:lblUsername];
        
        UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accessory.png"]];
        accessoryView.frame = CGRectMake(295, 17.5, 12/2, 23/2);
        [btnModifyUsername addSubview:accessoryView];
        
        [btnModifyUsername addTarget:self action:@selector(btnModifyUsernamePressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnModifyUsername];

    }

    if (infoTable == nil) {
        infoTable = [[UITableView alloc] initWithFrame:CGRectMake(0,btnModifyUsername.frame.size.height+btnModifyUsername.frame.origin.y+25, SM_CELL_WIDTH/2, self.view.frame.size.height - self.topbar.bounds.size.height - 5) style:UITableViewStylePlain];
        infoTable.center = CGPointMake(self.view.center.x, infoTable.center.y);
        infoTable.delegate = self;
        infoTable.dataSource =self;
        infoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        infoTable.backgroundColor = [UIColor clearColor];
        infoTable.scrollEnabled = NO;
        [self.view addSubview:infoTable];
    }
    
    if(checkPassword == nil) {
        checkPassword = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"password_valid", @"") message:NSLocalizedString(@"enter_old_pwd", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"") otherButtonTitles:NSLocalizedString(@"ok", @""), nil];
        [checkPassword setAlertViewStyle:UIAlertViewStyleSecureTextInput];
    }
    
    if(btnSubmit == nil) {
        btnSubmit = [LongButton buttonWithPoint:CGPointMake(0, [UIDevice systemVersionIsMoreThanOrEuqal7] ? 280 : 260)];
        btnSubmit.center = CGPointMake(self.view.center.x, btnSubmit.center.y);
        [btnSubmit setTitle:NSLocalizedString(@"submit", @"") forState:UIControlStateNormal];
        [self.view addSubview:btnSubmit];
        [btnSubmit addTarget:self action:@selector(btnDownPressed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    [[SMShared current].deliveryService executeDeviceCommand:[CommandFactory commandForType:CommandTypeGetAccount]];
}

- (void)btnModifyUsernamePressed:(UIButton *) sender{
    VerificationCodeSendViewController *verificationCodeSendViewController = [[VerificationCodeSendViewController alloc] initAsModify:YES];
    [self.navigationController pushViewController:verificationCodeSendViewController animated:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(values == nil) return 0;
    return titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier;
    if (indexPath.row == 0) {
        cellIdentifier = @"topCellIdentifier";
    }else if (indexPath.row == titles.count-1){
        cellIdentifier = @"bottomCellIdentifier";
    }else{
        cellIdentifier = @"cellIdentifier";
    }
    UITableViewCell *result = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(result == nil){
        result = [[SMCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [result.contentView addSubview:[self viewInCellAtIndexPath:indexPath of:result]];
    }
    
    UILabel *lblValue = (UILabel *)[[result.contentView viewWithTag:999] viewWithTag:1000];
    if(lblValue != nil) {
        lblValue.text = [values objectAtIndex:indexPath.row];
    }
    
    return result;
}

- (void)btnDownPressed:(id)sender {
    [checkPassword show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        password = [alertView textFieldAtIndex:0].text;
        [NSTimer scheduledTimerWithTimeInterval:0.5f target:self selector:@selector(delayProcess) userInfo:nil repeats:NO];
    }
}

- (UIView *)viewInCellAtIndexPath:(NSIndexPath *) indexPath of:(UITableViewCell *)cell {
    NSArray *subViews = cell.contentView.subviews;
    for (UIView *v in subViews) {
        [v removeFromSuperview];
    }
    
    UIView *view = [[UIView alloc] initWithFrame:cell.contentView.frame];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,80 , cell.frame.size.height)];
    titleLabel.text = [titles objectAtIndex:indexPath.row];
    titleLabel.font = [UIFont systemFontOfSize:16.f];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [view addSubview:titleLabel];
    
    UILabel *valueLabel =[[UILabel alloc] initWithFrame:CGRectMake(85, 0,200 ,cell.frame.size.height)];
    valueLabel.tag = 1000;
    valueLabel.textAlignment = NSTextAlignmentRight;
    [valueLabel setBackgroundColor:[UIColor clearColor]];
    [valueLabel setTextColor:[UIColor grayColor]];
    [valueLabel setFont:[UIFont systemFontOfSize:16]];
    
    if(passwordIsModified&&indexPath.row == 2) {
        valueLabel.text = NSLocalizedString(@"password.is.modified", @"");
    } else {
        valueLabel.text = [values objectAtIndex:indexPath.row];
    }

    [view addSubview:valueLabel];
    
    view.tag = 999;
    return view;
}

- (void)delayProcess {
    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"processing", @"") forType:AlertViewTypeWaitting];
    [[AlertView currentAlertView] alertAutoDisappear:NO lockView:self.view];
    
    DeviceCommandUpdateAccount *command = (DeviceCommandUpdateAccount *)[CommandFactory commandForType:CommandTypeUpdateAccount];
    command.email = [infoDictionary objectForKey:NSLocalizedString(@"mail", @"")];
    command.screenName = [infoDictionary objectForKey:NSLocalizedString(@"nick_name", @"")];
    command.pwdToUpdate = [infoDictionary objectForKey:NSLocalizedString(@"modify_pwd", @"")];
    command.oldPwd = password;
    [[SMShared current].deliveryService executeDeviceCommand:command];
    [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(delayDimiss) userInfo:nil repeats:NO];
}

- (void)delayDimiss {
    if ([AlertView currentAlertView].alertViewState != AlertViewStateReady) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"unknow_error", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] delayDismissAlertView];
    }
}
    
- (void)didEndUpdateAccount:(DeviceCommand *)command {
    if (command == nil) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"unknow_error", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] delayDismissAlertView];
        return;
    }

    switch (command.resultID) {
        case 1:
            [[AlertView currentAlertView] setMessage:NSLocalizedString(@"update_success", @"") forType:AlertViewTypeSuccess];
            [[AlertView currentAlertView] delayDismissAlertView];
            [self updateScreenName];
            [infoTable reloadData];
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

- (void)updateScreenName {
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    editCell = [tableView cellForRowAtIndexPath:indexPath];
    editIndex = indexPath;
    ModifyInfoViewController *modifyView = [[ModifyInfoViewController alloc] initWithKey:[titles objectAtIndex:indexPath.row] forValue:[values objectAtIndex:indexPath.row] from:self];
    modifyView.textDelegate = self;
    [self presentViewController:modifyView animated:YES completion:nil];
}

- (void)textViewHasBeenSetting:(NSString *)string {
    if ([[titles objectAtIndex:editIndex.row] isEqualToString:NSLocalizedString(@"modify_pwd", @"")]) {
        if(![NSString isBlank:string]) {
            passwordIsModified = YES;
            [editCell.contentView addSubview:[self viewInCellAtIndexPath:editIndex of:editCell]];
        }
    } else {
        [values setObject:string atIndexedSubscript:editIndex.row];
        [editCell.contentView addSubview:[self viewInCellAtIndexPath:editIndex of:editCell]];
    }
    [infoDictionary setValue:string forKey:[titles objectAtIndex:editIndex.row]];
}

- (void)updateAccount:(DeviceCommandUpdateAccount *)updateCommand {
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

- (void)backToPreViewController {
    [[SMShared current].memory unSubscribeHandler:[DeviceCommandGetAccountHandler class] for:self];
    [[SMShared current].memory unSubscribeHandler:[DeviceCommandUpdateAccountHandler class] for:self];
    [super backToPreViewController];
}

@end
