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
#import "AlertView.h"
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
            btnUnbinding = [[UIButton alloc] initWithFrame:CGRectMake(btnPhone.frame.origin.x+BTN_WIDTH+BTN_MARGIN, 5,100 , BTN_HEIGHT)];
            [btnUnbinding setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            btnUnbinding.titleLabel.font = [UIFont systemFontOfSize:14];
            [btnUnbinding setTitle:NSLocalizedString(@"unbinding", @"") forState:UIControlStateNormal];
            btnUnbinding.center = CGPointMake(btnUnbinding.center.x, buttonPanelView.center.y);
            [btnUnbinding addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
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
    return unitBindingAccounts == nil ? 0 : unitBindingAccounts.count+(buttonPanelViewIsVisable?1:0);
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
    } else if(indexPath.row == unitBindingAccounts.count - 1+(buttonPanelViewIsVisable?1:0)) {
        cellIdentifier = bottomCellIdentifier;
    } else {
        cellIdentifier = centerCellIdentifier;
    }
    
    SMCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[SMCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10+BTN_WIDTH, 2, BTN_WIDTH, BTN_HEIGHT)];
        imageView.center = CGPointMake(imageView.center.x, cell.center.y);
        imageView.tag = 998;
        [cell addSubview:imageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(61, 2, 100, 40)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:12.f];
        titleLabel.tag = 999;
        [cell addSubview:titleLabel];
        
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIDevice systemVersionIsMoreThanOrEuqal7]? 171  : 181, 2, 100, 40)];
        detailLabel.textAlignment = NSTextAlignmentRight;
        detailLabel.textColor = [UIColor darkGrayColor];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.font = [UIFont systemFontOfSize:12.f];
        detailLabel.tag = 888;
        [cell addSubview:detailLabel];
        
    }
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:999];
    UILabel *detailLabel = (UILabel *)[cell viewWithTag:888];
    UIImageView *imageView = (UIImageView *)[cell viewWithTag:998];
    if (buttonPanelViewIsVisable&&![indexPath isEqual:curIndexPath]) {
        if (imageView) {
            imageView.image = nil;
        }
        if (titleLabel) {
            titleLabel.text = @"";
        }
        if (detailLabel) {
            detailLabel.text = @"";
        }
        [self showButtonAtIndexPath];
        [cell addSubview:buttonPanelView];
    }else{
        User  *user ;
        if (indexPath.row<unitBindingAccounts.count) {
            user = [unitBindingAccounts objectAtIndex:indexPath.row];
        }
        if(user != nil) {
            titleLabel.text = [NSString stringWithFormat:@"%@(%@)" ,user.name,user.mobile];
            detailLabel.text = [NSString stringWithFormat:@"%@   ", [user stringForUserState]];
            
            if (user.isCurrentUser) {
                if (user.isOwner) {
                    imageView.image = [UIImage imageNamed:@"icon_me_owner.png"];
                }else{
                    imageView.image = [UIImage imageNamed:@"icon_me.png"];
                }
            }else{
                if (user.isOwner) {
                    imageView.image = [UIImage imageNamed:@"icon_owner.png"];
                }else{
                    imageView.image = nil;
                }
            }
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
    if (!buttonPanelViewIsVisable) {
        [self showButtonPanelViewAtIndexPath:indexPath];
    }else {
        [self hideButtonPanelView];
    }
    
}
- (void)showButtonPanelViewAtIndexPath:(NSIndexPath *) indexPath{
    buttonPanelViewIsVisable = YES;
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
    buttonPanelViewIsVisable = NO;
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
    if (buttonPanelViewIsVisable) {
        [self hideButtonPanelView];
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
        NSLog(@"%@",[[NSString alloc] initWithData:resp.body encoding:NSUTF8StringEncoding]);
        NSArray *usersJson = [JsonUtils createDictionaryFromJson:resp.body];
        if(usersJson != nil) {
            Users *users = [[Users alloc] initWithJson:[NSDictionary dictionaryWithObject:usersJson forKey:@"users"]];
            unitBindingAccounts = users.users;
            currentIsOwner = NO;
            for (User *u in unitBindingAccounts) {
                if (u.isOwner&&u.isCurrentUser) {
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
        [[SMShared current].memory removeUnitByIdentifier:curUnitIdentifier];
        [self notifyViewUpdate];
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"execution_success", @"") forType:AlertViewTypeSuccess];
        [[AlertView currentAlertView] alertAutoDisappear:YES lockView:nil];
        return;
    }
    [self unbindingFailed:resp];
}
- (void)unbindingFailed:(RestResponse *) resp{
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
- (void)destory {

#ifdef DEBUG
    NSLog(@"AccountManagement View] Destoryed.");
#endif
}


@end
