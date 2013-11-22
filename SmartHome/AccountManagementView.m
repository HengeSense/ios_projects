//
//  AccountManagementView.m
//  SmartHome
//
//  Created by Zhao yang on 11/14/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "AccountManagementView.h"
#import "Users.h"
#import "AccountManageCellData.h"
#import "UserManagementService.h"
#import "SystemService.h"
#import "UIView+Extensions.h"
#import "AlertView.h"

#define BTN_MARGIN 35
#define BTN_WIDTH 41/2
#define BTN_HEIGHT 41/2
@implementation AccountManagementView{
    UITableView *tblUnits;
    NSString *curUnitIdentifier;
    NSMutableArray *unitBindingAccounts;
    
    User *selectedUser;
    NSIndexPath *curIndexPath;
    
    UIView *buttonPanelView;
    UIButton *btnMsg;
    UIButton *btnPhone;
    UIButton *btnUnbinding;
    
    UserManagementService *userManagementService;
    
    BOOL buttonPanelViewIsVisable;
    BOOL currentIsOwner;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [super initDefaults];
        [self initUI];
    }
    return self;
}
- (void)initDefaults{
    [super initDefaults];
    buttonPanelViewIsVisable = NO;
    if (userManagementService == nil) {
        userManagementService = [[UserManagementService alloc] init];
    }
    
    if (unitBindingAccounts == nil) {
        unitBindingAccounts = [NSMutableArray array];
    }
    
}
- (void)initUI{
    [super initUI];
    if(tblUnits == nil) {
        tblUnits = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbar.bounds.size.height+5, self.bounds.size.width, self.frame.size.height - self.topbar.bounds.size.height-5) style:UITableViewStylePlain];
        tblUnits.center = CGPointMake(self.center.x, tblUnits.center.y);
        tblUnits.delegate = self;
        tblUnits.separatorStyle = UITableViewCellSeparatorStyleNone;
        tblUnits.dataSource = self;
        tblUnits.backgroundColor = [UIColor clearColor];
        [self addSubview:tblUnits];
    }
    
    if (buttonPanelView == nil) {
        buttonPanelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,SM_CELL_WIDTH/2, SM_CELL_HEIGHT/2)];
        buttonPanelView.backgroundColor = [UIColor clearColor];
        if (btnMsg == nil) {
            btnMsg = [[UIButton alloc] initWithFrame:CGRectMake(46, 5,BTN_WIDTH , BTN_HEIGHT)];
            [btnMsg setBackgroundImage:[UIImage imageNamed:@"icon_send_msg.png"] forState:UIControlStateNormal];
            btnMsg.center = CGPointMake(btnMsg.center.x, buttonPanelView.center.y);
            [btnMsg addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
//            [btnMsg setTitle:NSLocalizedString(@"send.message", @"") forState:UIControlStateNormal];
            [buttonPanelView addSubview:btnMsg];
        }
        
        if (btnPhone == nil) {
            btnPhone = [[UIButton alloc] initWithFrame:CGRectMake(btnMsg.frame.origin.x+BTN_WIDTH+BTN_MARGIN, 5,BTN_WIDTH , BTN_HEIGHT)];
            [btnPhone setBackgroundImage:[UIImage imageNamed:@"icon_dial_phone.png"] forState:UIControlStateNormal];
            btnPhone.center = CGPointMake(btnPhone.center.x,buttonPanelView.center.y);
//            [btnPhone setTitle:NSLocalizedString(@"call.phoneNumber", @"") forState:UIControlStateNormal];
            [btnPhone addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [buttonPanelView addSubview:btnPhone];
        }
//
        if (btnUnbinding == nil) {
            btnUnbinding = [[UIButton alloc] initWithFrame:CGRectMake(btnPhone.frame.origin.x+BTN_WIDTH+BTN_MARGIN, 5,BTN_WIDTH , BTN_HEIGHT)];
            [btnUnbinding setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btnUnbinding.titleLabel.font = [UIFont systemFontOfSize:14];
            [btnUnbinding setBackgroundImage:[UIImage imageNamed:@"unbinding.png"] forState:UIControlStateNormal];
//            [btnUnbinding setTitle:NSLocalizedString(@"unbinding", @"") forState:UIControlStateNormal];
            btnUnbinding.center = CGPointMake(btnUnbinding.center.x, buttonPanelView.center.y);
            [btnUnbinding addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [buttonPanelView addSubview:btnUnbinding];
        }

        
    }


    
    
}
- (void) addPanelData:(AccountManageCellData *) data{
    if (!unitBindingAccounts) {
        return;
    }
    [unitBindingAccounts insertObject:data atIndex:curIndexPath.row+1];
}
- (void) removePanelData{
    if (!unitBindingAccounts||unitBindingAccounts.count<=curIndexPath.row+1) {
        return;
    }
    [unitBindingAccounts removeObjectAtIndex:curIndexPath.row+1];
}
-(void)showButton{
    AccountManageCellData *data = (AccountManageCellData *)[unitBindingAccounts objectAtIndex:curIndexPath.row];
    User *user = data.user;
    if (user == nil) {
        return;
    }
    btnMsg.hidden = NO;
    btnPhone.hidden = NO;
    btnUnbinding.hidden = NO;
    if (user.isCurrentUser) {
        btnMsg.hidden = YES;
        btnPhone.hidden = YES;
        if (user.isOwner) {
            btnUnbinding.hidden = YES;
        }
    }else{
        if (!currentIsOwner) {
            btnUnbinding.hidden = YES;
        }
    }
    if (buttonPanelView.superview) {
        [buttonPanelView removeFromSuperview];
    }
}
#pragma mark
#pragma mark- btn events
- (void)btnPressed:(UIButton *) sender{
    
    if ([sender isEqual:btnMsg]) {
        [SystemService messageToMobile:selectedUser.mobile withMessage:nil];
    } else if ([sender isEqual:btnPhone]){
        [SystemService dialToMobile:selectedUser.mobile];
    }else if ([sender isEqual:btnUnbinding]){
        UIAlertView  *confirmAlertView = [[UIAlertView alloc]initWithTitle:NSLocalizedString(@"tips", @"") message:[NSString stringWithFormat: NSLocalizedString(@"confirm.unbinding", @""),selectedUser.name,[SMShared current].memory.currentUnit.name]delegate:self cancelButtonTitle:NSLocalizedString(@"determine", @"") otherButtonTitles:NSLocalizedString(@"cancel", @""), nil];
        confirmAlertView.tag = 1023;
        [confirmAlertView dismissWithClickedButtonIndex:1 animated:YES];
        [confirmAlertView show];
    }
}

#pragma mark
#pragma mark- table delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return unitBindingAccounts == nil ? 0 : unitBindingAccounts.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    return SM_CELL_HEIGHT/2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *userCellIdentifier = @"userCellIdentifier";
    static NSString *panelCellIdentifier = @"panelIdentifier";
//    static NSString *bottomCellIdentifier = @"bottomCellIdentifier";
//    static NSString *singleCellIdentifier = @"singleCellIdentifier";
//    static NSString *centerPanelIdentifier = @"centerPanelIdentifier";
//    static NSString *bottomPanelIdentifier = @"bottomPanelIdentifier";
    
    
    
    NSString *cellIdentifier;
    AccountManageCellData *data = [unitBindingAccounts objectAtIndex:indexPath.row];
    
    if (data.isPanel) {
        cellIdentifier = panelCellIdentifier;
    }else{
        cellIdentifier = userCellIdentifier;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        //            cell = [[ButtonPanelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier needFixed:NO];
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor whiteColor];
        UIView *separatorLineView = [[UIImageView alloc] initWithFrame:CGRectMake(46, SM_CELL_HEIGHT / 2 - 0.5, cell.bounds.size.width, 0.5)];
        separatorLineView.backgroundColor = [UIColor lightGrayColor];
        separatorLineView.alpha = 0.5;
        [cell addSubview:separatorLineView];
        cell.textLabel.font = [UIFont systemFontOfSize:15.f];
        
        if(![UIDevice systemVersionIsMoreThanOrEuqal7]) {
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        }
        
        if (!data.isPanel) {
            
        }
    }
    if (data.isPanel) {
//        ButtonPanelCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        [self showButton];
        [cell addSubview:buttonPanelView];
        
    }else{
//        SMCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        User  *user  = data.user;
        if(user != nil) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@(%@)" ,user.name,user.mobile];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@   ", [user stringForUserState]];
            
            if (user.isCurrentUser) {
                if (user.isOwner) {
                    cell.imageView.image = [UIImage imageNamed:@"icon_me_owner.png"];
                }else{
                    cell.imageView.image = [UIImage imageNamed:@"icon_me.png"];
                }
            }else{
                if (user.isOwner) {
                    cell.imageView.image = [UIImage imageNamed:@"icon_owner.png"];
                }else{
                    cell.imageView.image = [UIImage imageNamed:@"transparent.png"];
                }
            }
        }
        
