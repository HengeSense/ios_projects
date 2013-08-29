//
//  MainView.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "MainView.h"
#import "NSString+StringUtils.h"
#import <AudioToolbox/AudioToolbox.h>
#import "NotificationViewController.h"

#import "CameraSwitchButton.h"
#import "AirconditionSwitchButton.h"
#import "TVSwitchButton.h"
#import "UIColor+ExtentionForHexString.h"
#import "ToggleSwitchButton.h"


#define SPEECH_VIEW_TAG                  46001
#define SPEECH_BUTTON_WIDTH              195
#define SPEECH_BUTTON_HEIGHT             198
#define DELAY_START_LISTENING_DURATION   0.6f
#define RECORD_BEGIN_SOUND_ID            1113
#define RECORD_END_SOUND_ID              1114

@implementation MainView {
    SpeechViewState speechViewState;
    RecognizerState recognizerState;
    ConversationView *speechView;
    SpeechRecognitionUtil *speechRecognitionUtil;
    PageableScrollView *pageableScrollView;
    PageableNavView *pageableNavView;
    NSArray *navItems;
    
    UIButton *btnSpeech;
    UIButton *btnShowNotification;
    UIButton *btnShowAffectDevice;
    UIButton *btnMain;
    UIButton *btnScene;
    UIButton *btnMessage;
    
    UILabel *messageLable;
    UILabel *timeLable;
    UILabel *numOfDevice;
    UILabel *numOfMessage;
    
    UIImageView *deviceCount;
    UIImageView *messageCount;
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
    speechViewState = SpeechViewStateClosed;
    recognizerState = RecognizerStateReady;
    speechRecognitionUtil = [[SpeechRecognitionUtil alloc] init];
    speechRecognitionUtil.speechRecognitionNotificationDelegate = self;
}

- (void)initUI {
    [super initUI];
//    btnMain = [[UIButton alloc] initWithFrame:CGRectMake(40, self.topbar.frame.size.height+20, 168/2, 179/2)];
//    [btnMain setBackgroundImage:[UIImage imageNamed:@"btn_device.png"] forState:UIControlStateNormal];
//    [self addSubview:btnMain];
//    
//    btnScene = [[UIButton alloc] initWithFrame:CGRectMake(btnMain.frame.origin.x+btnMain.frame.size.width+40, btnMain.frame.origin.y, 168/2, 179/2)];
//    [btnScene setBackgroundImage:[UIImage imageNamed:@"btn_scene.png"] forState:UIControlStateNormal];
//    [self addSubview:btnScene];
//
    if (btnMessage == nil) {
        btnMessage = [[UIButton alloc] initWithFrame:CGRectMake(30, 120, 25/2, 30/2)];
        [btnMessage setBackgroundImage:[UIImage imageNamed:@"icon_sound"] forState:UIControlStateNormal];
        [self addSubview:btnMessage];

    }
    if (messageLable == nil) {
        messageLable = [[UILabel alloc]initWithFrame:CGRectMake(btnMessage.frame.origin.x+25/2+15,btnMessage.frame.origin.y-10, 120, 20)];
        messageLable.backgroundColor = [UIColor clearColor];
        messageLable.font = [UIFont systemFontOfSize:14];
        messageLable.text = @"有人闯入房屋!";
        messageLable.textColor = [UIColor lightTextColor];
        [self addSubview:messageLable];

    }
    if (timeLable == nil) {
        timeLable = [[UILabel alloc]initWithFrame:CGRectMake(messageLable.frame.origin.x, messageLable.frame.origin.y+messageLable.frame.size.height, 100, 10)];
        timeLable.backgroundColor =[UIColor clearColor];
        timeLable.text = @"16:54pm";
        timeLable.font = [UIFont systemFontOfSize:12];
        timeLable.textColor = [UIColor lightTextColor];
        [self addSubview: timeLable];

    }
    
    if (deviceCount == nil) {
        deviceCount = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"device_count.png"]];
        deviceCount.frame = CGRectMake(messageLable.frame.origin.x+messageLable.frame.size.width+40, messageLable.frame.origin.y, 44/2, 46/2);
        [self addSubview:deviceCount];
    }
    
    if (numOfDevice == nil) {
        numOfDevice = [[UILabel alloc] initWithFrame:CGRectMake(deviceCount.frame.origin.x+deviceCount.frame.size.width+5, messageLable.frame.origin.y, 20, 20)];
        numOfDevice.text = @"5";
        numOfDevice.textColor = [UIColor colorWithHexString:@"dfa800"];
        numOfDevice.font = [UIFont systemFontOfSize:14];
        numOfDevice.backgroundColor = [UIColor clearColor];
        [self addSubview:numOfDevice];
        
    }
    if (messageCount == nil) {
        messageCount = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_count.png"]];
        messageCount.frame = CGRectMake(numOfDevice.frame.origin.x+30, numOfDevice.frame.origin.y, 44/2, 46/2);
        [self addSubview:messageCount];
        
    }
    if (numOfMessage == nil) {
        numOfMessage = [[UILabel alloc] initWithFrame:CGRectMake(messageCount.frame.origin.x+messageCount.frame.size.width+5, messageCount.frame.origin.y, 20, 20)];
        numOfMessage.text = @"5";
        numOfMessage.textColor = [UIColor colorWithHexString:@"dfa800"];
        numOfMessage.backgroundColor = [UIColor clearColor];
        numOfMessage.font = [UIFont systemFontOfSize:14];
        [self addSubview:numOfMessage];
    }
    //    if(btnShowNotification == nil) {
