//
//  MainViewController.m
//  SmartHome
//
//  Created by Zhao yang on 8/1/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "MainViewController.h"
#import "PortalView.h"
#import "MainView.h"
#import "MySettingsView.h"
#import "AccountManagementView.h"
#import "MyDevicesView.h"
#import "TopbarView.h"
#import "CommandFactory.h"
#import "NotificationsView.h"
#import "ViewsPool.h"
#import "UnitSelectionDrawerView.h"

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

    DrawerNavigationItem *portalView = [[DrawerNavigationItem alloc] init];
    DrawerNavigationItem *myDevicesView = [[DrawerNavigationItem alloc] init];
    DrawerNavigationItem *notificationsView = [[DrawerNavigationItem alloc] init];
    DrawerNavigationItem *accountManagementView = [[DrawerNavigationItem alloc] init];
    DrawerNavigationItem *settingsView = [[DrawerNavigationItem alloc] init];
    
    portalView.itemIdentifier = @"portalView";
    portalView.itemTitle = NSLocalizedString(@"main_view", @"");
    portalView.itemImageName = @"icon_home_unselected";
    portalView.itemCheckedImageName = @"icon_home_selected";
    portalView.itemIndex = 0;
    
//    mainView.itemIdentifier = @"mainView";
//    mainView.itemTitle = NSLocalizedString(@"main_view", @"");
//    mainView.itemImageName = @"icon_home_unselected.png";
//    mainView.itemCheckedImageName = @"icon_home_selected.png";
//    mainView.itemIndex = 0;
    
    myDevicesView.itemIdentifier = @"myDevicesView";
    myDevicesView.itemTitle = NSLocalizedString(@"my_devices", @"");
    myDevicesView.itemImageName = @"icon_device_unselected";
    myDevicesView.itemCheckedImageName = @"icon_device_selected";
    myDevicesView.itemIndex = 1;
    
    notificationsView.itemIdentifier = @"notificationsView";
    notificationsView.itemTitle = NSLocalizedString(@"my_notifications", @"");
    notificationsView.itemImageName = @"icon_noti_unselected";
    notificationsView.itemCheckedImageName = @"icon_noti_selected";
    notificationsView.itemIndex = 2;
    
    accountManagementView.itemIdentifier = @"accountManagementView";
    accountManagementView.itemTitle = NSLocalizedString(@"account_management", @"");
    accountManagementView.itemImageName = @"icon_users_unselected";
    accountManagementView.itemCheckedImageName = @"icon_users_selected";
    accountManagementView.itemIndex = 3;
    
    settingsView.itemIdentifier = @"settingsView";
    settingsView.itemTitle = NSLocalizedString(@"settings_view", @"");
    settingsView.itemImageName = @"icon_settings_unselected";
    settingsView.itemCheckedImageName = @"icon_settings_selected";
    settingsView.itemIndex = 4;
    
//    [drawerItems addObject:mainView];
    [drawerItems addObject:portalView];
    [drawerItems addObject:myDevicesView];
    [drawerItems addObject:notificationsView];
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
    
    if(self.rightView == nil) {
        UnitSelectionDrawerView *unitSelectionView = [[UnitSelectionDrawerView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 20) owner:self];
        self.rightView = unitSelectionView;
    }
    
    [self drawerNavigationItemChanged:[drawerItems objectAtIndex:0] isFirstTime:YES];
    
    //parameter of drawer navigation view controller
    self.leftViewVisibleWidth = 140;
    self.showDrawerMaxTrasitionX = 40;
    self.rightViewVisibleWidth = 180;
    self.rightViewCenterX = 168;

    
    [self initialDrawerViewController];
    
    [[SMShared current].deliveryService startRefreshCurrentUnit];
    [[SMShared current].deliveryService queueCommand:[CommandFactory commandForType:CommandTypeGetAccount]];
}

- (DrawerNavigationItem *)findItemByIdentifier:(NSString *)identifier {
    if([NSString isBlank:identifier]) return nil;
    if(drawerItems == nil) return nil;
    
    for(int i=0; i<drawerItems.count; i++) {
        DrawerNavigationItem *item = [drawerItems objectAtIndex:i];
        if([item.itemIdentifier isEqualToString:identifier]) {
            return item;
        }
    }
    
    return nil;
}

- (void)changeDrawerItemWithViewIdentifier:(NSString *)identifier {
    if(self.leftView != nil && [self.leftView isKindOfClass:[DrawerView class]]) {
        DrawerView *dv = (DrawerView *)self.leftView;
        DrawerNavigationItem *item = [self findItemByIdentifier:identifier];
        if(item != nil) {
            [dv changeItemToIndexPath:[NSIndexPath indexPathForRow:item.itemIndex inSection:0]];
        }
    }
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
        if([@"portalView" isEqualToString:item.itemIdentifier]) {
            view = [[PortalView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 20) owner:self];
            view.topbar.titleLabel.text = NSLocalizedString(@"main_view.title", @"");
        } /* else if([@"mainView" isEqualToString:item.itemIdentifier]) {
            view = [[MainView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-20) owner:self];
            view.topbar.titleLabel.text = NSLocalizedString(@"main_view.title", @"");
        } */ else if([@"myDevicesView" isEqualToString:item.itemIdentifier]) {
            view = [[MyDevicesView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 20) owner:self];
            view.topbar.titleLabel.text = NSLocalizedString(@"my_devices.title", @"");
        } else if([@"notificationsView" isEqualToString:item.itemIdentifier]) {
            view = [[NotificationsView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight - 20) owner:self];
        } else if([@"accountManagementView" isEqualToString:item.itemIdentifier]) {
            view = [[AccountManagementView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-20) owner:self];
            view.topbar.titleLabel.text = NSLocalizedString(@"account_management.title", @"");
        } else if([@"settingsView" isEqualToString:item.itemIdentifier]) {
            view = [[MySettingsView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-20) owner:self];
            view.topbar.titleLabel.text = NSLocalizedString(@"settings_view.title", @"");
        }
        
        if(view != nil) {
            view.isActive = YES;
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