//        if(unitBindingAccounts.count == 1) {
//            cell.isSingle = YES;
//        }
//
//        cell.accessoryViewVisible = YES;

    }

    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<unitBindingAccounts.count) {
        AccountManageCellData *selectData = (AccountManageCellData *)[unitBindingAccounts objectAtIndex:indexPath.row];
        if (selectData.isPanel) {
            return;
        }
        selectedUser = selectData.user;
        if (selectedUser.isOwner&&selectedUser.isCurrentUser) {
            return;
        }
    }else{
        return;
    }
    if (!buttonPanelViewIsVisable) {
        [self showButtonPanelViewAtIndexPath:indexPath];
    }else {
        if (![curIndexPath isEqual:indexPath]&&curIndexPath.row!=indexPath.row-1) {
            [self hideButtonPanelView];

            if (curIndexPath.row+1<indexPath.row) {
                [self showButtonPanelViewAtIndexPath:[NSIndexPath indexPathForRow:unitBindingAccounts.count-1>=indexPath.row?indexPath.row-1:unitBindingAccounts.count-1 inSection:0]];
            }else{
                [self showButtonPanelViewAtIndexPath:[NSIndexPath indexPathForRow:unitBindingAccounts.count-1>=indexPath.row+1?indexPath.row:unitBindingAccounts.count-1 inSection:0]];
            }
            
        }
        
    }
    
}
- (void)showButtonPanelViewAtIndexPath:(NSIndexPath *) indexPath{
    buttonPanelViewIsVisable = YES;
    curIndexPath = indexPath;
    AccountManageCellData *data = [[AccountManageCellData alloc] init];
    data.isPanel = YES;
    [self addPanelData:data];
    [tblUnits beginUpdates];
    [tblUnits insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [tblUnits endUpdates];
    

}
- (void)hideButtonPanelView{
    buttonPanelViewIsVisable = NO;
    [self removePanelData];
    [tblUnits beginUpdates];
    [tblUnits deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:curIndexPath.row+1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    [tblUnits endUpdates];

}
#pragma mark
#pragma mark- alertview delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1023&& buttonIndex == 0) {
        [self hideButtonPanelView];
        [NSTimer scheduledTimerWithTimeInterval:0.6f target:self selector:@selector(delayProcess) userInfo:nil repeats:NO];
    }
}
- (void)delayProcess{
    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"processing", @"") forType:AlertViewTypeWaitting];
    [[AlertView currentAlertView] alertAutoDisappear:NO lockView:self];
    [userManagementService unBindUnit:curUnitIdentifier forUser:selectedUser.identifier success:@selector(unbindingSuccess:) failed:@selector(unbindingFailed:) target:self callback:nil];
}
- (void)notifyViewUpdate {
    if (buttonPanelViewIsVisable) {
        [self hideButtonPanelView];
    }
    if (unitBindingAccounts) {
        [unitBindingAccounts removeAllObjects];
        [tblUnits reloadData];
    }
    curUnitIdentifier = [SMShared current].memory.currentUnit.identifier;

    if(![NSString isBlank:curUnitIdentifier]){
        [userManagementService usersForUnit:curUnitIdentifier success:@selector(getUsersForUnitSuccess:) failed:@selector(getUsersForUnitFailed:) target:self callback:nil];
    }
}

