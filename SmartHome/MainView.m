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
#import "JsonUtils.h"
#import "CommandFactory.h"
#import "DeviceCommandUpdateAccount.h"

#define SPEECH_VIEW_TAG                  46001
#define SPEECH_BUTTON_WIDTH              195
#define SPEECH_BUTTON_HEIGHT             198
#define DELAY_START_LISTENING_DURATION   0.6f
#define RECORD_BEGIN_SOUND_ID            1113
#define RECORD_END_SOUND_ID              1114

@implementation MainView {
    NSArray *navItems;    
    SpeechViewState speechViewState;
    RecognizerState recognizerState;
    ConversationView *speechView;
    SpeechRecognitionUtil *speechRecognitionUtil;
    PageableScrollView *pageableScrollView;
    PageableNavView *pageableNavView;
    UIView *notificationView;
    UIButton *btnSpeech;
    

}

@synthesize unitsArr;
@synthesize defaultUnit;

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
    


    self.unitsArr = [SMShared current].memory.units;
    self.defaultUnit = [self setDefaultUnitDictionary:self.unitsArr];
}

- (void)initUI {
    [super initUI];
    CGFloat bottom = self.bounds.size.height;
    
    if(btnSpeech == nil) {
        btnSpeech = [[UIButton alloc] initWithFrame:CGRectMake(((self.frame.size.width - SPEECH_BUTTON_WIDTH/2) / 2), (self.frame.size.height - SPEECH_BUTTON_HEIGHT / 2), (SPEECH_BUTTON_WIDTH / 2), (SPEECH_BUTTON_HEIGHT / 2))];
        [btnSpeech setBackgroundImage:[UIImage imageNamed:@"btn_speech.png"] forState:UIControlStateNormal];
        [btnSpeech setBackgroundImage:[UIImage imageNamed:@"btn_speech.png"] forState:UIControlStateHighlighted];
        [btnSpeech addTarget:self action:@selector(btnSpeechPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnSpeech];
    }
    
    /* mock data begin -------------- */
    
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
    
     /* mock data end -------------- */
    
    if(pageableScrollView == nil) {
        pageableScrollView = [[PageableScrollView alloc] initWithPoint:CGPointMake(0, (bottom - 198 / 2 - 190)) andDictionary:scrollDictionary];
        pageableScrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:pageableScrollView];
        [self addSubview:pageableScrollView.pageNavView];
    }
    
    if(notificationView == nil) {
        notificationView = [[UIView alloc] initWithFrame:CGRectMake(10, (pageableScrollView.frame.origin.y - 40 - 25/2), [UIScreen mainScreen].bounds.size.width, 40)];
        
        UIButton *btnMessage = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 25/2, 30/2)];
        btnMessage.center = CGPointMake(btnMessage.center.x, notificationView.bounds.size.height / 2);
        [btnMessage setBackgroundImage:[UIImage imageNamed:@"icon_sound"] forState:UIControlStateNormal];
        [btnMessage addTarget:self action:@selector(testCommand) forControlEvents:UIControlEventTouchUpInside];
        [notificationView addSubview:btnMessage];
    
        UILabel *lblMessage = [[UILabel alloc]initWithFrame:CGRectMake(btnMessage.frame.origin.x+25/2+15,btnMessage.frame.origin.y-10, 120, 20)];
        lblMessage.backgroundColor = [UIColor clearColor];
        lblMessage.font = [UIFont systemFontOfSize:14];
        lblMessage.text = @"有人闯入房屋!";
        lblMessage.textColor = [UIColor lightTextColor];
        [notificationView addSubview:lblMessage];
    
        UILabel *lblTime = [[UILabel alloc]initWithFrame:CGRectMake(lblMessage.frame.origin.x, lblMessage.frame.origin.y+lblMessage.frame.size.height, 100, 10)];
        lblTime.backgroundColor =[UIColor clearColor];
        lblTime.text = @"16:54pm";
        lblTime.font = [UIFont systemFontOfSize:12];
        lblTime.textColor = [UIColor lightTextColor];
        [notificationView addSubview: lblTime];
        
        UIImageView *imgAffectDevice = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"device_count.png"]];
        imgAffectDevice.frame = CGRectMake(lblMessage.frame.origin.x+lblMessage.frame.size.width + 40, 0, 44/2, 46/2);
        imgAffectDevice.center = CGPointMake(imgAffectDevice.center.x, notificationView.bounds.size.height / 2);
        [notificationView addSubview:imgAffectDevice];
        
        UILabel *lblAffectDevice = [[UILabel alloc] initWithFrame:CGRectMake(imgAffectDevice.frame.origin.x+imgAffectDevice.frame.size.width + 5, 0, 20, 20)];
        lblAffectDevice.center = CGPointMake(lblAffectDevice.center.x, notificationView.bounds.size.height / 2);
        lblAffectDevice.text = @"5";
        lblAffectDevice.textColor = [UIColor colorWithHexString:@"dfa800"];
        lblAffectDevice.font = [UIFont systemFontOfSize:14];
        lblAffectDevice.backgroundColor = [UIColor clearColor];
        [notificationView addSubview:lblAffectDevice];
    
        UIImageView *imgMessageCount = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_count.png"]];
        imgMessageCount.frame = CGRectMake(lblAffectDevice.frame.origin.x+30, 0, 44/2, 46/2);
        imgMessageCount.center = CGPointMake(imgMessageCount.center.x, notificationView.bounds.size.height / 2);
        [notificationView addSubview:imgMessageCount];
    
        UILabel *lblMessageCount = [[UILabel alloc] initWithFrame:CGRectMake(imgMessageCount.frame.origin.x+imgMessageCount.frame.size.width+5, 0, 20, 20)];
        lblMessageCount.center = CGPointMake(lblMessageCount.center.x, notificationView.bounds.size.height /2 );
        lblMessageCount.text = @"5";
        lblMessageCount.textColor = [UIColor colorWithHexString:@"dfa800"];
        lblMessageCount.backgroundColor = [UIColor clearColor];
        lblMessageCount.font = [UIFont systemFontOfSize:14];
        [notificationView addSubview:lblMessageCount];
        
        [self addSubview:notificationView];
    }
}

