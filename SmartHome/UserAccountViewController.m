//
//  UserAccountViewController.m
//  SmartHome
//
//  Created by hadoop user account on 2/09/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "UserAccountViewController.h"
#import "CommandFactory.h"
#import "DeviceCommandUpdateAccountHandler.h"
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

-(void) initDefaults{
    [super initDefaults];
    password = @"123456";
    values = [[NSMutableArray alloc]initWithObjects:@"哎哟我去",@"330195612@qq.com",@"",nil];
    titles = [[NSArray alloc] initWithObjects:NSLocalizedString(@"nick.name", @""),NSLocalizedString(@"user.email", @""),NSLocalizedString(@"modify.password", @""), nil];
    if (infoDictionary == nil) {
        infoDictionary = [[NSMutableDictionary alloc] initWithObjects:values forKeys:titles];
    }
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

    [[SMShared current].deliveryService executeDeviceCommand:[CommandFactory commandForType:CommandTypeGetAccount]];
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
    return  3;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellIdentifier;
    if (indexPath.row == 0) {
        cellIdentifier = @"topCellIdentifier";
    }else if (indexPath.row == 2){
        cellIdentifier = @"bottomCellIdentifier";
    }else{
        cellIdentifier = @"cellIdentifier";
    }
    UITableViewCell *result = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(result == nil){
        result = [[SMCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        result.textLabel.text = [[titles objectAtIndex:indexPath.row] stringByAppendingFormat:@"  %@",[values objectAtIndex:indexPath.row]];
        UIImageView *accessory = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"accessory.png"]];
        accessory.frame = CGRectMake(0, 0, 12/2, 23/2);
        result.accessoryView = accessory; 
    }
    return result;
}
-(void) btnDownPressed:(id) sender{
    [checkPassword show];
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSString *inputPassword = [alertView textFieldAtIndex:0].text;
        
        [NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(delayAlert) userInfo:nil repeats:NO];
//        if ([inputPassword isEqualToString:password]) {
////            checkPassword.hidden = YES;
//            [[AlertView currentAlertView] setMessage:@"修改成功" forType:AlertViewTypeSuccess];
//            [[AlertView currentAlertView] alertAutoDisappear:YES lockView:nil];
//        }else{
//            
//        }
    }
}

- (void)delayAlert {
    [[AlertView currentAlertView] setMessage:@"处理中" forType:AlertViewTypeWaitting];
    [[AlertView currentAlertView] alertAutoDisappear:NO lockView:self.view];
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
            [values setObject:string atIndexedSubscript:editIndex.row];
                    editCell.textLabel.text = [[titles objectAtIndex:editIndex.row] stringByAppendingFormat:@" %@",@"已更改"];
        }
    }else{
        [values setObject:string atIndexedSubscript:editIndex.row];
        editCell.textLabel.text = [[titles objectAtIndex:editIndex.row] stringByAppendingFormat:@" %@",string];
    }
}

-(void) dealloc{
    NSLog(@"ffff");
    [[SMShared current].memory unSubscribeHandler:[DeviceCommandUpdateAccountHandler class] for:self];
}

@end
