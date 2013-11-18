//
//  AccountManagementView.m
//  SmartHome
//
//  Created by Zhao yang on 11/14/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "AccountManagementView.h"
#import "Users.h"
#import "UserManagementService.h"
#import "SystemService.h"
#import "UIView+Extensions.h"
#define BTN_MARGIN 35
#define BTN_WIDTH 41/2
#define BTN_HEIGHT 41/2
@implementation AccountManagementView{
    UITableView *tblUnits;
    NSString *curUnitIdentifier;
    NSArray *unitBindingAccounts;
    
    User *selectedUser;
    NSIndexPath *curIndexPath;
    
    UIView *buttonPanelView;
    UIButton *btnMsg;
    UIButton *btnPhone;
    UIButton *btnUnbinding;
    
    UserManagementService *userManagementService;
    
    BOOL allowAddButtonPanelView;
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
    allowAddButtonPanelView = NO;
    if (userManagementService == nil) {
        userManagementService = [[UserManagementService alloc] init];
    }
    
    currentIsOwner = NO;
    for (User *u in unitBindingAccounts) {
        if (u.isOwner&&u.isCurrentUser) {
            currentIsOwner = YES;
            break;
        }
    }
}
- (void)initUI{
    [super initUI];
    
    if(tblUnits == nil) {
        tblUnits = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbar.bounds.size.height + 5, SM_CELL_WIDTH / 2, self.frame.size.height - self.topbar.bounds.size.height - 5) style:UITableViewStylePlain];
        tblUnits.center = CGPointMake(self.center.x, tblUnits.center.y);
        tblUnits.separatorStyle = UITableViewCellSeparatorStyleNone;
        tblUnits.delegate = self;
        tblUnits.dataSource = self;
        tblUnits.backgroundColor = [UIColor clearColor];
        [self addSubview:tblUnits];
    }
    
    if (buttonPanelView == nil) {
        buttonPanelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,SM_CELL_WIDTH/2, SM_CELL_HEIGHT/2)];
        buttonPanelView.backgroundColor = [UIColor clearColor];
        
        if (btnMsg == nil) {
            btnMsg = [[UIButton alloc] initWithFrame:CGRectMake(BTN_MARGIN, 5,BTN_WIDTH , BTN_HEIGHT)];
            [btnMsg setBackgroundImage:[UIImage imageNamed:@"icon_send_msg.png"] forState:UIControlStateNormal];
            btnMsg.center = CGPointMake(btnMsg.center.x, buttonPanelView.center.y);
//            [btnMsg setTitle:NSLocalizedString(@"send.message", @"") forState:UIControlStateNormal];
            [buttonPanelView addSubview:btnMsg];
        }
        
        if (btnPhone == nil) {
            btnPhone = [[UIButton alloc] initWithFrame:CGRectMake(btnMsg.frame.origin.x+BTN_WIDTH+BTN_MARGIN, 5,BTN_WIDTH , BTN_HEIGHT)];
            [btnPhone setBackgroundImage:[UIImage imageNamed:@"icon_dial_phone.png"] forState:UIControlStateNormal];
            btnPhone.center = CGPointMake(btnPhone.center.x,buttonPanelView.center.y);
//            [btnPhone setTitle:NSLocalizedString(@"call.phoneNumber", @"") forState:UIControlStateNormal];
            [buttonPanelView addSubview:btnPhone];
        }
