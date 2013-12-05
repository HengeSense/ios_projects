//
//  MainView.h
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavigationView.h"
#import "ConversationView.h"
#import "SpeechRecognitionUtil.h"
#import "DeviceCommandGetUnitsHandler.h"
#import "DeviceCommandGetNotificationsHandler.h"
#import "DeviceCommandVoiceControlHandler.h"
#import "DeviceCommandUpdateDevicesHandler.h"
#import "SelectionView.h"
#import "NotificationHandlerViewController.h"   


@interface MainView : NavigationView<SpeechRecognitionNotificationDelegate, DeviceCommandGetUnitsHandlerDelegate, DeviceCommandGetNotificationsHandlerDelegate, DeviceCommandVoiceControlDelegate, SelectionViewDelegate,DeleteNotificationDelegate,CFNotificationDelegate, DevicecommandUpdateDevicesDelegate, CommandDeliveryServiceDelegate>

- (void)showSpeechView;
- (void)hideSpeechView;
- (void)notifyViewUpdate;

- (void)clearStateString;

@end
