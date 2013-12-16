//
//  UnitViewController.m
//  SmartHome
//
//  Created by Zhao yang on 12/3/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "UnitViewController.h"
#import "NotificationsViewController.h"
#import "UIColor+ExtentionForHexString.h"
#import "SMDateFormatter.h"
#import "SceneMode.h"
#import "CommandFactory.h"
#import "NotificationsFileManager.h"
#import "UnitView.h"
#import "ViewsPool.h"
#import "PortalView.h"
#import "XXEventFilterChain.h"
#import "XXEventSubscriptionPublisher.h"
#import "UnitsListUpdatedEventFilter.h"
#import "NotificationsFileUpdatedEventFilter.h"
#import "NetwrokModeChangedEventFilter.h"
#import "DeviceStatusChangedFilter.h"
#import "DeviceCommandNameEventFilter.h"

#define SPEECH_BUTTON_WIDTH              173
#define SPEECH_BUTTON_HEIGHT             173

@interface UnitViewController ()

@end

@implementation UnitViewController {
    SpeechViewState speechViewState;
    RecognizerState recognizerState;
    ConversationView *speechView;
    UnitView *unitView;
    SpeechRecognitionUtil *speechRecognitionUtil;
    
    UIButton *btnSpeech;
    UIImageView *imgSpeechVolumnAffect;
    
    UIButton *btnUnit;
    UIButton *btnScene;
    
    UILabel *lblAffectDevice;
    
    NSString *titleString;
    NSString *stateString;
    NSString *statusString;
    
    SMNotification *lastedNotification;
    UILabel *lblMessage;
    UILabel *lblTime;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    XXEventSubscription *subscription = [[XXEventSubscription alloc] initWithSubscriber:self];
    subscription.notifyMustInMainThread = YES;
    
    DeviceCommandNameEventFilter *nameFilter = [[DeviceCommandNameEventFilter alloc] init];
    [nameFilter.supportedCommandNames addObject:COMMAND_VOICE_CONTROL];
    
    XXEventFilterChain *eventFilterChain = [[XXEventFilterChain alloc] init];
    [[[[[eventFilterChain
       orFilter:[[UnitsListUpdatedEventFilter alloc] init]]
       orFilter:[[NotificationsFileUpdatedEventFilter alloc] init]]
       orFilter:[[NetwrokModeChangedEventFilter alloc] init]]
       orFilter:[[DeviceStatusChangedFilter alloc] init] ]
       orFilter:nameFilter];
    subscription.filter = eventFilterChain;
    [[XXEventSubscriptionPublisher defaultPublisher] subscribeFor:subscription];
    
    [SMShared current].deliveryService.needRefreshUnitAndSceneModes = YES;
    [[SMShared current].deliveryService fireRefreshUnit];
    
    [self updateNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[XXEventSubscriptionPublisher defaultPublisher] unSubscribeForSubscriber:self];
    [SMShared current].deliveryService.needRefreshUnitAndSceneModes = NO;
}

- (void)initDefaults {
    [super initDefaults];
    
    speechViewState = SpeechViewStateClosed;
    recognizerState = RecognizerStateReady;
}

