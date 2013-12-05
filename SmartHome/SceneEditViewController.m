//
//  SceneEditViewController.m
//  SmartHome
//
//  Created by Zhao yang on 12/2/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "SceneEditViewController.h"
#import "UIColor+ExtentionForHexString.h"
#import "SMActionSheet.h"
#import "ScenePlanDevice.h"
#import "ScenePlanFileManager.h"
#import "SceneManagerService.h"

@interface SceneEditViewController ()

@end

@implementation SceneEditViewController {
    NSString *scenePlanIdentifier;
    UITableView *tblScenePlan;
    ScenePlan *scenePlan;
}

@synthesize unit = _unit_;
@synthesize sceneModeIdentifier;

- (id)initWithSceneIdentifier:(NSString *)sceneIdentifier {
    self = [super init];
    if(self) {
        if([NSString isBlank:sceneIdentifier]) {
            scenePlanIdentifier = [NSString emptyString];
        } else {
            scenePlanIdentifier = sceneIdentifier;
        }
    }
    return self;
}

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
}

- (void)initUI {
    [super initUI];
    
    self.topbar.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(8, [UIDevice systemVersionIsMoreThanOrEuqal7] ? 28 : 8, 101/2, 59/2)];
    [self.topbar addSubview:self.topbar.leftButton];
    [self.topbar.leftButton setBackgroundImage:[UIImage imageNamed:@"btn_done.png"] forState:UIControlStateNormal];
    [self.topbar.leftButton setBackgroundImage:[UIImage imageNamed:@"btn_done.png"] forState:UIControlStateHighlighted];
    [self.topbar.leftButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    [self.topbar.leftButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateHighlighted];
    [self.topbar.leftButton setTitle:NSLocalizedString(@"cancel", @"") forState:UIControlStateNormal];
    self.topbar.leftButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [self.topbar.leftButton addTarget:self action:@selector(closePage:) forControlEvents:UIControlEventTouchUpInside];

    tblScenePlan = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbar.bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - self.topbar.bounds.size.height) style:UITableViewStyleGrouped];
    tblScenePlan.delegate = self;
    tblScenePlan.dataSource = self;
    tblScenePlan.backgroundView = nil;
    tblScenePlan.sectionHeaderHeight = 0;
    tblScenePlan.sectionFooterHeight = 0;
    tblScenePlan.backgroundColor = [UIColor clearColor];
    [self.view addSubview:tblScenePlan];
}

- (void)setUp {
    [super setUp];
}

- (void)dismiss {
    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"saving", @"") forType:AlertViewTypeWaitting];
    [[AlertView currentAlertView] alertAutoDisappear:NO lockView:self.view];
    
    
    SceneManagerService *sceneManagerService = [[SceneManagerService alloc] init];
    [sceneManagerService saveScenePlan:scenePlan success:@selector(saveScenePlanSuccess:) error:@selector(saveScenePlanFailed:) target:self callback:nil];
}

- (void)saveScenePlanSuccess:(RestResponse *)resp {
    if(resp.statusCode == 200) {
        NSDictionary *json = [JsonUtils createDictionaryFromJson:resp.body];
        if(json != nil) {
            if([json integerForKey:@"i"] == 1) {
                [[ScenePlanFileManager fileManager] saveScenePlan:scenePlan];
                [[AlertView currentAlertView] setMessage:NSLocalizedString(@"save_success", @"") forType:AlertViewTypeSuccess];
                [[AlertView currentAlertView] delayDismissAlertView];
                [super dismiss];
                return;
            }
        }
    }
    [self saveScenePlanFailed:resp];
}

- (void)saveScenePlanFailed:(RestResponse *)resp {
    if(abs(resp.statusCode) == 1001) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"request_timeout", @"") forType:AlertViewTypeFailed];
    } else {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"unknow_error", @"") forType:AlertViewTypeFailed];
    }
    [[AlertView currentAlertView] delayDismissAlertView];
}

- (void)closePage:(id)sender {
    [super dismiss];
}

- (void)refresh {
}

