//
//  MainViewController.m
//  SmartHome
//
//  Created by Zhao yang on 8/1/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"
#import "MySettingsView.h"
#import "SceneModeView.h"
#import "MyDevicesView.h"
#import "TopbarView.h"
#import "CommandFactory.h"
#import "ViewsPool.h"

#define MAIN_VIEW_TAG         5001
#define UNIT_REFRESH_INTERVAL 30

@interface MainViewController ()

@end

@implementation MainViewController {
    TopbarView *topbar;
    NSMutableArray *drawerItems;
    DrawerNavigationItem *currentItem;
    
    NSTimer *currentUnitRefreshTimer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initDefaults];
    [self initUI];
    
    if(currentUnitRefreshTimer == nil) {
        currentUnitRefreshTimer = [NSTimer scheduledTimerWithTimeInterval:UNIT_REFRESH_INTERVAL target:self selector:@selector(refreshUnit) userInfo:nil repeats:YES];
    }
}

- (void)refreshUnit {
    Unit *unit = [SMShared current].memory.currentUnit;
    if(unit != nil) {
        DeviceCommand *command = [CommandFactory commandForType:CommandTypeGetUnits];
        command.masterDeviceCode = unit.identifier;
        command.hashCode = unit.hashCode;
        [[SMShared current].deliveryService executeDeviceCommand:command];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initDefaults {
    drawerItems = [NSMutableArray array];

    DrawerNavigationItem *mainView = [[DrawerNavigationItem alloc] init];
    DrawerNavigationItem *myDevicesView = [[DrawerNavigationItem alloc] init];
    DrawerNavigationItem *sceneModeView = [[DrawerNavigationItem alloc] init];
    DrawerNavigationItem *settingsView = [[DrawerNavigationItem alloc] init];
     
    mainView.itemIdentifier = @"mainView";
    mainView.itemTitle = NSLocalizedString(@"main_view", @"");
    mainView.itemImageName = @"icon_home_unselected.png";
    mainView.itemCheckedImageName = @"icon_home_selected.png";
        
    myDevicesView.itemIdentifier = @"myDevicesView";
    myDevicesView.itemTitle = NSLocalizedString(@"my_devices", @"");
    myDevicesView.itemImageName = @"icon_devices_unselected.png";
    myDevicesView.itemCheckedImageName = @"icon_devices_selected.png";
    
    sceneModeView.itemIdentifier = @"sceneModeView";
    sceneModeView.itemTitle = NSLocalizedString(@"scene_mode", @"");
    sceneModeView.itemImageName = @"icon_scene_mode_unselected.png";
    sceneModeView.itemCheckedImageName = @"icon_scene_mode_selected.png";
    
    settingsView.itemIdentifier = @"settingsView";
    settingsView.itemTitle = NSLocalizedString(@"settings_view", @"");
    settingsView.itemImageName = @"icon_settings_unselected.png";
    settingsView.itemCheckedImageName = @"icon_settings_selected.png";
    
    [drawerItems addObject:mainView];
    [drawerItems addObject:myDevicesView];
    [drawerItems addObject:sceneModeView];
    [drawerItems addObject:settingsView];
}

- (void)initUI {
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    //initial main view
    if(self.mainView == nil) {
        //initial white board
        self.mainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-20)];
        self.mainView.backgroundColor = [UIColor whiteColor];
        
        [self drawerNavigationItemChanged:[drawerItems objectAtIndex:0] isFirstTime:YES];
    }
    
    //initial drawer navigation view
    if(self.leftView == nil) {
        DrawerView *dv = [[DrawerView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-20) andItems:drawerItems];
        dv.drawerNavigationItemChangedDelegate = self;
        dv.ownerViewController = self;
        self.leftView = dv;
    }
    
    //parameter of drawer navigation view controller
    self.leftViewVisibleWidth = 120;
    self.showDrawerMaxTrasitionX = 40;
    
    //after initial
    [self applyBindings];
}

- (void)drawerNavigationItemChanged:(DrawerNavigationItem *)item isFirstTime:(BOOL)isFirst {
    if(item == nil) return;
    if(currentItem != nil) {
        if([item.itemIdentifier isEqualToString:currentItem.itemIdentifier]) {
            [self showMainView:YES];
            return;
        }
    }
    currentItem = item;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    NavigationView *view = (NavigationView *)[[ViewsPool sharedPool] viewWithIdentifier:item.itemIdentifier];
    if(view == nil) {
        if([@"mainView" isEqualToString:item.itemIdentifier]) {
            view = [[MainView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-20) owner:self];
            view.topbar.titleLabel.text = NSLocalizedString(@"main_view.title", @"");
        } else if([@"myDevicesView" isEqualToString:item.itemIdentifier]) {
            view = [[MyDevicesView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-20) owner:self];
            view.topbar.titleLabel.text = NSLocalizedString(@"my_devices.title", @"");
        } else if([@"sceneModeView" isEqualToString:item.itemIdentifier]) {
            view = [[SceneModeView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-20) owner:self];
            view.topbar.titleLabel.text = NSLocalizedString(@"scene_mode.title", @"");
        } else if([@"settingsView" isEqualToString:item.itemIdentifier]) {
            view = [[MySettingsView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-20) owner:self];
            view.topbar.titleLabel.text = NSLocalizedString(@"settings_view.title", @"");
        }
        if(view != nil) {
            view.tag = MAIN_VIEW_TAG;
            [[ViewsPool sharedPool] putView:view forIdentifier:item.itemIdentifier];
        }
    }
    
    if(view != nil) {
        view.ownerController = self;
        UIView *v = [self.mainView viewWithTag:MAIN_VIEW_TAG];
        if(v != nil) [v removeFromSuperview];
        [self.mainView addSubview:view];
        if(!isFirst) {
            [self showMainView:YES];
        }
        [view notifyViewUpdate];
    }
}

@end