- (void)initUI {
    [super initUI];
    
    [self.topbar.rightButton setBackgroundImage:[UIImage imageNamed:@"icon_red.png"] forState:UIControlStateNormal];
    [self.topbar.rightButton setBackgroundImage:[UIImage imageNamed:@"icon_red.png"] forState:UIControlStateHighlighted];
    
#pragma mark -
#pragma selection button (units && scene)
    
    CGFloat margin = (self.view.bounds.size.height-self.topbar.frame.size.height-355)/4;
    if(btnUnit == nil) {
        btnUnit = [[UIButton alloc] initWithFrame:CGRectMake(15, self.topbar.frame.size.height+margin, 227 / 2, 73 / 2)];
        [btnUnit setBackgroundImage:[UIImage imageNamed:@"btn_unit.png"] forState:UIControlStateNormal];
        [btnUnit setBackgroundImage:[UIImage imageNamed:@"btn_unit.png"] forState:UIControlStateHighlighted];
        [btnUnit addTarget:self action:@selector(btnShowUnitsList:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnUnit];
    }
    
    if(btnScene == nil) {
        btnScene = [[UIButton alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 227/2-15, self.topbar.frame.size.height+margin, 227 /2, 73 / 2)];
        [btnScene setBackgroundImage:[UIImage imageNamed:@"btn_scene.png"] forState:UIControlStateNormal];
        [btnScene setBackgroundImage:[UIImage imageNamed:@"btn_scene.png"] forState:UIControlStateHighlighted];
        [btnScene addTarget:self action:@selector(btnShowSceneList:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnScene];
    }
    
#pragma mark -
#pragma mark speech button
    
    if(imgSpeechVolumnAffect == nil) {
        imgSpeechVolumnAffect = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - SPEECH_BUTTON_HEIGHT / 2), 417 / 2, 195 / 2)];
        
        NSMutableArray *animateImages = [NSMutableArray arrayWithCapacity:5];
        for(int i=1; i<=5; i++) {
            NSString *filePath = [[NSBundle mainBundle] pathForResource:[NSString stringWithFormat:@"sp-a-%d@2x", i] ofType:@"png"];
            [animateImages addObject:[UIImage imageWithContentsOfFile:filePath]];
        }
        imgSpeechVolumnAffect.animationImages = animateImages;
        imgSpeechVolumnAffect.animationDuration = 1.5f;
        imgSpeechVolumnAffect.hidden = YES;
        [self.view addSubview:imgSpeechVolumnAffect];
    }
    
    if(btnSpeech == nil) {
        btnSpeech = [[UIButton alloc] initWithFrame:CGRectMake(((self.view.frame.size.width - SPEECH_BUTTON_WIDTH/2) / 2), (self.view.frame.size.height - SPEECH_BUTTON_HEIGHT / 2 - 7), (SPEECH_BUTTON_WIDTH / 2), (SPEECH_BUTTON_HEIGHT / 2))];
        [btnSpeech setBackgroundImage:[UIImage imageNamed:@"btn_speech.png"] forState:UIControlStateNormal];
        [btnSpeech setBackgroundImage:[UIImage imageNamed:@"btn_speech.png"] forState:UIControlStateHighlighted];
        
        [btnSpeech addTarget:self action:@selector(btnSpeechTouchDown:) forControlEvents:UIControlEventTouchDown];
        [btnSpeech addTarget:self action:@selector(btnSpeechTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        [btnSpeech addTarget:self action:@selector(btnSpeechTouchUpOutside:) forControlEvents:UIControlEventTouchUpOutside];
        [btnSpeech addTarget:self action:@selector(btnSpeechTouchDragEnter:) forControlEvents:UIControlEventTouchDragEnter];
        [btnSpeech addTarget:self action:@selector(btnSpeechTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];
        
        [self.view addSubview:btnSpeech];
        
        imgSpeechVolumnAffect.center = CGPointMake(160, btnSpeech.center.y - 1);
    }
    
#pragma mark -
#pragma mark units view
    
    if(unitView == nil) {
        unitView = [UnitView unitViewWithPoint:CGPointMake(0, (self.view.bounds.size.height - 198 / 2 - margin-180)) ownerViewController:self];
        [self.view addSubview:unitView];
    }
    
#pragma mark -
#pragma mark notifications view
    
    UIView *notificationView = [[UIView alloc] initWithFrame:CGRectMake(10, (unitView.frame.origin.y - 40 - margin), [UIScreen mainScreen].bounds.size.width, 40)];
    
    UIImageView *imgMessage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10, 25 / 2, 30 / 2)];
    imgMessage.image = [UIImage imageNamed:@"icon_sound"];
    [notificationView addSubview:imgMessage];
    
    UITapGestureRecognizer *tapShowNotificationDetails = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapShowNotificationDetailsViewController:)];
    
    lblMessage = [[UILabel alloc]initWithFrame:CGRectMake(30, 0, 170, 20)];
    lblMessage.backgroundColor = [UIColor clearColor];
    lblMessage.font = [UIFont systemFontOfSize:14.f];
    lblMessage.text = [NSString emptyString];
    lblMessage.textColor = [UIColor lightTextColor];
    lblMessage.userInteractionEnabled = YES;
    [lblMessage addGestureRecognizer:tapShowNotificationDetails];
    [notificationView addSubview:lblMessage];
    
    lblTime = [[UILabel alloc]initWithFrame:CGRectMake(lblMessage.frame.origin.x, lblMessage.frame.origin.y+lblMessage.frame.size.height, 140, 10)];
    lblTime.backgroundColor =[UIColor clearColor];
    lblTime.text = [NSString emptyString];
    lblTime.font = [UIFont systemFontOfSize:12.f];
    lblTime.textColor = [UIColor lightTextColor];
    [notificationView addSubview: lblTime];

    UIImageView *imgAffectDevice = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"device_count.png"]];
    imgAffectDevice.frame = CGRectMake(230, 0, 44/2, 46/2);
    imgAffectDevice.center = CGPointMake(imgAffectDevice.center.x, notificationView.bounds.size.height / 2);
    [notificationView addSubview:imgAffectDevice];

    lblAffectDevice = [[UILabel alloc] initWithFrame:CGRectMake(imgAffectDevice.frame.origin.x+imgAffectDevice.frame.size.width + 10, 0, 20, 20)];
    lblAffectDevice.center = CGPointMake(lblAffectDevice.center.x, notificationView.bounds.size.height / 2);
    lblAffectDevice.text = @"0";
    lblAffectDevice.textColor = [UIColor colorWithHexString:@"dfa800"];
    lblAffectDevice.font = [UIFont systemFontOfSize:14];
    lblAffectDevice.backgroundColor = [UIColor clearColor];
    [notificationView addSubview:lblAffectDevice];
    
    [self.view addSubview:notificationView];
}