//        btnShowNotification = [[UIButton alloc] initWithFrame:CGRectMake(200, 80, 120, 30)];
//        [btnShowNotification setTitle:@"通知" forState:UIControlStateNormal];
//        [btnShowNotification addTarget:self action:@selector(btnShowNotificationDevicePressed:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:btnShowNotification];
//    }
    
    if(btnSpeech == nil) {
        btnSpeech = [[UIButton alloc] initWithFrame:CGRectMake(((self.frame.size.width - SPEECH_BUTTON_WIDTH/2) / 2), (self.frame.size.height - SPEECH_BUTTON_HEIGHT / 2), (SPEECH_BUTTON_WIDTH / 2), (SPEECH_BUTTON_HEIGHT / 2))];
        [btnSpeech setBackgroundImage:[UIImage imageNamed:@"btn_speech.png"] forState:UIControlStateNormal];
        [btnSpeech setBackgroundImage:[UIImage imageNamed:@"btn_speech.png"] forState:UIControlStateHighlighted];
        [btnSpeech addTarget:self action:@selector(btnSpeechPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnSpeech];
    }
    
    SwitchButton *sb1 = [CameraSwitchButton buttonWithPoint:CGPointMake(0, 0) owner:self.ownerController];
    sb1.status = @"on";
    sb1.title = @"摄像头";
    
    SwitchButton *sb2 = [AirconditionSwitchButton buttonWithPoint:CGPointMake(0, 0) owner:self.ownerController];
    sb2.status = @"on";
    sb2.title = @"客厅空调";
    
    SwitchButton *sb3 = [CameraSwitchButton buttonWithPoint:CGPointMake(0, 0) owner:self.ownerController];
    sb3.status = @"on";
    sb3.title = @"摄像头";
    
    SwitchButton *sb4 = [CameraSwitchButton buttonWithPoint:CGPointMake(0, 0) owner:self.ownerController];
    sb4.status = @"on";
    sb4.title = @"摄像头";
    
    SwitchButton *sb5 = [CameraSwitchButton buttonWithPoint:CGPointMake(0, 0) owner:self.ownerController];
    sb5.status = @"on";
    sb5.title = @"摄像头";
    
    SwitchButton *sb6 = [CameraSwitchButton buttonWithPoint:CGPointMake(0, 0) owner:self.ownerController];
    sb6.status = @"on";
    sb6.title = @"摄像头";
    
    SwitchButton *sb7 = [CameraSwitchButton buttonWithPoint:CGPointMake(0, 0) owner:self.ownerController];
    sb7.status = @"on";
    sb7.title = @"摄像头";
    
    SwitchButton *sb8 = [ToggleSwitchButton buttonWithPoint:CGPointMake(0, 0) owner:self.ownerController];
    sb8.status = @"on";
    sb8.title = @"开关";
    
    SwitchButton *sb9 = [CameraSwitchButton buttonWithPoint:CGPointMake(0, 0) owner:self.ownerController];
    sb9.status = @"off";
    sb9.title = @"摄像头";
    
    SwitchButton *sb10 = [AirconditionSwitchButton buttonWithPoint:CGPointMake(0, 0) owner:self.ownerController];
    sb10.status = @"on";
    sb10.title = @"卧室空调";
    
    SwitchButton *sb11 = [AirconditionSwitchButton buttonWithPoint:CGPointMake(0, 0) owner:self.ownerController];
    sb11.status = @"off";
    sb11.title = @"卧室空调";
    
    SwitchButton *sb12 = [TVSwitchButton buttonWithPoint:CGPointMake(0, 0) owner:self.ownerController];
    sb12.status = @"on";
    sb12.title = @"电视机";
    
    SwitchButton *sb13 = [AirconditionSwitchButton buttonWithPoint:CGPointMake(0, 0) owner:self.ownerController];
    sb13.status = @"off";
    sb13.title = @"卧室空调";

    SwitchButton *sb14 = [AirconditionSwitchButton buttonWithPoint:CGPointMake(0, 0) owner:self.ownerController];
    sb14.status = @"on";
    sb14.title = @"卧室空调";
    
    SwitchButton *sb15 = [AirconditionSwitchButton buttonWithPoint:CGPointMake(0, 0) owner:self.ownerController];
    sb15.status = @"off";
    sb15.title = @"卧室空调";
    
    SwitchButton *sb16 = [AirconditionSwitchButton buttonWithPoint:CGPointMake(0, 0) owner:self.ownerController];
    sb16.status = @"off";
    sb16.title = @"卧室空调";

    
    NSArray *devices1 = [[NSArray alloc] initWithObjects:sb1,nil];
    NSArray *devices2 = [[NSArray alloc] initWithObjects:sb2,sb3,nil];
    NSArray *devices3 = [[NSArray alloc] initWithObjects:sb4,sb5,sb6,nil];
    NSArray *devices4 = [[NSArray alloc] initWithObjects:sb7,sb8,sb9,sb10,sb11, sb12, sb13,sb14,sb15,sb16, nil];

    NSArray *objArr = [[NSArray alloc] initWithObjects:devices1,devices2,devices3,devices4, nil];
    NSArray *keyArr = [[NSArray alloc] initWithObjects:@"客厅",@"主卧",@"次卧",@"安防", nil];
    NSDictionary *scrollDictionary = [[NSDictionary alloc] initWithObjects:objArr forKeys:keyArr];
    
    if(pageableScrollView == nil) {
        pageableScrollView = [[PageableScrollView alloc] initWithPoint:CGPointMake(0, 170) andDictionary:scrollDictionary];
        pageableScrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:pageableScrollView];
        [self addSubview:pageableScrollView.pageNavView];
    }
}

