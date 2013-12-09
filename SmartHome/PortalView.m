//
//  PortalView.m
//  SmartHome
//
//  Created by Zhao yang on 12/2/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "PortalView.h"
#import "SceneEditViewController.h"
#import "UnitSelectionDrawerView.h"
#import "UnitViewController.h"
#import "ScenePlan.h"
#import "ScenePlanDevice.h"
#import "ScenePlanFileManager.h"
#import "UIImage+Extension.h"
#import "NotificationsFileManager.h"

@implementation PortalView {
    SMButton *btnSceneBack;
    SMButton *btnSceneOut;
    SMButton *btnSceneGetUp;
    SMButton *btnSceneSleep;
    
    UIImageView *imgNetworkState;
    UIButton *btnShowNotification;
    
    NSMutableDictionary *plans;
    
    // 目的：尽可能少调用磁盘读取等方法
    BOOL unitHasNotifyUpdateAtLeastOnce;
    BOOL notificationHasUpdateAtLeastOnce;
    
    SMNotification *lastedNotification;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)initDefaults {
    [super initDefaults];
    plans = [NSMutableDictionary dictionary];
    unitHasNotifyUpdateAtLeastOnce = NO;
    notificationHasUpdateAtLeastOnce = NO;
}

- (void)initUI {
    [super initUI];
    
    [self.topbar.rightButton setBackgroundImage:[UIImage imageNamed:@"btn_drawer_unit"] forState:UIControlStateNormal];
    [self.topbar.rightButton setBackgroundImage:[UIImage imageNamed:@"btn_drawer_unit"] forState:UIControlStateHighlighted];
    
    [self.topbar.rightButton addTarget:self action:@selector(showUnitSelectionDrawerView:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat toMinusHeight = [UIDevice systemVersionIsMoreThanOrEuqal7] ? 0 : 20;
    
    btnShowNotification = [[UIButton alloc] initWithFrame:CGRectMake(180, 97 - toMinusHeight, 24, 21)];
    [btnShowNotification setBackgroundImage:[UIImage imageNamed:@"icon_message"] forState:UIControlStateNormal];
    [btnShowNotification setBackgroundImage:[UIImage imageNamed:@"icon_message"] forState:UIControlStateHighlighted];
    [btnShowNotification setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnShowNotification addTarget:self action:@selector(showNotificationDetails) forControlEvents:UIControlEventTouchUpInside];
    btnShowNotification.hidden = YES;
    [self addSubview:btnShowNotification];
    
    UIButton *btnShowUnitController = [[UIButton alloc] initWithFrame:CGRectMake(230, 95 - toMinusHeight, 25, 20)];
    [btnShowUnitController setBackgroundImage:[UIImage imageNamed:@"btn_unit_panel"] forState:UIControlStateNormal];
    [btnShowUnitController setBackgroundImage:[UIImage imageNamed:@"btn_unit_panel"] forState:UIControlStateHighlighted];
    [btnShowUnitController setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnShowUnitController addTarget:self action:@selector(showUnitController:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnShowUnitController];
    
    imgNetworkState = [[UIImageView alloc] initWithFrame:CGRectMake(280, 94 - toMinusHeight, 24, 21)];
    [self changeStateIconColor:@"red"];
    [self addSubview:imgNetworkState];
    
    btnSceneBack = [[SMButton alloc] initWithFrame:CGRectMake(45, 140 - toMinusHeight, 86, 86)];
    btnSceneBack.identifier = SCENE_MODE_BACK;
    [btnSceneBack setParameter:NSLocalizedString(@"scene_home", @"") forKey:@"name"];
    btnSceneBack.longPressDelegate = self;
    [btnSceneBack addTarget:self action:@selector(btnScenePressed:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imgBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_back"]];
    imgBack.center = CGPointMake(btnSceneBack.center.x, 250 - toMinusHeight);
    [self addSubview:imgBack];
    
    btnSceneOut = [[SMButton alloc] initWithFrame:CGRectMake(199, 140 - toMinusHeight, 86, 86)];
    btnSceneOut.identifier = SCENE_MODE_OUT;
    [btnSceneOut setParameter:NSLocalizedString(@"scene_out", @"") forKey:@"name"];
    btnSceneOut.longPressDelegate = self;
    [btnSceneOut addTarget:self action:@selector(btnScenePressed:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imgOut = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_out"]];
    imgOut.center = CGPointMake(btnSceneOut.center.x, 250 - toMinusHeight);
    [self addSubview:imgOut];
    
    btnSceneGetUp = [[SMButton alloc] initWithFrame:CGRectMake(45, 300 - toMinusHeight, 86, 86)];
    btnSceneGetUp.identifier = SCENE_MODE_GET_UP;
    [btnSceneGetUp setParameter:NSLocalizedString(@"scene_get_up", @"") forKey:@"name"];
    btnSceneGetUp.longPressDelegate = self;
    [btnSceneGetUp addTarget:self action:@selector(btnScenePressed:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imgGetUp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_get_up"]];
    imgGetUp.center = CGPointMake(btnSceneGetUp.center.x, 410 - toMinusHeight);
    [self addSubview:imgGetUp];
    
    btnSceneSleep = [[SMButton alloc] initWithFrame:CGRectMake(199, 300 - toMinusHeight, 86, 86)];
    btnSceneSleep.identifier = SCENE_MODE_SLEEP;
    [btnSceneSleep setParameter:NSLocalizedString(@"scene_sleep", @"") forKey:@"name"];
    btnSceneSleep.longPressDelegate = self;
    [btnSceneSleep addTarget:self action:@selector(btnScenePressed:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imgSleep = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_sleep"]];
    imgSleep.center = CGPointMake(btnSceneSleep.center.x, 410 - toMinusHeight);
    [self addSubview:imgSleep];
 
    [self addSubview:btnSceneBack];
    [self addSubview:btnSceneOut];
    [self addSubview:btnSceneGetUp];
    [self addSubview:btnSceneSleep];
}

- (void)setUp {
    [[SMShared current].memory subscribeHandler:[DeviceCommandGetUnitsHandler class] for:self];
    [[SMShared current].memory subscribeHandler:[Memory class] for:self];
    [[SMShared current].memory subscribeHandler:[DeviceCommandDeliveryService class] for:self];
    [[SMShared current].memory subscribeHandler:[DeviceCommandGetNotificationsHandler class] for:self];
    [self updateScenePlanForCurrentUnit];
}

- (void)destory {
    [[SMShared current].memory unSubscribeHandler:[DeviceCommandGetUnitsHandler class] for:self];
    [[SMShared current].memory unSubscribeHandler:[Memory class] for:self];
    [[SMShared current].memory unSubscribeHandler:[DeviceCommandDeliveryService class] for:self];
    [[SMShared current].memory unSubscribeHandler:[DeviceCommandGetNotificationsHandler class] for:self];
    [plans removeAllObjects];
}

- (void)notifyViewUpdate {
    if(self.ownerController != nil) {
        self.ownerController.rightViewEnable = YES;
    }
    
    if(!unitHasNotifyUpdateAtLeastOnce) {
        unitHasNotifyUpdateAtLeastOnce = YES;
        [self notifyUnitsWasUpdate];
    }
    
    if(!notificationHasUpdateAtLeastOnce) {
        notificationHasUpdateAtLeastOnce = YES;
        [self notifyUpdateNotifications];
    }
}

- (void)notifyUnitsWasUpdate {
    @synchronized(self) {
        unitHasNotifyUpdateAtLeastOnce = YES;
        [self unitManagerNotifyCurrentUnitWasChanged:nil];
        [self updateUnitSelectionView];
    }
}

- (void)updateUnitSelectionView {
    if(self.ownerController.rightView != nil && [self.ownerController.rightView isKindOfClass:[UnitSelectionDrawerView class]]) {
        UnitSelectionDrawerView *selectionView = (UnitSelectionDrawerView *)self.ownerController.rightView;
        [selectionView refresh];
    }
}

- (void)updateStatusDisplay {
    if([SMShared current].memory.currentUnit != nil) {
        self.topbar.titleLabel.text = [SMShared current].memory.currentUnit.name;
    }
}

#pragma mark -
#pragma mark Command Delivery Service Delegate

- (void)commandDeliveryServiceNotifyNetworkModeMayChanged:(NetworkMode)lastedNetwokMode {
    if(lastedNetwokMode == 1) {
        if([SMShared current].deliveryService.tcpService.isConnectted) {
            if([@"在线" isEqualToString:[SMShared current].memory.currentUnit.status]) {
                [self changeStateIconColor:@"green"];
            } else {
                [self changeStateIconColor:@"yellow"];
            }
        } else {
            [self changeStateIconColor:@"red"];
        }
        
    } else if(lastedNetwokMode == 2) {
        if([SMShared current].deliveryService.tcpService.isConnectted) {
            [self changeStateIconColor:@"green"];
        } else {
            [self changeStateIconColor:@"yellow"];
        }
    } else {
        [self changeStateIconColor:@"red"];
    }
}

- (void)changeStateIconColor:(NSString *)colorString {
    imgNetworkState.image = [UIImage imageNamed:colorString];
}

#pragma mark -
#pragma mark Unit Manager Delegate

- (void)unitManagerNotifyCurrentUnitWasChanged:(NSString *)unitIdentifier {
    [self updateStatusDisplay];
    [self updateScenePlanForCurrentUnit];
}

#pragma mark -
#pragma mark Notifications

- (void)notifyUpdateNotifications {
    notificationHasUpdateAtLeastOnce = YES;
    
    NSArray *notifications = [[NotificationsFileManager fileManager] readFromDisk];
    if (notifications == nil || notifications.count == 0) {
        lastedNotification = nil;
        btnShowNotification.hidden = YES;
        return;
    }
    
    NSTimeInterval lastTime = 0;
    NSTimeInterval alLastTime = 0;
    
    SMNotification *lastNotHandlerAlNotification = nil;
    BOOL needDisplay = NO;
    for(SMNotification *notification in notifications) {
        if ([notification.createTime timeIntervalSince1970] >= lastTime) {
            lastTime = [notification.createTime timeIntervalSince1970];
            lastedNotification = notification;
        }
        
        if ([@"AL" isEqualToString: notification.type] && alLastTime < [notification.createTime timeIntervalSince1970] && !notification.hasRead) {
            alLastTime = [notification.createTime timeIntervalSince1970];
            lastNotHandlerAlNotification = notification;
        }
        
        if(!notification.hasRead){
            needDisplay = YES;
        }
    }
    if(lastNotHandlerAlNotification != nil) {
        lastedNotification = lastNotHandlerAlNotification;
    }
    btnShowNotification.hidden = !needDisplay;
}

- (void)showNotificationDetails {
    if(lastedNotification != nil) {
        NotificationDetailsViewController *notificationDetailsViewController = [[NotificationDetailsViewController alloc] initWithNotification:lastedNotification];
        notificationDetailsViewController.delegate = self;
        [self.ownerController.navigationController pushViewController:notificationDetailsViewController animated:YES];
    }
}

- (void)smNotificationsWasUpdated {
    [self notifyUpdateNotifications];
}

#pragma mark -
#pragma mark Events for button

- (void)showUnitSelectionDrawerView:(id)sender {
    if(self.ownerController != nil) {
        [self.ownerController showRightView];
    }
}

- (void)showUnitController:(id)sender {
    @synchronized(self) {
        UnitViewController *controller = [[UnitViewController alloc] init];
        [self.ownerController.navigationController pushViewController:controller animated:YES];
    }
}

- (void)btnScenePressed:(SMButton *)button {
    if(button == nil) return;
    NSString *hasPlan = [button parameterForKey:@"hasPlan"];
    if(![NSString isBlank:hasPlan] && [@"yes" isEqualToString:hasPlan]) {
        ScenePlan *plan = [plans objectForKey:button.identifier];
        if(plan != nil) {
            [plan execute];
        }
    } else {
        [self smButtonLongPressed:button];
    }
}

- (void)smButtonLongPressed:(SMButton *)button {
    if(button == nil) return;
    SceneEditViewController *controller = [[SceneEditViewController alloc] init];
    controller.scenePlan = [plans objectForKey:button.identifier];
    NSString *name = [button parameterForKey:@"name"];
    if([NSString isBlank:name]) {
        controller.title = NSLocalizedString(@"scene_edit", @"");
    } else {
        controller.title = [NSString stringWithFormat:@"%@:%@", NSLocalizedString(@"scene_edit", @""), name];
    }
    [self.ownerController presentModalViewController:controller animated:YES];
}

#pragma mark -
#pragma mark Scene Plan Manager

- (void)updateScenePlanForCurrentUnit {
    Unit *currentUnit = [SMShared current].memory.currentUnit;
    [plans removeAllObjects];
    if(currentUnit == nil) return;
    [self updateScenePlanFor:currentUnit withSPlanId:SCENE_MODE_BACK];
    [self updateScenePlanFor:currentUnit withSPlanId:SCENE_MODE_GET_UP];
    [self updateScenePlanFor:currentUnit withSPlanId:SCENE_MODE_OUT];
    [self updateScenePlanFor:currentUnit withSPlanId:SCENE_MODE_SLEEP];
}

- (void)updateScenePlanFor:(Unit *)unit withSPlanId:(NSString *)planId {
    Unit *mergedUnit = [[Unit alloc] init];
    mergedUnit.identifier = unit.identifier;
    
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
            [mergedUnit.zones addObject:_zone];
        }
    }
    ScenePlan *plan = [[ScenePlan alloc] initWithUnit:mergedUnit];
    plan.scenePlanIdentifier = planId;
    ScenePlanFileManager *manager = [ScenePlanFileManager fileManager];
    BOOL hasSet = [manager syncScenePlan:plan] != nil;
    [plans setObject:plan forKey:planId];
    
    // Refresh button image that scene plan is set or unset
    if([SCENE_MODE_BACK isEqualToString:planId]) {
        [btnSceneBack setParameter:hasSet ? @"yes" : @"no" forKey:@"hasPlan"];
        [btnSceneBack setBackgroundImage:[UIImage imageNamed:hasSet ? @"btn_home" : @"btn_home_unset"] forState:UIControlStateNormal];
    } else if([SCENE_MODE_GET_UP isEqualToString:planId]) {
        [btnSceneGetUp setParameter:hasSet ? @"yes" : @"no" forKey:@"hasPlan"];
        [btnSceneGetUp setBackgroundImage:[UIImage imageNamed:hasSet ? @"btn_get_up" :@"btn_get_up_unset"] forState:UIControlStateNormal];
    } else if([SCENE_MODE_OUT isEqualToString:planId]) {
        [btnSceneOut setParameter:hasSet ? @"yes" : @"no" forKey:@"hasPlan"];
        [btnSceneOut setBackgroundImage:[UIImage imageNamed:hasSet ? @"btn_out" : @"btn_out_unset"] forState:UIControlStateNormal];
    } else if([SCENE_MODE_SLEEP isEqualToString:planId]) {
        [btnSceneSleep setParameter:hasSet ? @"yes" : @"no" forKey:@"hasPlan"];
        [btnSceneSleep setBackgroundImage:[UIImage imageNamed:hasSet ? @"btn_sleep" : @"btn_sleep_unset"] forState:UIControlStateNormal];
    }
}

@end
