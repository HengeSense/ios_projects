//
//  PortalView.h
//  SmartHome
//
//  Created by Zhao yang on 12/2/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NavigationView.h"
#import "SMButton.h"
#import "DeviceCommandGetNotificationsHandler.h"
#import "NotificationDetailsViewController.h"
#import "XXEventSubscription.h"

#define SCENE_MODE_BACK    @"1"
#define SCENE_MODE_OUT     @"2"
#define SCENE_MODE_GET_UP  @"3"
#define SCENE_MODE_SLEEP   @"4"

@interface PortalView : NavigationView<LongPressDelegate, SMNotificationDelegate, XXEventSubscriber>

- (void)updateScenePlanFor:(Unit *)unit withSPlanId:(NSString *)planId;
- (void)updateUnitSelectionView;
- (void)updateNotifications;

@end