- (void)setUp {
    [self notifyViewUpdate];
}

/*
 *
 *
 *
 */
- (void)notifyViewUpdate {
    [self updateUnits];
}

#pragma mark -
#pragma mark Event Subsriber

- (void)xxEventPublisherNotifyWithEvent:(XXEvent *)event {
    if([event isKindOfClass:[UnitsListUpdatedEvent class]]) {
        [self updateUnits];
    } else if([event isKindOfClass:[NotificationsFileUpdatedEvent class]]) {
        [self updateNotifications];
    } else if([event isKindOfClass:[NetworkModeChangedEvent class]]) {
        NetworkModeChangedEvent *evet = (NetworkModeChangedEvent *)event;
        [self updateNetworkMode:evet.networkMode];
    } else if([event isKindOfClass:[DeviceStatusChangedEvent class]]) {
        DeviceStatusChangedEvent *evet = (DeviceStatusChangedEvent *)event;
        [self updateDevicesStatus:evet.command];
    } else if([event isKindOfClass:[DeviceCommandEvent class]]) {
        DeviceCommandEvent *evt = (DeviceCommandEvent *)event;
        if([evt.command isKindOfClass:[DeviceCommandVoiceControl class]]) {
            DeviceCommandVoiceControl *cmd = (DeviceCommandVoiceControl *)evt.command;
            [self notifyVoiceControlAccept:cmd];
        }
    }
}

- (NSString *)xxEventSubscriberIdentifier {
    return @"unitViewControllerSubscriber";
}

#pragma mark -
#pragma mark selection view delegate