//
        if (btnUnbinding == nil) {
            btnUnbinding = [[UIButton alloc] initWithFrame:CGRectMake(btnPhone.frame.origin.x+BTN_WIDTH+BTN_MARGIN, 5,100 , BTN_HEIGHT)];
            [btnUnbinding setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btnUnbinding.titleLabel.font = [UIFont systemFontOfSize:14];
            [btnUnbinding setTitle:NSLocalizedString(@"unbinding", @"") forState:UIControlStateNormal];
            btnUnbinding.center = CGPointMake(btnUnbinding.center.x, buttonPanelView.center.y);
            [buttonPanelView addSubview:btnUnbinding];
        }

        
    }


    
    
}
-(void)showButtonAtIndexPath{
    User *user = [unitBindingAccounts objectAtIndex:curIndexPath.row];
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
    return unitBindingAccounts == nil ? 0 : unitBindingAccounts.count+(allowAddButtonPanelView?1:0);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SM_CELL_HEIGHT/2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *topCellIdentifier = @"topCellIdentifier";
    static NSString *centerCellIdentifier = @"cellIdentifier";
    static NSString *bottomCellIdentifier = @"bottomCellIdentifier";
    static NSString *singleCellIdentifier = @"singleCellIdentifier";
    
    NSString *cellIdentifier;
    if(indexPath.row == 0 && unitBindingAccounts.count == 1) {
        cellIdentifier = singleCellIdentifier;
    } else if(indexPath.row == 0) {
        cellIdentifier = topCellIdentifier;
    } else if(indexPath.row == unitBindingAccounts.count - 1+(allowAddButtonPanelView?1:0)) {
        cellIdentifier = bottomCellIdentifier;
    } else {
        cellIdentifier = centerCellIdentifier;
    }
    
    SMCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[SMCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 150, 40)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.tag = 999;
        [cell addSubview:titleLabel];
        
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIDevice systemVersionIsMoreThanOrEuqal7] ? 140 : 150, 2, 150, 40)];
        detailLabel.textAlignment = NSTextAlignmentRight;
        detailLabel.textColor = [UIColor darkGrayColor];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.font = [UIFont systemFontOfSize:16.f];
        detailLabel.tag = 888;
        [cell addSubview:detailLabel];
    }
    NSLog(@"%i",!allowAddButtonPanelView||(allowAddButtonPanelView&&indexPath.row == unitBindingAccounts.count-1));
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:999];
    UILabel *detailLabel = (UILabel *)[cell viewWithTag:888];
    if (allowAddButtonPanelView&&![indexPath isEqual:curIndexPath]) {
//        if (indexPath.row == unitBindingAccounts.count-1&&) {
//            UILabel *titleLabel = (UILabel *)[cell viewWithTag:999];
//            UILabel *detailLabel = (UILabel *)[cell viewWithTag:888];
//            User  *user ;
//            if (indexPath.row<unitBindingAccounts.count) {
//                user = [unitBindingAccounts objectAtIndex:indexPath.row];
//            }
//            if(user != nil) {
//                titleLabel.text = [NSString stringWithFormat:@"%@(%@)" ,user.name,user.mobile];
//                detailLabel.text = [NSString stringWithFormat:@"%@   ", [user stringForUserState]];
//            }
//            
//            if(unitBindingAccounts.count == 1) {
//                cell.isSingle = YES;
//            }
//        }else{
        if (titleLabel) {
            titleLabel.text = @"";
        }
        if (detailLabel) {
            detailLabel.text = @"";
        }
//        [self showButtonAtIndexPath];
        [cell addSubview:buttonPanelView];
    }else{
        User  *user ;
        if (indexPath.row<unitBindingAccounts.count) {
            user = [unitBindingAccounts objectAtIndex:indexPath.row];
        }
        if(user != nil) {
            titleLabel.text = [NSString stringWithFormat:@"%@(%@)" ,user.name,user.mobile];
            detailLabel.text = [NSString stringWithFormat:@"%@   ", [user stringForUserState]];
        }
        
        if(unitBindingAccounts.count == 1) {
            cell.isSingle = YES;
        }
        
    }
    cell.accessoryViewVisible = YES;

    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row<unitBindingAccounts.count) {
        selectedUser = [unitBindingAccounts objectAtIndex:indexPath.row];
    }
    if (!allowAddButtonPanelView) {
        [self showButtonPanelViewAtIndexPath:indexPath];
    }else {
        [self hideButtonPanelView];
    }
    
}
- (void)showButtonPanelViewAtIndexPath:(NSIndexPath *) indexPath{
    allowAddButtonPanelView = YES;
    curIndexPath = indexPath;
    if (curIndexPath.row==unitBindingAccounts.count-1) {
        [tblUnits beginUpdates];
        [tblUnits insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
        [tblUnits reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [tblUnits endUpdates];
        return;
    }
    [tblUnits beginUpdates];
    [tblUnits insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0]] withRowAnimation:UITableViewRowAnimationLeft];
    [tblUnits endUpdates];
    

}
- (void)hideButtonPanelView{
    allowAddButtonPanelView = NO;
    if (curIndexPath.row==unitBindingAccounts.count-1) {
        [tblUnits beginUpdates];
        [tblUnits deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:curIndexPath.row+1 inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
        [tblUnits reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:curIndexPath.row inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        [tblUnits endUpdates];
        return;
    }
    [tblUnits beginUpdates];
    [tblUnits deleteRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:curIndexPath.row+1 inSection:0]] withRowAnimation:UITableViewRowAnimationRight];
    [tblUnits endUpdates];

}
#pragma mark
#pragma mark- alertview delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1023&& buttonIndex == 0) {
        [userManagementService unBindUnit:curUnitIdentifier forUser:selectedUser.identifier success:@selector(unbindingSuccess:) failed:@selector(unbindingFailed:) target:self callback:nil];
    }
}

- (void)notifyViewUpdate {
    curUnitIdentifier = [SMShared current].memory.currentUnit.identifier;
    if(curUnitIdentifier){
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
            unitBindingAccounts = users.users;
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
        return;
    } else {
        // Error
    }
}

- (void)unbindingSuccess:(RestResponse *) resp{
    if (resp&&resp.statusCode == 200) {
        NSString *json = [[NSString alloc] initWithData:resp.body encoding:NSUTF8StringEncoding];
        NSLog(@"users json%@",json);
        return;
    }
    [self unbindingFailed:resp];
}
- (void)unbindingFailed:(RestResponse *) resp{
    if(resp != nil && abs(resp.statusCode) == 1001) {
        // 超时处理
        return;
    } else {
        // Error
    }
}
- (void)destory {

#ifdef DEBUG
    NSLog(@"AccountManagement View] Destoryed.");
#endif
}


@end