#pragma mark -
#pragma mark units view

-(void)updateUnits:(NSArray *)units{
    self.unitsArr = units;
    [self setDefaultUnitDictionary:units];
    
    CGPoint point = pageableScrollView.frame.origin;
    [pageableScrollView removeFromSuperview];
    [pageableNavView removeFromSuperview];
    
    pageableScrollView = nil;
    pageableNavView = nil;
    
    pageableScrollView = [[PageableScrollView alloc] initWithPoint:point andDictionary:defaultUnit];
    pageableScrollView.backgroundColor = [UIColor clearColor];
    [self addSubview:pageableScrollView];
    [self addSubview:pageableScrollView.pageNavView];
}

-(NSDictionary *) setDefaultUnitDictionary:(NSArray *) units{
    return nil;
    /*
    if(units == nil || units.count == 0) return nil;
    
    NSDictionary *zones = [[units objectAtIndex:0] zones];
    NSEnumerator *enumerator = zones.keyEnumerator;
    NSMutableArray *objects = [NSMutableArray new];
    NSMutableArray *keys = [NSMutableArray new];
    for (NSString *key in enumerator) {
        Zone *zone = [zones objectForKey:key];
        [keys addObject:zone.name];
        NSMutableArray *switchBtns = [NSMutableArray new];
        NSArray *accessories = [zone devicesAsList];
        for (Device *device in accessories) {
            SwitchButton *sb = [CameraSwitchButton buttonWithPoint:CGPointMake(0, 0) owner:self.ownerController];
            sb.status = device.status;
            sb.title = device.name;
            [switchBtns addObject:sb];
        }
        [objects addObject:switchBtns];
    }
    NSDictionary *deviceDictionary = [[NSDictionary alloc] initWithObjects:objects forKeys:keys];
    return deviceDictionary;*/
}

- (void) testCommand{
    NSString *json = @"{\"zkList\":[{\"identifier\":\"123\",\"name\":\"永安小区\",\"localIP\":\"172.16.8.16\",\"updateTime\":\"2013.9.1\",\"zones\":{\"zone1\":{\"name\":\"客厅\",\"accessories\":{\"device1\":{\"eleState\":\"on\",\"label\":\"空调\",\"mac\":\"fffff\",\"name\":\"客厅空调\",\"status\":\"正常\",\"type\":\"1\"},\"device2\":{\"eleState\":\"on\",\"label\":\"摄像头\",\"mac\":\"fffff\",\"name\":\"客厅摄像头\",\"status\":\"正常\",\"type\":\"1\"},\"device3\":{\"eleState\":\"on\",\"label\":\"空调\",\"mac\":\"fffff\",\"name\":\"客厅空调\",\"status\":\"正常\",\"type\":\"1\"}}}}}],\"appKey\":\"\",\"deviceCode\":\"\",\"result\":\"\",\"commandName\":\"\",\"masterDeviceCode\":\"\",\"commandTime\":\"\",\"tcpAddress\":\"\",\"security\":\"\"}";
    
    NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
    
    DeviceCommand *command = [[DeviceCommandUpdateUnits alloc] initWithDictionary:[JsonUtils createDictionaryFromJson:data]];

}

#pragma mark -
#pragma mark notification 

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
