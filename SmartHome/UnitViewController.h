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
#import "SelectionView.h"
#import "NotificationDetailsViewController.h"
#import "XXEventSubscriber.h"

@interface UnitViewController : NavViewController<SpeechRecognitionNotificationDelegate, SelectionViewDelegate, SMNotificationDelegate, XXEventSubscriber>

- (void)showSpeechView;
- (void)hideSpeechView;

@end
