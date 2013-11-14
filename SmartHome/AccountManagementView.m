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
#define BTN_MARGIN 30
#define BTN_HEIGHT 49
#define BTN_WIDTH 101.5
@implementation AccountManagementView{
    UITableView *tblUnits;
    NSString *curUnitIdentifier;
    NSArray *unitBindingAccounts;
    User *selectedUser;
    UIView *buttonPanelView;
    UIButton *btnMsg;
    UIButton *btnPhone;
    UIButton *btnUnbinding;
    
    UserManagementService *userManagementService;
    
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
        buttonPanelView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, self.frame.size.width-10, BTN_HEIGHT)];
        buttonPanelView.backgroundColor = [UIColor clearColor];
        buttonPanelView.hidden = YES;
        [self addSubview:buttonPanelView];
        
        if (btnMsg == nil) {
            btnMsg = [[UIButton alloc] initWithFrame:CGRectMake(10, 5,BTN_WIDTH , BTN_HEIGHT)];
            [btnMsg setBackgroundImage:[UIImage imageNamed:@"button_cf.png"] forState:UIControlStateNormal];
            [btnMsg setTitle:NSLocalizedString(@"send.message", @"") forState:UIControlStateNormal];
            [buttonPanelView addSubview:btnMsg];
        }
        
        if (btnPhone == nil) {
            btnPhone = [[UIButton alloc] initWithFrame:CGRectMake(btnMsg.frame.origin.x+BTN_WIDTH+BTN_MARGIN, 5,BTN_WIDTH , BTN_HEIGHT)];
            [btnPhone setBackgroundImage:[UIImage imageNamed:@"button_cf.png"] forState:UIControlStateNormal];
            [btnPhone setTitle:NSLocalizedString(@"call.phoneNumber", @"") forState:UIControlStateNormal];
            [buttonPanelView addSubview:btnPhone];
        }
        
        if (btnUnbinding == nil) {
            btnUnbinding = [[UIButton alloc] initWithFrame:CGRectMake(btnPhone.frame.origin.x+BTN_WIDTH+BTN_MARGIN, 5,BTN_WIDTH , BTN_HEIGHT)];
            [btnUnbinding setBackgroundImage:[UIImage imageNamed:@"button_cf.png"] forState:UIControlStateNormal];
            [btnUnbinding setTitle:NSLocalizedString(@"unbinding", @"") forState:UIControlStateNormal];
            [buttonPanelView addSubview:btnUnbinding];
        }

        
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
    static NSString *topCellIdentifier = @"topCellIdentifier";
    static NSString *centerCellIdentifier = @"cellIdentifier";
    static NSString *bottomCellIdentifier = @"bottomCellIdentifier";
    static NSString *singleCellIdentifier = @"singleCellIdentifier";
    
    NSString *cellIdentifier;
    if(indexPath.row == 0 && unitBindingAccounts.count == 1) {
        cellIdentifier = singleCellIdentifier;
    } else if(indexPath.row == 0) {
        cellIdentifier = topCellIdentifier;
    } else if(indexPath.row == unitBindingAccounts.count - 1) {
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
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:999];
    UILabel *detailLabel = (UILabel *)[cell viewWithTag:888];
    
//    Unit *unit = [[SMShared current].memory findUnitByIdentifier:[unitsIdentifierCollection objectAtIndex:indexPath.row]];
//    
//    if(unit != nil) {
//        titleLabel.text = unit.name;
//        detailLabel.text = [NSString stringWithFormat:@"%@   ", [NSString isBlank:unit.status] ? NSLocalizedString(@"online", @"") : unit.status];
//    }
//    
//    if(unitsIdentifierCollection.count == 1) {
//        cell.isSingle = YES;
//    }
    
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    selectedUser = [unitBindingAccounts objectAtIndex:indexPath.row];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [UIView animateWithDuration:0.5 animations:^{
        cell.center = CGPointMake(cell.center.x, cell.center.y+BTN_HEIGHT);
    } completion:nil];
}

#pragma mark
#pragma mark- alertview delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1023&& buttonIndex == 0) {
//        [userManagementService ]
        [userManagementService unBindUnit:curUnitIdentifier forUser:selectedUser.identifier success:@selector(unbindingSuccess:) failed:@selector(unbindingFailed:) target:self callback:nil];
    }
}

- (void)notifyViewUpdate {
    curUnitIdentifier = [SMShared current].memory.currentUnit.identifier;
    [userManagementService usersForUnit:curUnitIdentifier success:@selector(getUsersForUnitSuccess:) failed:@selector(getUsersForUnitFailed:) target:self callback:nil];
    [tblUnits reloadData];
}

#pragma mark
#pragma mark- handle success and failed 

- (void)getUsersForUnitSuccess:(RestResponse *) resp{
    if (resp&&resp.statusCode == 200) {
        NSString *json = [[NSString alloc] initWithData:resp.body encoding:NSUTF8StringEncoding];
        NSLog(@"users json%@",json);
        return;
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
