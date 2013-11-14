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
#import "AccountManagementView.h"
#import "MyDevicesView.h"
#import "TopbarView.h"
#import "CommandFactory.h"
#import "ViewsPool.h"

@interface MainViewController ()

@end

@implementation MainViewController {
    TopbarView *topbar;
    NSMutableArray *drawerItems;
    DrawerNavigationItem *currentItem;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initDefaults];
    [self initUI];
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
    DrawerNavigationItem *accountManagementView = [[DrawerNavigationItem alloc] init];
    DrawerNavigationItem *settingsView = [[DrawerNavigationItem alloc] init];
     
    mainView.itemIdentifier = @"mainView";
    mainView.itemTitle = NSLocalizedString(@"main_view", @"");
    mainView.itemImageName = @"icon_home_unselected.png";
    mainView.itemCheckedImageName = @"icon_home_selected.png";
        
    myDevicesView.itemIdentifier = @"myDevicesView";
    myDevicesView.itemTitle = NSLocalizedString(@"my_devices", @"");
    myDevicesView.itemImageName = @"icon_devices_unselected.png";
    myDevicesView.itemCheckedImageName = @"icon_devices_selected.png";
    
    accountManagementView.itemIdentifier = @"accountManagementView";
    accountManagementView.itemTitle = NSLocalizedString(@"account_management", @"");
    accountManagementView.itemImageName = @"icon_users_unselected.png";
    accountManagementView.itemCheckedImageName = @"icon_users_selected.png";
    
    settingsView.itemIdentifier = @"settingsView";
    settingsView.itemTitle = NSLocalizedString(@"settings_view", @"");
    settingsView.itemImageName = @"icon_settings_unselected.png";
    settingsView.itemCheckedImageName = @"icon_settings_selected.png";
    
    [drawerItems addObject:mainView];
    [drawerItems addObject:myDevicesView];
    [drawerItems addObject:accountManagementView];
    [drawerItems addObject:settingsView];
}

- (void)initUI {
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    
    if([UIDevice systemVersionIsMoreThanOrEuqal7]) {
        screenHeight += 20;
    }
    
    //initial drawer navigation view
    if(self.leftView == nil) {
        DrawerView *dv = [[DrawerView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 20) andItems:drawerItems];
        dv.drawerNavigationItemChangedDelegate = self;
        dv.ownerViewController = self;
        self.leftView = dv;
    }
    
    [self drawerNavigationItemChanged:[drawerItems objectAtIndex:0] isFirstTime:YES];
    
    //parameter of drawer navigation view controller
    self.leftViewVisibleWidth = 120;
    self.showDrawerMaxTrasitionX = 40;
    
    [self initialDrawerViewController];
    
    [[SMShared current].deliveryService startRefreshCurrentUnit];
    [[SMShared current].deliveryService queueCommand:[CommandFactory commandForType:CommandTypeGetAccount]];
}

- (void)drawerNavigationItemChanged:(DrawerNavigationItem *)item isFirstTime:(BOOL)isFirst {
    if(item == nil) return;
    if(currentItem != nil) {
        if([item.itemIdentifier isEqualToString:currentItem.itemIdentifier]) {
            [self showCenterView:YES];
            return;
        }
    }
    currentItem = item;
    CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
    if([UIDevice systemVersionIsMoreThanOrEuqal7]) {
        screenHeight += 20;
    }
    NavigationView *view = (NavigationView *)[[ViewsPool sharedPool] viewWithIdentifier:item.itemIdentifier];
    if(view == nil) {
        if([@"mainView" isEqualToString:item.itemIdentifier]) {
            view = [[MainView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-20) owner:self];
            view.topbar.titleLabel.text = NSLocalizedString(@"main_view.title", @"");
        } else if([@"myDevicesView" isEqualToString:item.itemIdentifier]) {
            view = [[MyDevicesView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-20) owner:self];
            view.topbar.titleLabel.text = NSLocalizedString(@"my_devices.title", @"");
        } else if([@"accountManagementView" isEqualToString:item.itemIdentifier]) {
            view = [[AccountManagementView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-20) owner:self];
            view.topbar.titleLabel.text = NSLocalizedString(@"account_management.title", @"");
        } else if([@"settingsView" isEqualToString:item.itemIdentifier]) {
            view = [[MySettingsView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-20) owner:self];
            view.topbar.titleLabel.text = NSLocalizedString(@"settings_view.title", @"");
        }
        if(view != nil) {
            [[ViewsPool sharedPool] putView:view forIdentifier:item.itemIdentifier];
        }
    }
    
    if(view != nil) {
        view.ownerController = self;
        self.centerView = view;
        if(!isFirst) {
            [self showCenterView:YES];
        }
        [view notifyViewUpdate];
    }
}

@end
