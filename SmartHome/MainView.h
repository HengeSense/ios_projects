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
#import "PageableScrollView.h"
#import "SelectionView.h"
#import "NotificationHandlerViewController.h"   

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

@interface MainView : NavigationView<SpeechRecognitionNotificationDelegate, DeviceCommandGetUnitsHandlerDelegate, DeviceCommandGetNotificationsHandlerDelegate, DeviceCommandVoiceControlDelegate, SelectionViewDelegate,DeleteNotificationDelegate,CFNotificationDelegate, DevicecommandUpdateDevicesDelegate>

- (void)showSpeechView;
- (void)hideSpeechView;
- (void)notifyViewUpdate;

@end
