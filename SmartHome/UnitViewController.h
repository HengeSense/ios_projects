//
//  UnitViewController.h
//  SmartHome
//
//  Created by Zhao yang on 12/3/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NavViewController.h"
#import "NavigationView.h"
#import "ConversationView.h"
#import "SpeechRecognitionUtil.h"
#import "DeviceCommandGetUnitsHandler.h"
#import "DeviceCommandGetNotificationsHandler.h"
#import "DeviceCommandVoiceControlHandler.h"
#import "DeviceCommandUpdateDevicesHandler.h"
#import "SelectionView.h"
#import "NotificationDetailsViewController.h"

typedef NS_ENUM(NSInteger, SpeechViewState) {
    SpeechViewStateOpenning   = 1,
    SpeechViewStateOpenned    = 2,
    SpeechViewStateClosing    = 3,
    SpeechViewStateClosed     = 4
};

typedef NS_ENUM(NSInteger, RecognizerState) {
    RecognizerStateReady,
    RecognizerStateRecordBegin,
    RecognizerStateRecording,
    RecognizerStateRecordingEnd,
    RecognizerStateProceesing
};

@interface UnitViewController : NavViewController<SpeechRecognitionNotificationDelegate, DeviceCommandGetUnitsHandlerDelegate, DeviceCommandVoiceControlDelegate, SelectionViewDelegate, DevicecommandUpdateDevicesDelegate, CommandDeliveryServiceDelegate, DeviceCommandGetNotificationsHandlerDelegate, SMNotificationDelegate>

- (void)showSpeechView;
- (void)hideSpeechView;

@end