#pragma mark -
#pragma mark Table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(scenePlan == nil) return 0;
    return scenePlan.scenePlanZones.count + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(scenePlan == nil) return 0;
    if(section == 0) return 1;
    
    int index = section - 1;
    if(scenePlan.scenePlanZones.count <= index) return 0;
        
    ScenePlanZone *zonePlan = [scenePlan.scenePlanZones objectAtIndex:index];
    return zonePlan.scenePlanDevices.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(12, 10, 200, 30)];
    lblTitle.textColor = [UIColor lightGrayColor];
    lblTitle.font = [UIFont systemFontOfSize:17.f];
    lblTitle.backgroundColor = [UIColor clearColor];
    [view addSubview:lblTitle];
    if(section == 0) {
        lblTitle.text = NSLocalizedString(@"security_settings", @"");
    } else {
        ScenePlanZone *zonePlan = [scenePlan.scenePlanZones objectAtIndex:section - 1];
        lblTitle.text = zonePlan.zone.name;
    }
    return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        if(![UIDevice systemVersionIsMoreThanOrEuqal7]) {
            cell.textLabel.font = [UIFont systemFontOfSize:17.f];
            cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"e5e5e5"];
        }
    }
    
    if(indexPath.section == 0) {
        cell.textLabel.text = NSLocalizedString(@"security_scene", @"");
        if(![NSString isBlank:scenePlan.securityIdentifier]) {
            BOOL found = NO;
            for(int i=0; i<scenePlan.unit.scenesModeList.count; i++) {
                SceneMode *mode = [scenePlan.unit.scenesModeList objectAtIndex:i];
                if(mode.isSecurityMode && [[NSString stringWithFormat:@"%d", mode.code] isEqualToString:scenePlan.securityIdentifier]) {
                    cell.detailTextLabel.text = mode.name;
                    found = YES;
                    break;
                }
            }
            if(!found) {
                scenePlan.securityIdentifier = [NSString emptyString];
                cell.detailTextLabel.text = NSLocalizedString(@"un_set", @"");
            }
        } else {
            cell.detailTextLabel.text = NSLocalizedString(@"un_set", @"");
        }
    } else {
        ScenePlanDevice *devicePlan = [self devicePlanForIndexPath:indexPath];
        cell.textLabel.text = devicePlan.device.name;
        cell.detailTextLabel.text = [self statusStringForDevice:devicePlan];
    }
    
    return cell;
}

#pragma mark -
#pragma mark Table view events

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SMActionSheet *actionSheet = [[SMActionSheet alloc] init];
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    actionSheet.title = NSLocalizedString(@"please_select", @"");
    actionSheet.delegate = self;
    [actionSheet setParameter:indexPath forKey:@"indexPath"];
    
    if(indexPath.section == 0) {
        if(scenePlan.unit != nil) {
            for(int i=0; i<scenePlan.unit.scenesModeList.count; i++) {
                SceneMode *sm = [scenePlan.unit.scenesModeList objectAtIndex:i];
                [actionSheet addButtonWithTitle:sm.name];
//                if([[NSString stringWithFormat:@"%d", sm.code] isEqualToString:scenePlan.securityIdentifier]) {
//                    actionSheet.destructiveButtonIndex = index;
//                }
            }
            [actionSheet addButtonWithTitle:NSLocalizedString(@"un_set", @"")];
            if([NSString isBlank:scenePlan.securityIdentifier]) {
//                actionSheet.destructiveButtonIndex = index;
            }
            actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"cancel", @"")];
            [actionSheet showInView:self.view];
        }
        return;
    }
    
    ScenePlanDevice *devicePlan = [self devicePlanForIndexPath:indexPath];
    if(devicePlan == nil) return;
    
    [actionSheet setParameter:devicePlan forKey:@"devicePlan"];
    
    if(devicePlan.device.isRemote) {
        [actionSheet addButtonWithTitle:NSLocalizedString(@"power", @"")];
        [actionSheet addButtonWithTitle:NSLocalizedString(@"un_set", @"")];
        actionSheet.destructiveButtonIndex = devicePlan.status == -100 ? 1 : 0;
    } else {
        [actionSheet addButtonWithTitle:NSLocalizedString(@"open", @"")];
        [actionSheet addButtonWithTitle:NSLocalizedString(@"close", @"")];
        [actionSheet addButtonWithTitle:NSLocalizedString(@"un_set", @"")];
        if(devicePlan.status == 0) {
            actionSheet.destructiveButtonIndex = 0;
        } else if(devicePlan.status == 1) {
            actionSheet.destructiveButtonIndex = 1;
        } else if(devicePlan.status == -100) {
            actionSheet.destructiveButtonIndex = 2;
        }
    }
    
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:NSLocalizedString(@"cancel", @"")];
    [actionSheet showInView:self.view];
}