#pragma mark
#pragma mark- handle success and failed 

- (void)getUsersForUnitSuccess:(RestResponse *) resp{
    if (resp&&resp.statusCode == 200) {

        NSArray *usersJson = [JsonUtils createDictionaryFromJson:resp.body];
        if(usersJson != nil) {
            Users *users = [[Users alloc] initWithJson:[NSDictionary dictionaryWithObject:usersJson forKey:@"users"]];
            for (User *user in users.users) {
                AccountManageCellData *cellData = [[AccountManageCellData alloc] init];
                cellData.user = user;
                cellData.isPanel = NO;
                [unitBindingAccounts addObject:cellData];
            }
            currentIsOwner = NO;
            for (AccountManageCellData *data in unitBindingAccounts) {
                if (data.user.isOwner&&data.user.isCurrentUser) {
                    currentIsOwner = YES;
                    break;
                }
            }
            // do some thing here ...
            [tblUnits reloadData];
            return;
        }
    }
    [self getUsersForUnitFailed:resp];
}

- (void)getUsersForUnitFailed:(RestResponse *) resp{
    if(resp != nil && abs(resp.statusCode) == 1001) {
        // 超时处理
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"request_timeout", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] alertAutoDisappear:YES lockView:nil];
        return;
    } else {
        // Error
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"unknow_error", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] alertAutoDisappear:YES lockView:nil];
    }
}

- (void)unbindingSuccess:(RestResponse *) resp{
    if (resp&&resp.statusCode == 200) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"execution_success", @"") forType:AlertViewTypeSuccess];
        [[AlertView currentAlertView] delayDismissAlertView];
        if (selectedUser.isCurrentUser) {
            [[SMShared current].deliveryService executeDeviceCommand:[CommandFactory commandForType:CommandTypeGetUnits]];
            [self.ownerController changeDrawerItemWithViewIdentifier:@"mainView"];
        }
        return;
    }
    [self unbindingFailed:resp];
}
- (void)unbindingFailed:(RestResponse *) resp{
    if(resp != nil && abs(resp.statusCode) == 1001) {
        // 超时处理
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"request_timeout", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] delayDismissAlertView];
        return;
    } else {
        // Error
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"unknow_error", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] delayDismissAlertView];
    }
}
- (void)destory {

#ifdef DEBUG
    NSLog(@"AccountManagement View] Destoryed.");
#endif
}


@end
