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

typedef NS_ENUM(NSInteger, SpeechViewState) {
    SpeechViewStateOpenning = 1,
    SpeechViewStateOpenned  = 2,
    SpeechViewStateClosing  = 3,
    SpeechViewStateClosed   = 4
};

@interface MainView : NavigationView<SpeechRecognitionNotificationDelegate>

- (void)showSpeechView;
- (void)hideSpeechView;

@end
