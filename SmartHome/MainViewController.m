//
//  MainViewController.m
//  SmartHome
//
//  Created by Zhao yang on 8/1/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "MainViewController.h"
#import "MainView.h"
#import "HistoricalDataView.h"
#import "SceneModeView.h"
#import "DevicesView.h"
#import "TopbarView.h"
#import "ViewsPool.h"


#define MAIN_VIEW_TAG 5001

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
    DrawerNavigationItem *devicesView = [[DrawerNavigationItem alloc] init];
    DrawerNavigationItem *sceneModeView = [[DrawerNavigationItem alloc] init];
    DrawerNavigationItem *historicalView = [[DrawerNavigationItem alloc] init];
     
    mainView.itemIdentifier = @"mainView";
    mainView.itemTitle = NSLocalizedString(@"main.view", @"");
    mainView.itemImageName = @"";
        
    devicesView.itemIdentifier = @"devicesView";
    devicesView.itemTitle = NSLocalizedString(@"device.list", @"");
    devicesView.itemImageName = @"";
    
    sceneModeView.itemIdentifier = @"sceneModeView";
    sceneModeView.itemTitle = NSLocalizedString(@"scene_mode", @"");
    sceneModeView.itemImageName = @"";
    
    historicalView.itemIdentifier = @"historicalView";
    historicalView.itemTitle = NSLocalizedString(@"historical.data", @"");
    historicalView.itemImageName = @"";
    
    [drawerItems addObject:mainView];
    [drawerItems addObject:devicesView];
    [drawerItems addObject:sceneModeView];
    [drawerItems addObject:historicalView];
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
        self.leftView = dv;
        self.leftView.backgroundColor = [UIColor whiteColor];
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
    UIView *view = [[ViewsPool sharedPool] viewWithIdentifier:item.itemIdentifier];
    if(view == nil) {
        if([@"mainView" isEqualToString:item.itemIdentifier]) {
            view = [[MainView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-20) owner:self];
        } else if([@"devicesView" isEqualToString:item.itemIdentifier]) {
            view = [[DevicesView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-20) owner:self];
        } else if([@"sceneModeView" isEqualToString:item.itemIdentifier]) {
            view = [[SceneModeView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-20) owner:self];
        } else if([@"historicalView" isEqualToString:item.itemIdentifier]) {
            view = [[HistoricalDataView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-20) owner:self];
        }
        if(view != nil) {
            view.tag = MAIN_VIEW_TAG;
            [[ViewsPool sharedPool] putView:view forIdentifier:item.itemIdentifier];
        }
    }
    if(view != nil) {
        UIView *v = [self.mainView viewWithTag:MAIN_VIEW_TAG];
        if(v != nil) [v removeFromSuperview];
        [self.mainView addSubview:view];
        if(!isFirst) {
            [self showMainView:YES];
        }
    }
}

@end
