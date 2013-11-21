//
//  UnitDetailsViewController.m
//  SmartHome
//
//  Created by hadoop user account on 13/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "UnitDetailsViewController.h"
#import "SMCell.h"
#import "UIColor+ExtentionForHexString.h"
#import "SMDateFormatter.h"
#import "ZoneDetailsViewController.h"
#import "ViewsPool.h"
#import "NavigationView.h"

@interface UnitDetailsViewController ()

@end

@implementation UnitDetailsViewController{
    UITableView *tblUnit;
    Unit *unit;
    NSTimer *timeoutTimer;
    NSString *tempUnitName;
}

@synthesize unitIdentifier;

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

- (void)initUI{
    [super initUI];
    
    self.topbar.titleLabel.text = NSLocalizedString(@"unit_detail", @"");
    
    if(tblUnit == nil) {
        tblUnit = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbar.bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - self.topbar.bounds.size.height) style:UITableViewStyleGrouped];
        tblUnit.backgroundColor = [UIColor clearColor];
        tblUnit.backgroundView = nil;
        tblUnit.sectionFooterHeight = 0;
        tblUnit.sectionHeaderHeight = 0;
        tblUnit.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 5)];
        tblUnit.delegate = self;
        tblUnit.dataSource = self;
        [self.view addSubview:tblUnit];
    }
}

- (void)initDefaults {
    unit = [[SMShared current].memory findUnitByIdentifier:unitIdentifier];
    
    // subscribe events
    [[SMShared current].memory subscribeHandler:[DeviceCommandUpdateUnitNameHandler class] for:self];
}

- (void)backToPreViewController {
    // unsubscribe events
    [[SMShared current].memory unSubscribeHandler:[DeviceCommandUpdateUnitNameHandler class] for:self];
    
    [super backToPreViewController];
}

