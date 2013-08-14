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
#import "DeviceAffectViewController.h"

#define SPEECH_VIEW_TAG       46001
#define SPEECH_BUTTON_WIDTH   75
#define SPEECH_BUTTON_HEIGHT  111

@implementation MainView {
    SpeechViewState speechViewState;
    RecognizerState recognizerState;
    ConversationView *speechView;
    SpeechRecognitionUtil *speechRecognitionUtil;
    
    UIButton *btnSpeech;
    UIButton *btnShowNotification;
    UIButton *btnShowAffectDevice;
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

    if(btnShowAffectDevice == nil) {
        btnShowAffectDevice = [[UIButton alloc] initWithFrame:CGRectMake(200, 150, 120, 30)];
        [btnShowAffectDevice setTitle:@"影响" forState:UIControlStateNormal];
        [btnShowAffectDevice addTarget:self action:@selector(btnShowAffectDevicePressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnShowAffectDevice];
    }
    
    if(btnShowNotification == nil) {
        btnShowNotification = [[UIButton alloc] initWithFrame:CGRectMake(200, 200, 120, 30)];
        [btnShowNotification setTitle:@"通知" forState:UIControlStateNormal];
        [btnShowNotification addTarget:self action:@selector(btnShowNotificationDevicePressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnShowNotification];
    }
    
    if(btnSpeech == nil) {
        btnSpeech = [[UIButton alloc] initWithFrame:CGRectMake(((self.frame.size.width - SPEECH_BUTTON_WIDTH/2) / 2), (self.frame.size.height - SPEECH_BUTTON_HEIGHT / 2 - 10), (SPEECH_BUTTON_WIDTH / 2), (SPEECH_BUTTON_HEIGHT / 2))];
        [btnSpeech setBackgroundImage:[UIImage imageNamed:@"record_animate_00.png"] forState:UIControlStateNormal];
        [btnSpeech addTarget:self action:@selector(btnSpeechPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnSpeech];
    }
}

#pragma mark -
#pragma mark notification && affect button

- (void)btnShowAffectDevicePressed:(id)sender {
    DeviceAffectViewController *deviceAffectViewController = [[DeviceAffectViewController alloc] init];
    [self.ownerController.navigationController pushViewController:deviceAffectViewController animated:YES];
}

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
                    view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height);
                }
                completion:^(BOOL finished) {
                    speechViewState = SpeechViewStateOpenned;
                    if(speechView.messageCount == 0) [speechView showWelcomeMessage];
                    [self btnSpeechRecordingPressed:nil];
                }];
}

- (void)hideSpeechView {
    if(speechViewState != SpeechViewStateOpenned) return;
    CGFloat viewHeight = self.frame.size.height - SPEECH_BUTTON_HEIGHT / 2 - 20;
    ConversationView *view = [self speechView];
    speechViewState = SpeechViewStateClosing;
    [UIView animateWithDuration:0.3f
                     animations:^{
                         view.frame = CGRectMake(0, (0 - viewHeight), view.frame.size.width, view.frame.size.height);
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
        AudioServicesPlaySystemSound(1113);
        [speechRecognitionUtil startListening];
    } else if(recognizerState == RecognizerStateRecordBegin) {
        [speechRecognitionUtil stopListening];
    }
}

- (void)speechRecognizerFailed:(NSString *)message {
    
}

#pragma mark - 
#pragma mark play system sound

- (void)go {
//    
//    NSLog(@"2");
//    SystemSoundID soundID;
////    NSURL* soundURL = [[NSURL alloc]initWithString:@"test.wav"];
//    
//    NSString *sndpath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"wav"];
//    CFURLRef soundURL = (__bridge CFURLRef)[[NSURL alloc] initFileURLWithPath:sndpath];
//    
//    
//    OSStatus err = AudioServicesCreateSystemSoundID(soundURL, &soundID);
//    if (err) {
//        
//        NSLog(@"Error occurred assigning system sound!");
//        return;
//    }
////    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundFinished, soundURL);
//    AudioServicesPlaySystemSound(soundID);
//    CFRunLoopRun();
}

#pragma mark -
#pragma mark speech recognizer notification delegate

- (void)beginRecord {
    recognizerState = RecognizerStateRecordBegin;
}

- (void)endRecord {
    AudioServicesPlaySystemSound(1114);
    recognizerState = RecognizerStateRecordEnd;
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
        [self speechRecognizerFailed:nil];
        //
    }
    recognizerState = RecognizerStateReady;
}

- (void)recognizeError:(int)errorCode {
    NSLog(@"need alert error ,,, the code is %d", errorCode);
    
    [self speechRecognizerFailed:nil];
    recognizerState = RecognizerStateReady;
}

#pragma mark -
#pragma mark text message processor delegate



#pragma mark -
#pragma mark getter and setters

- (ConversationView *)speechView {
    if(speechView == nil) {
        CGFloat viewHeight = self.frame.size.height - 111/2 - 20;
        speechView = [[ConversationView alloc] initWithFrame:CGRectMake(0, (0 - viewHeight), self.frame.size.width, viewHeight) andContainerView:self];
        speechView.tag = SPEECH_VIEW_TAG;
    }
    return speechView;
}

@end