#pragma mark -
#pragma mark notification && affect button

- (void)btnShowNotificationDevicePressed:(id)sender {
    NotificationViewController *notificationViewController = [[NotificationViewController alloc] init];
    [self.ownerController.navigationController pushViewController:notificationViewController animated:YES];
}

#pragma mark -
#pragma mark speech view

- (void)showSpeechView {
    if(speechViewState != SpeechViewStateClosed) return;
    ConversationView *view = (ConversationView *)[self viewWithTag:SPEECH_VIEW_TAG];
    if(view == nil) {
        view = [self speechView];
        [self addSubview:view];
    }
    speechViewState = SpeechViewStateOpenning;
    [self.ownerController disableGestureForDrawerView];
    [UIView animateWithDuration:0.3f
                animations:^{
                    view.frame = CGRectMake(view.frame.origin.x, 12, view.frame.size.width, view.frame.size.height);
                }
                completion:^(BOOL finished) {
                    speechViewState = SpeechViewStateOpenned;
                    if(speechView.messageCount == 0) [speechView showWelcomeMessage];
                    [self btnSpeechRecordingPressed:nil];
                }];
}

- (void)hideSpeechView {
    if(speechViewState != SpeechViewStateOpenned) return;
    CGFloat viewHeight = self.frame.size.height - SPEECH_BUTTON_HEIGHT / 2 - 12;
    ConversationView *view = [self speechView];
    speechViewState = SpeechViewStateClosing;
    [UIView animateWithDuration:0.3f
                     animations:^{
                         view.frame = CGRectMake(view.frame.origin.x, (0 - viewHeight - 12), view.frame.size.width, view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         [[self speechView] hideWelcomeMessage];
                         [[self speechView] removeFromSuperview];
                         [self.ownerController enableGestureForDrawerView];
                         speechViewState = SpeechViewStateClosed;
                     }];
}

#pragma mark -
#pragma mark speech control

- (void)btnSpeechPressed:(id)sender {
    if(speechViewState == SpeechViewStateClosed) {
        [self showSpeechView];
    } else if(speechViewState ==  SpeechViewStateOpenned) {
        [self btnSpeechRecordingPressed:sender];
    }
}

- (void)btnSpeechRecordingPressed:(id)sender {    
    if(recognizerState == RecognizerStateReady) {
        recognizerState = RecognizerStateRecordBegin;
        AudioServicesPlaySystemSound(RECORD_BEGIN_SOUND_ID);
        [self delayStartListening];
    } else if(recognizerState == RecognizerStateRecording) {
        [speechRecognitionUtil stopListening];
    }
}

// 确保录音提示音已经结束,防止提示语进入识别范围
- (void)delayStartListening {
    [NSTimer scheduledTimerWithTimeInterval:DELAY_START_LISTENING_DURATION target:self selector:@selector(startListening:) userInfo:nil repeats:NO];
}

- (void)startListening:(NSTimer *)timer {
    [speechRecognitionUtil startListening];
}

#pragma mark -
#pragma mark speech recognizer notification delegate

- (void)beginRecord {
    recognizerState = RecognizerStateRecording;
}

- (void)endRecord {
    AudioServicesPlaySystemSound(RECORD_END_SOUND_ID);
    recognizerState = RecognizerStateRecordingEnd;
}

- (void)recognizeCancelled {
}

- (void)speakerVolumeChanged:(int)volume {
}

- (void)recognizeSuccess:(NSString *)result {
    if(![NSString isBlank:result]) {
        ConversationTextMessage *textMessage = [[ConversationTextMessage alloc] init];
        textMessage.messageOwner = MESSAGE_OWNER_MINE;
        textMessage.textMessage = result;
        [speechView addMessage:textMessage];
        //process text message
    } else {
        [self speechRecognizerFailed:@"empty speaking..."];
        //
    }
    recognizerState = RecognizerStateReady;
}

- (void)recognizeError:(int)errorCode {
    [self speechRecognizerFailed:[NSString stringWithFormat:@"error code is %d", errorCode]];
    recognizerState = RecognizerStateReady;
}

- (void)speechRecognizerFailed:(NSString *)message {
    NSLog(@"need alert fail the error message is : [   %@  ]", message);
}

#pragma mark -
#pragma mark text message processor delegate



#pragma mark -
#pragma mark getter and setters

- (ConversationView *)speechView {
    if(speechView == nil) {
        CGFloat viewHeight = self.frame.size.height - SPEECH_BUTTON_HEIGHT/2 - 10 - 10;
        speechView = [[ConversationView alloc] initWithFrame:CGRectMake(0, (0 - viewHeight - 12), 601/2, viewHeight) andContainerView:self];
        speechView.center = CGPointMake(self.center.x, speechView.center.y);
        speechView.tag = SPEECH_VIEW_TAG;
    }
    return speechView;
}

@end
