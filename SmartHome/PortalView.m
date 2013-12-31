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
#import "XXEventSubscriptionPublisher.h"
#import "XXEventFilterChain.h"
#import "DeviceCommandNameEventFilter.h"
#import "SMDateFormatter.h"
#import "XXEventNameFilter.h"
#import "EventNameContants.h"
#import "UnitsListUpdatedEvent.h"
#import "NotificationsFileUpdatedEvent.h"
#import "NetworkModeChangedEvent.h"
#import "DeviceStatusChangedEvent.h"
#import "CurrentUnitChangedEvent.h"

#define SPEECH_BUTTON_WIDTH              173
#define SPEECH_BUTTON_HEIGHT             173

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
    
    
    // 语音识别
    UIButton *btnSpeech;
    UIImageView *imgSpeechVolumnAffect;
    SpeechViewState speechViewState;
    RecognizerState recognizerState;
    ConversationView *speechView;
    SpeechRecognitionUtil *speechRecognitionUtil;
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
    
    speechViewState = SpeechViewStateClosed;
    recognizerState = RecognizerStateReady;
}

- (void)initUI {
    [super initUI];
    
    [self.topbar.rightButton setBackgroundImage:[UIImage imageNamed:@"btn_drawer_unit"] forState:UIControlStateNormal];
    [self.topbar.rightButton setBackgroundImage:[UIImage imageNamed:@"btn_drawer_unit"] forState:UIControlStateHighlighted];
    
    [self.topbar.rightButton addTarget:self action:@selector(showUnitSelectionDrawerView:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat toMinusHeight = [UIDevice systemVersionIsMoreThanOrEuqal7] ? 0 : 20;
    
    btnShowNotification = [[UIButton alloc] initWithFrame:CGRectMake(180, 94 - toMinusHeight, 30, 21)];
    [btnShowNotification setBackgroundImage:[UIImage imageNamed:@"icon_new_msg"] forState:UIControlStateNormal];
    [btnShowNotification setBackgroundImage:[UIImage imageNamed:@"icon_new_msg"] forState:UIControlStateHighlighted];
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
    [btnSceneBack setBackgroundImage:[UIImage imageNamed:@"btn_home_unselected"] forState:UIControlStateHighlighted];
    btnSceneBack.longPressDelegate = self;
    [btnSceneBack addTarget:self action:@selector(btnScenePressed:) forControlEvents:UIControlEventTouchUpInside];
//    UIImageView *imgBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_back"]];
//    imgBack.center = CGPointMake(btnSceneBack.center.x, 250 - toMinusHeight);
//    [self addSubview:imgBack];
    
    btnSceneOut = [[SMButton alloc] initWithFrame:CGRectMake(199, 140 - toMinusHeight, 86, 86)];
    btnSceneOut.identifier = SCENE_MODE_OUT;
    [btnSceneOut setBackgroundImage:[UIImage imageNamed:@"btn_out_unselected"] forState:UIControlStateHighlighted];
    [btnSceneOut setParameter:NSLocalizedString(@"scene_out", @"") forKey:@"name"];
    btnSceneOut.longPressDelegate = self;
    [btnSceneOut addTarget:self action:@selector(btnScenePressed:) forControlEvents:UIControlEventTouchUpInside];
//    UIImageView *imgOut = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_out"]];
//    imgOut.center = CGPointMake(btnSceneOut.center.x, 250 - toMinusHeight);
//    [self addSubview:imgOut];
    
    btnSceneGetUp = [[SMButton alloc] initWithFrame:CGRectMake(45, 260 - toMinusHeight, 86, 86)];
    btnSceneGetUp.identifier = SCENE_MODE_GET_UP;
    [btnSceneGetUp setBackgroundImage:[UIImage imageNamed:@"btn_get_up_unselected"] forState:UIControlStateHighlighted];
    [btnSceneGetUp setParameter:NSLocalizedString(@"scene_get_up", @"") forKey:@"name"];
    btnSceneGetUp.longPressDelegate = self;
    [btnSceneGetUp addTarget:self action:@selector(btnScenePressed:) forControlEvents:UIControlEventTouchUpInside];
//    UIImageView *imgGetUp = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_get_up"]];
//    imgGetUp.center = CGPointMake(btnSceneGetUp.center.x, 410 - toMinusHeight);
//    [self addSubview:imgGetUp];
    
    btnSceneSleep = [[SMButton alloc] initWithFrame:CGRectMake(199, 260 - toMinusHeight, 86, 86)];
    btnSceneSleep.identifier = SCENE_MODE_SLEEP;
    [btnSceneSleep setBackgroundImage:[UIImage imageNamed:@"btn_sleep_unselected"] forState:UIControlStateHighlighted];
    [btnSceneSleep setParameter:NSLocalizedString(@"scene_sleep", @"") forKey:@"name"];
    btnSceneSleep.longPressDelegate = self;
    [btnSceneSleep addTarget:self action:@selector(btnScenePressed:) forControlEvents:UIControlEventTouchUpInside];
//    UIImageView *imgSleep = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"img_sleep"]];
//    imgSleep.center = CGPointMake(btnSceneSleep.center.x, 410 - toMinusHeight);
//    [self addSubview:imgSleep];
 
    [self addSubview:btnSceneBack];
    [self addSubview:btnSceneOut];
    [self addSubview:btnSceneGetUp];
    [self addSubview:btnSceneSleep];
    
#pragma mark -
#pragma mark Speech view

    imgSpeechVolumnAffect = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.frame.size.height - SPEECH_BUTTON_HEIGHT / 2), 417 / 2, 195 / 2)];
    NSMutableArray *animateImages = [NSMutableArray arrayWithCapacity:5];
    for(int i=1; i<=5; i++) {
        NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"sp-a-%d@2x", i] ofType:@"png"];
        [animateImages addObject:[UIImage imageWithContentsOfFile:filePath]];
    }
    imgSpeechVolumnAffect.animationImages = animateImages;
    imgSpeechVolumnAffect.animationDuration = 1.5f;
    imgSpeechVolumnAffect.hidden = YES;
    [self addSubview:imgSpeechVolumnAffect];

    btnSpeech = [[UIButton alloc] initWithFrame:CGRectMake(((self.frame.size.width - SPEECH_BUTTON_WIDTH/2) / 2), (self.frame.size.height - SPEECH_BUTTON_HEIGHT / 2 - 7), (SPEECH_BUTTON_WIDTH / 2), (SPEECH_BUTTON_HEIGHT / 2))];
    [btnSpeech setBackgroundImage:[UIImage imageNamed:@"btn_speech.png"] forState:UIControlStateNormal];
    [btnSpeech setBackgroundImage:[UIImage imageNamed:@"btn_speech.png"] forState:UIControlStateHighlighted];
    
    [btnSpeech addTarget:self action:@selector(btnSpeechTouchDown:) forControlEvents:UIControlEventTouchDown];
    [btnSpeech addTarget:self action:@selector(btnSpeechTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [btnSpeech addTarget:self action:@selector(btnSpeechTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
    [btnSpeech addTarget:self action:@selector(btnSpeechTouchDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
    [btnSpeech addTarget:self action:@selector(btnSpeechTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];
    
    [self addSubview:btnSpeech];
    
    imgSpeechVolumnAffect.center = CGPointMake(160, btnSpeech.center.y - 1);
}

- (void)setUp {
    XXEventSubscription *subscription = [[XXEventSubscription alloc] initWithSubscriber:self];
    subscription.notifyMustInMainThread = YES;
    
    DeviceCommandNameEventFilter *commandNameFilter = [[DeviceCommandNameEventFilter alloc] init];
    [commandNameFilter.supportedCommandNames addObject:COMMAND_VOICE_CONTROL];
    
    XXEventNameFilter *eventNameFilter = [[XXEventNameFilter alloc] init];
    [[[[[eventNameFilter addSupportedEventName:EventCurrentUnitChanged]
      addSupportedEventName:EventUnitsListUpdated]
      addSupportedEventName:EventNotificationsFileUpdated]
      addSupportedEventName:EventNetworkModeChanged]
      addSupportedEventName:EventDeviceStatusChanged];
    
    XXEventFilterChain *eventFilterChain = [[XXEventFilterChain alloc] init];
    [[eventFilterChain orFilter:commandNameFilter] orFilter:eventNameFilter];
    subscription.filter = eventFilterChain;
    [[XXEventSubscriptionPublisher defaultPublisher] subscribeFor:subscription];
    [self updateScenePlanForCurrentUnit];
}

- (void)destory {
    [[XXEventSubscriptionPublisher defaultPublisher] unSubscribeForSubscriber:self];
    [plans removeAllObjects];
}

- (void)viewBecomeActive {
    if(self.ownerController != nil) {
        self.ownerController.rightViewEnable = YES;
    }
    
    // On matter the view become active how many times,
    // Only refresh units && notifications once from this method
    
    if(!unitHasNotifyUpdateAtLeastOnce) {
        unitHasNotifyUpdateAtLeastOnce = YES;
        [self xxEventPublisherNotifyWithEvent:[[UnitsListUpdatedEvent alloc] init]];
    }
    
    if(!notificationHasUpdateAtLeastOnce) {
        notificationHasUpdateAtLeastOnce = YES;
        [self updateNotifications];
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
#pragma mark Event Subscriber

- (void)xxEventPublisherNotifyWithEvent:(XXEvent *)event {
    if([event isKindOfClass:[CurrentUnitChangedEvent class]]) {
        [self updateStatusDisplay];
        [self updateScenePlanForCurrentUnit];
    } else if([event isKindOfClass:[UnitsListUpdatedEvent class]]) {
        @synchronized(self) {
            unitHasNotifyUpdateAtLeastOnce = YES;
            [self updateStatusDisplay];
            [self updateUnitSelectionView];
        }
    } else if([event isKindOfClass:[NotificationsFileUpdatedEvent class]]) {
        [self updateNotifications];
    } else if([event isKindOfClass:[NetworkModeChangedEvent class]]) {
        NetworkModeChangedEvent *evet = (NetworkModeChangedEvent *)event;
        [self networkStateChanged:evet.networkMode];
    } else if([event isKindOfClass:[DeviceStatusChangedEvent class]]) {
        DeviceStatusChangedEvent *evt = (DeviceStatusChangedEvent *)event;
        [self updateDevicesStatus:evt.command];
    } else {
        DeviceCommandEvent *evt = (DeviceCommandEvent *)event;
        if([evt.command isKindOfClass:[DeviceCommandVoiceControl class]]) {
            DeviceCommandVoiceControl *cmd = (DeviceCommandVoiceControl *)evt.command;
            [self notifyVoiceControlAccept:cmd];
        }
    }
}

- (NSString *)xxEventSubscriberIdentifier {
    return @"portalViewSubscriber";
}

#pragma mark -
#pragma mark Network State

- (void)networkStateChanged:(NetworkMode)lastedNetwokMode {
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
#pragma mark Notifications

- (void)updateNotifications {
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
    [self updateNotifications];
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
            [[AlertView currentAlertView] setMessage:NSLocalizedString(@"scene_execute", @"") forType:AlertViewTypeSuccess];
            [[AlertView currentAlertView] alertAutoDisappear:YES lockView:nil];
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
        plan.name = NSLocalizedString(@"scene_home", @"");
    } else if([SCENE_MODE_GET_UP isEqualToString:planId]) {
        [btnSceneGetUp setParameter:hasSet ? @"yes" : @"no" forKey:@"hasPlan"];
        [btnSceneGetUp setBackgroundImage:[UIImage imageNamed:hasSet ? @"btn_get_up" :@"btn_get_up_unset"] forState:UIControlStateNormal];
        plan.name = NSLocalizedString(@"scene_get_up", @"");
    } else if([SCENE_MODE_OUT isEqualToString:planId]) {
        [btnSceneOut setParameter:hasSet ? @"yes" : @"no" forKey:@"hasPlan"];
        [btnSceneOut setBackgroundImage:[UIImage imageNamed:hasSet ? @"btn_out" : @"btn_out_unset"] forState:UIControlStateNormal];
        plan.name = NSLocalizedString(@"scene_out", @"");
    } else if([SCENE_MODE_SLEEP isEqualToString:planId]) {
        [btnSceneSleep setParameter:hasSet ? @"yes" : @"no" forKey:@"hasPlan"];
        [btnSceneSleep setBackgroundImage:[UIImage imageNamed:hasSet ? @"btn_sleep" : @"btn_sleep_unset"] forState:UIControlStateNormal];
        plan.name = NSLocalizedString(@"scene_sleep", @"");
    }
}


#pragma mark -
#pragma mark speech view

- (void)notifyVoiceControlAccept:(DeviceCommandVoiceControl *)command {
    if(command == nil || speechView == nil) return;
    if(speechViewState == SpeechViewStateOpenned) {
        ConversationTextMessage *textMessage = [[ConversationTextMessage alloc] init];
        textMessage.messageOwner = MESSAGE_OWNER_MINE;
        textMessage.textMessage = command.voiceText;
        textMessage.timeMessage = [SMDateFormatter dateToString:[NSDate date] format:@"HH:mm:ss"];
        [speechView addMessage:textMessage];
        if(command.resultID != 1) {
            ConversationTextMessage *textMessage = [[ConversationTextMessage alloc] init];
            textMessage.messageOwner = MESSAGE_OWNER_THEIRS;
            textMessage.textMessage = command.describe;
            textMessage.timeMessage = [SMDateFormatter dateToString:[NSDate date] format:@"HH:mm:ss"];
            [speechView addMessage:textMessage];
        }
    }
}

- (void)updateDevicesStatus:(DeviceCommandUpdateDevices *)command {
    if([NSString isBlank:command.voiceText] || speechView == nil) return;
    
    NSString *successMsg = [NSString stringWithFormat:@"[%@]", NSLocalizedString(@"execution_success", @"")] ;
    NSString *successErr = [NSString stringWithFormat:@"[%@]", NSLocalizedString(@"execution_failed", @"")] ;
    NSString *executeResult = (command.resultID == 1) ? successMsg : successErr;
    
    if(speechViewState == SpeechViewStateOpenned) {
        ConversationTextMessage *textMessage = [[ConversationTextMessage alloc] init];
        textMessage.messageOwner = MESSAGE_OWNER_THEIRS;
        textMessage.textMessage = [NSString stringWithFormat:@"%@ %@", command.voiceText, executeResult];
        textMessage.timeMessage = [SMDateFormatter dateToString:[NSDate date] format:@"HH:mm:ss"];
        [speechView addMessage:textMessage];
    }
}

- (void)showSpeechView {
    if(speechViewState != SpeechViewStateClosed) return;
    
    speechViewState = SpeechViewStateOpenning;
    [self.ownerController disableGestureForDrawerView];
    
    ConversationView *view = [self speechView];
    [self addSubview:view];
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         view.frame = CGRectMake(view.frame.origin.x, ([UIDevice systemVersionIsMoreThanOrEuqal7] ? 22 : 12), view.frame.size.width, view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         speechViewState = SpeechViewStateOpenned;
                         if(speechView.messageCount == 0) [speechView showWelcomeMessage];
                     }];
}

- (void)hideSpeechView {
    if(speechViewState != SpeechViewStateOpenned) return;
    
    if(recognizerState != RecognizerStateReady) {
        [speechRecognitionUtil stopListening];
    }
    
    speechViewState = SpeechViewStateClosing;
    [self.ownerController enableGestureForDrawerView];
    
    CGFloat viewHeight = self.frame.size.height - SPEECH_BUTTON_HEIGHT / 2 - ([UIDevice systemVersionIsMoreThanOrEuqal7] ? 22 : 12);
    ConversationView *view = [self speechView];
    
    [UIView animateWithDuration:0.3f
                     animations:^{
                         view.frame = CGRectMake(view.frame.origin.x, (0 - viewHeight - ([UIDevice systemVersionIsMoreThanOrEuqal7] ? 22 : 12)), view.frame.size.width, view.frame.size.height);
                     }
                     completion:^(BOOL finished) {
                         [[self speechView] clearMessages];
                         [[self speechView] hideWelcomeMessage];
                         [[self speechView] removeFromSuperview];
                         speechViewState = SpeechViewStateClosed;
                     }];
}

- (void)startSpeechAnimate {
    if(imgSpeechVolumnAffect != nil) {
        imgSpeechVolumnAffect.hidden = NO;
        if(!imgSpeechVolumnAffect.isAnimating) {
            [imgSpeechVolumnAffect startAnimating];
        }
    }
}

- (void)stopSpeechAnimate {
    if(imgSpeechVolumnAffect != nil) {
        if(imgSpeechVolumnAffect.isAnimating) {
            [imgSpeechVolumnAffect stopAnimating];
        }
        imgSpeechVolumnAffect.hidden = YES;
    }
}

#pragma mark -
#pragma mark speech control

- (void)resetRecognizer {
    [self stopSpeechAnimate];
    recognizerState = RecognizerStateReady;
}

- (void)btnSpeechTouchUpInside:(id)sender {
    if(speechViewState == SpeechViewStateClosed) {
        [self showSpeechView];
    } else if(speechViewState == SpeechViewStateOpenned) {
        [speechRecognitionUtil stopListening];
    }
}

- (void)btnSpeechTouchDown:(id)sender {
    if(speechViewState == SpeechViewStateOpenned) {
        if(recognizerState == RecognizerStateReady) {
            recognizerState = RecognizerStateRecordBegin;
            [self startListening:nil];
        }
    }
}

- (void)btnSpeechTouchUpOutside:(id)sender {
    [speechRecognitionUtil cancel];
}

- (void)btnSpeechTouchDragExit:(id)sender {
    //touch down and dragg out of button
}

- (void)btnSpeechTouchDragEnter:(id)sender {
    //touch down and dragg enter button when previous status is out of button
}

- (void)startListening:(NSTimer *)timer {
    if(speechRecognitionUtil == nil) {
        speechRecognitionUtil = [SpeechRecognitionUtil current];
    }
    speechRecognitionUtil.speechRecognitionNotificationDelegate = self;
    if(![speechRecognitionUtil startListening]) {
#ifdef DEBUG
        NSLog(@"[SPEECH VIEW] Start lisenting failed.");
#endif
    }
}

#pragma mark -
#pragma mark speech recognizer notification delegate

- (void)beginRecord {
    recognizerState = RecognizerStateRecording;
    [self startSpeechAnimate];
}

- (void)endRecord {
    recognizerState = RecognizerStateRecordingEnd;
    [self stopSpeechAnimate];
}

- (void)recognizeCancelled {
    [self speechRecognizerFailed:@"Cancelled by user."];
}

- (void)speakerVolumeChanged:(int)volume {
    if(recognizerState == RecognizerStateRecording) {
        //        int v = volume / 3;
        //        if(v > 9) v = 9;
        //        if(v < 0) v = 0;
        //        [btnSpeech setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"btn_speech_0%d.png", v]] forState:UIControlStateNormal];
    }
}

- (void)recognizeSuccess:(NSString *)result {
    [self resetRecognizer];
    if(![NSString isBlank:result]) {
        //process text message
#ifdef DEBUG
        NSLog(@"[SPEECH VIEW] Send voice command [%@].", result);
#endif
        DeviceCommandVoiceControl *command = (DeviceCommandVoiceControl *)[CommandFactory commandForType:CommandTypeUpdateDeviceViaVoice];
        command.masterDeviceCode = [SMShared current].memory.currentUnit.identifier;
        command.voiceText = result;
        [[SMShared current].deliveryService executeDeviceCommand:command];
    } else {
        [self speechRecognizerFailed:@"no speaking"];
    }
}

- (void)recognizeError:(int)errorCode {
    [self resetRecognizer];
    [self speechRecognizerFailed:[NSString stringWithFormat:@"error code is %d", errorCode]];
}

- (void)speechRecognizerFailed:(NSString *)message {
#ifdef DEBUG
    NSLog(@"[SPEECH RECOGNIZER] Recognize failed, reason is [ %@ ]", message);
#endif
}


#pragma mark -
#pragma mark getter and setters

- (ConversationView *)speechView {
    if(speechView == nil) {
        CGFloat viewHeight = self.frame.size.height - SPEECH_BUTTON_HEIGHT / 2 - 32;
        speechView = [[ConversationView alloc] initWithFrame:CGRectMake(0, (0 - viewHeight - ([UIDevice systemVersionIsMoreThanOrEuqal7] ? 22 : 12)), 601/2, viewHeight) andContainer:self];
        speechView.center = CGPointMake(self.center.x, speechView.center.y);
    }
    return speechView;
}

@end