#pragma mark -
#pragma mark Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if([actionSheet isKindOfClass:[SMActionSheet class]]) {
        SMActionSheet *as = (SMActionSheet *)actionSheet;
        NSIndexPath *indexPath = [as parameterForKey:@"indexPath"];
        UITableViewCell *cell = [tblScenePlan cellForRowAtIndexPath:indexPath];
        if(indexPath.section == 0) {
            if(buttonIndex >= 0 && buttonIndex < scenePlan.unit.scenesModeList.count) {
                SceneMode *mode = [scenePlan.unit.scenesModeList objectAtIndex:buttonIndex];
                scenePlan.securityIdentifier = [NSString stringWithFormat:@"%d", mode.code];
                cell.detailTextLabel.text = mode.name;
            } else if(buttonIndex == scenePlan.unit.scenesModeList.count) {
                scenePlan.securityIdentifier = [NSString emptyString];
                cell.detailTextLabel.text = NSLocalizedString(@"un_set", @"");
            }
        } else {
            ScenePlanDevice *devicePlan = [as parameterForKey:@"devicePlan"];
            if(devicePlan.device.isSocket || devicePlan.device.isCurtainOrSccurtain || devicePlan.device.isLightOrInlight) {
                if(buttonIndex == 0) {
                    devicePlan.status = 0;
                } else if(buttonIndex == 1) {
                    devicePlan.status = 1;
                } else if(buttonIndex == 2) {
                    devicePlan.status = -100;
                }
            } else if(devicePlan.device.isRemote) {
                if(buttonIndex == 0) {
                    devicePlan.status = 0;
                } else if(buttonIndex == 1) {
                    devicePlan.status = -100;
                }
            }
            cell.detailTextLabel.text = [self statusStringForDevice:devicePlan];
        }
    }
}

#pragma mark -
#pragma mark Utils

- (ScenePlanZone *)zonePlanForIndexPath:(NSIndexPath *)indexPath {
    if(indexPath == nil || indexPath.section == 0) return nil;
    if(scenePlan == nil || scenePlan.scenePlanZones.count == 0) return nil;
    if(scenePlan.scenePlanZones.count <= indexPath.section - 1) return nil;
    
    return [scenePlan.scenePlanZones objectAtIndex:indexPath.section - 1];
}

- (ScenePlanDevice *)devicePlanForIndexPath:(NSIndexPath *)indexPath {
    ScenePlanZone *zonePlan = [self zonePlanForIndexPath:indexPath];
    if(zonePlan == nil) return nil;
    
    if(zonePlan.scenePlanDevices.count <= indexPath.row) return nil;
    return [zonePlan.scenePlanDevices objectAtIndex:indexPath.row];
}

- (NSString *)statusStringForDevice:(ScenePlanDevice *)devicePlan {
    if(devicePlan == nil) return [NSString emptyString];
    
    if(devicePlan.device.isSocket || devicePlan.device.isLightOrInlight || devicePlan.device.isCurtainOrSccurtain) {
        if(devicePlan.status == 0) {
            return NSLocalizedString(@"open", @"");
        } else if(devicePlan.status == 1) {
            return NSLocalizedString(@"close", @"");
        } else if(devicePlan.status == -100){
            return NSLocalizedString(@"un_set", @"");
        }
    } else if(devicePlan.device.isRemote) {
        if(devicePlan.status == 0) {
           return NSLocalizedString(@"power", @"");
        } else if(devicePlan.status == -100) {
            return NSLocalizedString(@"un_set", @"");
        }
    }
    
    return [NSString emptyString];
}

#pragma mark -
#pragma mark Getter and setters

- (void)setUnit:(Unit *)unit {
    if(unit == nil) {
        _unit_ = nil;
        scenePlan = nil;
        return;
    }
    
    _unit_ = [[Unit alloc] init];
    _unit_.identifier = unit.identifier;
    
    for(int i=0; i<unit.zones.count; i++) {
        Zone *zone = [unit.zones objectAtIndex:i];
        if(zone.devices.count > 0) {
            Zone *_zone = [[Zone alloc] init];
            _zone.name = zone.name;
            _zone.identifier = zone.identifier;
            _zone.unit = zone.unit;
            for(int j=0; j<zone.devices.count; j++) {
                Device *device = [zone.devices objectAtIndex:j];
                if(device.isSocket || device.isRemote || device.isLightOrInlight || device.isCurtainOrSccurtain) {
                    [_zone.devices addObject:device];
                }
            }
            [_unit_.zones addObject:_zone];
        }
    }
    scenePlan = [[ScenePlan alloc] initWithUnit:_unit_];
    scenePlan.scenePlanIdentifier = scenePlanIdentifier;
    ScenePlanFileManager *manager = [ScenePlanFileManager fileManager];
    [manager syncScenePlan:scenePlan];
}

@end