- (void)selectionViewNotifyItemSelected:(id)item from:(NSString *)source {
    if([NSString isBlank:source]) return;
    SelectionItem *it = item;
    if(it == nil) return;
    if([@"scene" isEqualToString:source]) {
        DeviceCommandUpdateDevice *updateDeviceCommand = (DeviceCommandUpdateDevice *)[CommandFactory commandForType:CommandTypeUpdateDevice];
        updateDeviceCommand.masterDeviceCode = [SMShared current].memory.currentUnit.identifier;
        [updateDeviceCommand addCommandString:[NSString stringWithFormat:@"scene-%@", it.identifier]];
        [[SMShared current].deliveryService executeDeviceCommand:updateDeviceCommand
         ];
    } else if([@"units" isEqualToString:source]) {
        [[SMShared current].memory changeCurrentUnitTo:it.identifier];
        [self updateUnits];
        [[SMShared current].deliveryService fireRefreshUnit];
    
        PortalView *portalView = (PortalView *)[[ViewsPool sharedPool] viewWithIdentifier:@"portalView"];
        if(portalView != nil) {
            [portalView updateUnitSelectionView];
        }
    }
}


#pragma mark -
#pragma mark voice control handler

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

#pragma mark -
#pragma mark device command upate unit handler

- (void)updateUnits {
    @synchronized(self) {
        Unit *unit = [SMShared current].memory.currentUnit;
        if(unit != nil && ![NSString isBlank:unit.name]) {
            titleString = unit.name;
            statusString = unit.status;
        } else {
            titleString = [NSString emptyString];
        }
        [self updateTitleLabel];
        [unitView loadOrRefreshUnit:unit];
        lblAffectDevice.text =  [NSString stringWithFormat:@"%d", (unit == nil) ? 0 : unit.avalibleDevicesCount];
    }
}

