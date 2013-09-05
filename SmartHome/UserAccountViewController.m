//
//  UserAccountViewController.m
//  SmartHome
//
//  Created by hadoop user account on 2/09/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "UserAccountViewController.h"
#import "CommandFactory.h"
#import "DeviceCommandUpdateAccount.h"

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
    BOOL passwordIsModified;
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
    [[SMShared current].deliveryService executeDeviceCommand:[CommandFactory commandForType:CommandTypeGetAccount]];
}

- (void)viewDidAppear:(BOOL)animated {
    
}

-(void) initDefaults{
    [super initDefaults];
    NSLog(@"init");
    password = @"123456";
    values = [[NSMutableArray alloc]initWithObjects:@"",@"",@"",nil];
    titles = [[NSArray alloc] initWithObjects:NSLocalizedString(@"nick.name", @""),NSLocalizedString(@"user.email", @""),NSLocalizedString(@"modify.password", @""), nil];
    if (infoDictionary == nil) {
        infoDictionary = [[NSMutableDictionary alloc] initWithObjects:values forKeys:titles];
    }
    [[SMShared current].memory subscribeHandler:[DeviceCommandGetAccountHandler class] for:self];
    [[SMShared current].memory subscribeHandler:[DeviceCommandUpdateAccountHandler class] for:self];
    
}