#pragma mark -
#pragma mark table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0) return 5;
    return (unit == nil ? 0 : (unit.zones == nil ? 0 : unit.zones.count));
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SM_CELL_WIDTH / 2, 45)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(12, 15, 200, 30)];
    lblTitle.textColor = [UIColor lightGrayColor];
    lblTitle.font = [UIFont systemFontOfSize:16.f];
    lblTitle.backgroundColor = [UIColor clearColor];
    [view addSubview:lblTitle];
    if(section == 0) {
        lblTitle.text = NSLocalizedString(@"unit_info", @"");
    } else {
        if(unit.zones.count > 0) {
            lblTitle.text = NSLocalizedString(@"zone_info", @"");
        }
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 45;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
   
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView.backgroundColor = [UIColor lightGrayColor];
        
        if(![UIDevice systemVersionIsMoreThanOrEuqal7]) {
            cell.textLabel.font = [UIFont systemFontOfSize:16.f];
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        }
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            cell.textLabel.text = NSLocalizedString(@"unit_name", @"");
            cell.detailTextLabel.text = unit == nil ? [NSString emptyString] : [NSString stringWithFormat:@"%@   ", unit.name];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else if(indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"unit_address", @"");
            cell.detailTextLabel.text = unit == nil ? [NSString emptyString] : unit.localIP;
        } else if(indexPath.row == 2) {
            cell.textLabel.text = NSLocalizedString(@"unit_state", @"");
            cell.detailTextLabel.text = unit == nil ? [NSString emptyString] : ([NSString isBlank:unit.status]?NSLocalizedString(@"online", @""):unit.status);
        } else if(indexPath.row == 3) {
            cell.textLabel.text = NSLocalizedString(@"unit_devices_count", @"");
            cell.detailTextLabel.text = unit == nil ? [NSString emptyString] : [NSString stringWithFormat:@"%d", unit.devices.count];
        } else if(indexPath.row == 4) {
            cell.detailTextLabel.text = unit == nil ? [NSString emptyString] : [SMDateFormatter dateToString:unit.updateTime format:@"MM-dd HH:mm"];
            cell.textLabel.text = NSLocalizedString(@"unit_lastupdate_time", @"");
        }
    } else if(indexPath.section == 1) {
        if(unit.zones != nil) {
            Zone *zone = [unit.zones objectAtIndex:indexPath.row];
            cell.textLabel.text = [NSString stringWithFormat:@"%@  (%d)", zone.name, zone.devices == nil ? 0 : zone.devices.count];
            cell.detailTextLabel.text = @"";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(unit == nil) return;
    if(indexPath.section == 0 && indexPath.row == 0) {
        ModifyInfoViewController *textModifyView = [[ModifyInfoViewController alloc] initWithKey:NSLocalizedString(@"change_unit_name", @"") forValue:unit == nil ? [NSString emptyString] : unit.name from:self];
        textModifyView.textDelegate = self;
        [self presentViewController:textModifyView animated:YES completion:nil];
    } else if(indexPath.section == 1) {
        ZoneDetailsViewController *zoneDetailViewController = [[ZoneDetailsViewController alloc] init];
        if(unit.zones != nil) {
            zoneDetailViewController.zone = [unit.zones objectAtIndex:indexPath.row];
            zoneDetailViewController.title = zoneDetailViewController.zone.name;
        }
        [self.navigationController pushViewController:zoneDetailViewController animated:YES];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Change unit name

- (void)textViewHasBeenSetting:(NSString *)string {
    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"processing", @"") forType:AlertViewTypeWaitting];
    [[AlertView currentAlertView] alertAutoDisappear:NO lockView:self.view];
    timeoutTimer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(closeAlertViewWithError) userInfo:nil repeats:NO];
    
    // Execute update unit name command
    if ([self handleNetworkException]) {
        DeviceCommandUpdateUnitName *cmd = (DeviceCommandUpdateUnitName *)[CommandFactory commandForType:CommandTypeUpdateUnitName];
        unit.name = string;
        cmd.masterDeviceCode = unit.identifier;
        cmd.name = string;
        [[SMShared current].deliveryService executeDeviceCommand:cmd];

    }
    tempUnitName = string;
}

- (void)updateUnitNameOnCompleted:(DeviceCommand *)command {
    @synchronized(self) {
        [timeoutTimer invalidate];
        timeoutTimer = nil;
        
        if(command.resultID == 1) {
            [[AlertView currentAlertView] setMessage:NSLocalizedString(@"update_success", @"") forType:AlertViewTypeSuccess];
            [[AlertView currentAlertView] delayDismissAlertView];
            unit.name = tempUnitName;
            UITableViewCell *cell = [tblUnit cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
            if(cell) {
                UILabel *lblTitle = (UILabel *)[cell viewWithTag:888];
                lblTitle.text = tempUnitName;
            }
            NavigationView *myDevicesView = (NavigationView *)[[ViewsPool sharedPool] viewWithIdentifier:@"myDevicesView"];
            if(myDevicesView != nil) {
                [myDevicesView notifyViewUpdate];
            }
        } else {
            [[AlertView currentAlertView] setMessage:NSLocalizedString(@"execution_failed", @"") forType:AlertViewTypeFailed];
            [[AlertView currentAlertView] delayDismissAlertView];
        }
    
        tempUnitName = [NSString emptyString];
    }
}

- (void)closeAlertViewWithError {
    @synchronized(self) {
        if ([AlertView currentAlertView].alertViewState != AlertViewStateReady) {
            [[AlertView currentAlertView] setMessage:NSLocalizedString(@"request_timeout", @"") forType:AlertViewTypeFailed];
            [[AlertView currentAlertView] delayDismissAlertView];
        }
    }
}

- (BOOL)handleNetworkException {
    if ([[SMShared current].deliveryService.tcpService isConnectted]) {
        return YES;
    }else{
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"offline", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] delayDismissAlertView];
        return NO;
    }
}

@end