- (void)updateDevicesStatus:(DeviceCommandUpdateDevices *)command {
    if(unitView != nil) {
        [unitView notifyStatusChanged];
    }
    
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

#pragma mark -
#pragma mark Notifications handler

- (void)tapShowNotificationDetailsViewController:(UITapGestureRecognizer *)tapGesture {
    if(lastedNotification != nil) {
        NotificationDetailsViewController *notificationDetailsViewController = [[NotificationDetailsViewController alloc] initWithNotification:lastedNotification];
        notificationDetailsViewController.delegate = self;
        [self.navigationController pushViewController:notificationDetailsViewController animated:YES];
    }
}

- (void)updateNotifications {
    NSArray *notifications = [[NotificationsFileManager fileManager] readFromDisk];
    
    if (notifications == nil || notifications.count == 0) {
        lastedNotification = nil;
        lblMessage.text = NSLocalizedString(@"everythings_fine", @"");
        lblTime.text = [NSString emptyString];
        return;
    }
    
    NSTimeInterval lastTime = 0;
    NSTimeInterval alLastTime = 0;
    
    SMNotification *lastNotHandlerAlNotification = nil;
    for(SMNotification *notification in notifications) {
        if ([notification.createTime timeIntervalSince1970] >= lastTime) {
            lastTime = [notification.createTime timeIntervalSince1970];
            lastedNotification = notification;
        }
        if ([@"AL" isEqualToString: notification.type] && alLastTime < [notification.createTime timeIntervalSince1970] && !notification.hasRead) {
            alLastTime = [notification.createTime timeIntervalSince1970];
            lastNotHandlerAlNotification = notification;
        }
    }
    if(lastNotHandlerAlNotification != nil) {
        lastedNotification = lastNotHandlerAlNotification;
    }
    
    if(lastedNotification != nil) {
        lblMessage.text = lastedNotification.text;
        lblTime.text = [SMDateFormatter dateToString:lastedNotification.createTime format:@"yyyy-MM-dd HH:mm"];
    }
}

- (void)smNotificationsWasUpdated {
    [self updateNotifications];
    
    PortalView *portalView = (PortalView *)[[ViewsPool sharedPool] viewWithIdentifier:@"portalView"];
    if(portalView != nil) {
        if([portalView respondsToSelector:@selector(smNotificationsWasUpdated)]) {
            [portalView smNotificationsWasUpdated];
        }
    }
}

#pragma mark -
#pragma mark command delivery service delegate

- (void)changeStateIconColor:(NSString *)colorStr {
    [self.topbar.rightButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%@.png", colorStr]] forState:UIControlStateNormal];
    [self.topbar.rightButton setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%@.png", colorStr]] forState:UIControlStateHighlighted];
}

- (void)updateNetworkMode:(NetworkMode)lastedNetwokMode {
    
    /*
     *    Change Title label
     */
    
    if(lastedNetwokMode == 1) {
        // External
        if([SMShared current].deliveryService.tcpService.isConnectted) {
            stateString = NSLocalizedString(@"external", @"");
        } else if([SMShared current].deliveryService.tcpService.isConnectting) {
            stateString = NSLocalizedString(@"connectting", @"");
        } else {
            stateString = NSLocalizedString(@"disconnect", @"");
        }
    } else if(lastedNetwokMode == 2) {
        // Internal
        stateString = NSLocalizedString(@"internal", @"");
    } else {
        // Unknow
        stateString = NSLocalizedString(@"disconnect", @"");
    }
    
    [self updateTitleLabel];
    
    /*
     *    Change Cloud Icon Color
     */
    
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

- (void)updateTitleLabel {
    if([NSString isBlank:stateString]) {
        [self updateNetworkMode:[SMShared current].deliveryService.currentNetworkMode];
        return;
    }
    if(![NSString isBlank:titleString]) {
        self.topbar.titleLabel.text = [NSString stringWithFormat:@"%@ (%@)", titleString, stateString];
    } else {
        self.topbar.titleLabel.text = NSLocalizedString(@"app.name", @"");
    }
}

- (void)clearStateString {
    stateString = [NSString emptyString];
}

#pragma mark -
#pragma mark button pressed

//- (void)btnShowNotificationPressed:(id)sender {
//    NotificationViewController *notificationViewController = [[NotificationViewController alloc] initFrom:self];
//    [self.ownerController.navigationController pushViewController:notificationViewController animated:YES];
//}

- (void)btnShowSceneList:(id)sender {
    NSMutableArray *sList = [NSMutableArray array];
    if([SMShared current].memory.currentUnit != nil) {
        if([SMShared current].memory.currentUnit.scenesModeList != nil) {
            for(SceneMode *sm in [SMShared current].memory.currentUnit.scenesModeList) {
                [sList addObject:[[SelectionItem alloc] initWithIdentifier:[NSString stringWithFormat:@"%d", sm.code] andTitle:sm.name]];
            }
        }
    }
    [SelectionView showWithItems:sList selectedIdentifier:[NSString emptyString] source:@"scene" delegate:self];
}

- (void)btnShowUnitsList:(id)sender {
    NSMutableArray *unitsList = [NSMutableArray array];
    for(Unit *unit in [SMShared current].memory.units) {
        [unitsList addObject:[[SelectionItem alloc] initWithIdentifier:unit.identifier andTitle:unit.name]];
    }
    NSString *selectedUnitIdentifier = [SMShared current].memory.currentUnit == nil ? [NSString emptyString] : [SMShared current].memory.currentUnit.identifier;
    
    [SelectionView showWithItems:unitsList selectedIdentifier:selectedUnitIdentifier source:@"units" delegate:self];
}


#pragma mark -
#pragma mark speech view

- (void)showSpeechView {
    if(speechViewState != SpeechViewStateClosed) return;
    
    speechViewState = SpeechViewStateOpenning;
    
    ConversationView *view = [self speechView];
    [self.view addSubview:view];
    
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
    
    CGFloat viewHeight = self.view.frame.size.height - SPEECH_BUTTON_HEIGHT / 2 - ([UIDevice systemVersionIsMoreThanOrEuqal7] ? 22 : 12);
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
        speechRecognitionUtil = [[SpeechRecognitionUtil alloc] init];
        speechRecognitionUtil.speechRecognitionNotificationDelegate = self;
    }
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
        CGFloat viewHeight = self.view.frame.size.height - SPEECH_BUTTON_HEIGHT / 2 - 32;
        speechView = [[ConversationView alloc] initWithFrame:CGRectMake(0, (0 - viewHeight - ([UIDevice systemVersionIsMoreThanOrEuqal7] ? 22 : 12)), 601/2, viewHeight) andContainer:self];
        speechView.center = CGPointMake(self.view.center.x, speechView.center.y);
    }
    return speechView;
}

@end