- (void)initUI{
    [super initUI];
    self.topbar.rightButton = [[UIButton alloc] initWithFrame:CGRectMake(self.topbar.frame.size.width - 101/2 - 8, 8, 101/2, 59/2)];
    [self.topbar addSubview:self.topbar.rightButton];
    [self.topbar.rightButton setBackgroundImage:[UIImage imageNamed:@"btn_done.png"] forState:UIControlStateNormal];
    [self.topbar.rightButton setBackgroundImage:[UIImage imageNamed:@"btn_done.png"] forState:UIControlStateHighlighted];
    [self.topbar.rightButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    [self.topbar.rightButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
    [self.topbar.rightButton setTitle:NSLocalizedString(@"done", @"") forState:UIControlStateNormal];
    self.topbar.rightButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [self.topbar.rightButton addTarget:self action:@selector(btnDownPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    if (infoTable == nil) {
        infoTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbar.frame.size.height+5, SM_CELL_WIDTH/2, self.view.frame.size.height - self.topbar.bounds.size.height - 5) style:UITableViewStylePlain];
        infoTable.center = self.view.center;
        infoTable.delegate = self;
        infoTable.dataSource =self;
        infoTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        infoTable.backgroundColor = [UIColor clearColor];
        [self.view addSubview:infoTable];
    }
    if(checkPassword == nil){
        checkPassword = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"password.valid", @"") message:NSLocalizedString(@"please.input.old.password", @"") delegate:self cancelButtonTitle:NSLocalizedString(@"cancel", @"") otherButtonTitles:NSLocalizedString(@"ok", @""), nil];
        [checkPassword setAlertViewStyle:UIAlertViewStyleSecureTextInput];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(values == nil) return 0;
    return titles.count;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
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

-(void) btnDownPressed:(id) sender{
    [checkPassword show];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        password = [alertView textFieldAtIndex:0].text;
        [NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(delayProcess) userInfo:nil repeats:NO];
        
    }
}
-(UIView *) viewInCellAtIndexPath:(NSIndexPath *) indexPath of:(UITableViewCell *) cell{
    NSArray *subViews = cell.contentView.subviews;
    for (UIView *v in subViews) {
        [v removeFromSuperview];
    }
    UIView *view = [[UIView alloc] initWithFrame:cell.contentView.frame];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0,80 , cell.frame.size.height)];
    titleLabel.text = [titles objectAtIndex:indexPath.row];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [view addSubview:titleLabel];
    
    
    UILabel *valueLabel =[[UILabel alloc] initWithFrame:CGRectMake(85, 0,200 ,cell.frame.size.height)];
    valueLabel.tag = 1000;
    valueLabel.textAlignment = UITextAlignmentRight;
    [valueLabel setBackgroundColor:[UIColor clearColor]];
    [valueLabel setTextColor:[UIColor grayColor]];
    [valueLabel setFont:[UIFont systemFontOfSize:16]];
    
    if (passwordIsModified&&indexPath.row == 2) {
        valueLabel.text = NSLocalizedString(@"password.is.modified", @"");
    }else{
            valueLabel.text = [values objectAtIndex:indexPath.row];
    }

    [view addSubview:valueLabel];

    
    UIImageView *accessory = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accessory.png"]];
    accessory.frame = CGRectMake(300, 0, 12/2, 23/2);
    accessory.center = CGPointMake(accessory.center.x, cell.center.y);
    [view addSubview:accessory];
    view.tag = 999;
    return  view;

}
- (void)delayProcess {
    [[AlertView currentAlertView] setMessage:@"处理中" forType:AlertViewTypeWaitting];
    [[AlertView currentAlertView] alertAutoDisappear:NO lockView:self.view];
    
    DeviceCommandUpdateAccount *command = (DeviceCommandUpdateAccount *)[CommandFactory commandForType:CommandTypeUpdateAccount];
    command.email = [infoDictionary objectForKey:NSLocalizedString(@"user.email", @"")];
    command.screenName = [infoDictionary objectForKey:NSLocalizedString(@"nick.name", @"")];
    command.pwdToUpdate = [infoDictionary objectForKey:NSLocalizedString(@"modify.password", @"")];
    command.oldPwd = password;
    [[SMShared current].deliveryService executeDeviceCommand:command];
}

    
-(void) didEndUpdateAccount:(DeviceCommand *)command{
    
    if (command == nil) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"update.success", @"") forType:AlertViewTypeSuccess];
        [[AlertView currentAlertView] delayDismissAlertView];
        return;
    }
    switch (command.resultID) {
        case 1:
            [[AlertView currentAlertView] setMessage:NSLocalizedString(@"update.success", @"") forType:AlertViewTypeSuccess];
            [[AlertView currentAlertView] delayDismissAlertView];
            break;
        case -1:
            [[AlertView currentAlertView] setMessage:NSLocalizedString(@"update.password.error", @"") forType:AlertViewTypeFailed];
            [[AlertView currentAlertView] delayDismissAlertView];
        case -2:
            [[AlertView currentAlertView] setMessage:NSLocalizedString(@"blank.nickname.or.email.error", @"") forType:AlertViewTypeFailed];
            [[AlertView currentAlertView] delayDismissAlertView];
        case -3:
            [[AlertView currentAlertView] setMessage:NSLocalizedString(@"request.format.error", @"") forType:AlertViewTypeFailed];
            [[AlertView currentAlertView] delayDismissAlertView];
        case -4:
            [[AlertView currentAlertView] setMessage:NSLocalizedString(@"request.too.frequent.error", @"") forType:AlertViewTypeFailed];
            [[AlertView currentAlertView] delayDismissAlertView];

        default:
            break;
    }
    
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    editCell = [tableView cellForRowAtIndexPath:indexPath];
    editIndex = indexPath;
    
    ModifyInfoViewController *modifyView = [[ModifyInfoViewController alloc] initWithKey:[titles objectAtIndex:indexPath.row] forValue:[values objectAtIndex:indexPath.row] from:self];
    modifyView.textDelegate = self;
    [self presentModalViewController:modifyView animated:YES];
    
}

-(void) textViewHasBeenSetting:(NSString *)string{
    if ([[titles objectAtIndex:editIndex.row] isEqualToString:NSLocalizedString(@"modify.password", @"")]) {
        
        if (string !=nil&&![@"" isEqualToString:string]) {
            passwordIsModified = YES;
            [editCell.contentView addSubview:[self viewInCellAtIndexPath:editIndex of:editCell]];
        }
    }else{
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
