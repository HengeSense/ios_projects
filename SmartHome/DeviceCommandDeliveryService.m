//
//  DeviceCommandDeliveryService.m
//  SmartHome
//
//  Created by Zhao yang on 8/29/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandDeliveryService.h"
#import "NetworkModeChangedEvent.h"
#import "XXEventSubscriptionPublisher.h"
#import "DeviceCommandEvent.h"
#import "XXEventNameFilter.h"

/*  Command Handler  */
#import "DeviceCommandGetUnitsHandler.h"
#import "DeviceCommandGetAccountHandler.h"
#import "DeviceCommandGetNotificationsHandler.h"
#import "DeviceCommandUpdateDevicesHandler.h"
#import "DeviceCommandGetSceneListHandler.h"
#import "AlertView.h"

#define NETWORK_CHECK_INTERVAL 5
#define UNIT_REFRESH_INTERVAL  10
#define HEART_BEAT_TIMEOUT     1.f

@implementation DeviceCommandDeliveryService {
    Reachability* reachability;
    NSTimer *tcpConnectChecker;
    NSTimer *unitRefresTimer;
    NSArray *mayUsingInternalNetworkCommands;
    
    NetworkMode networkMode;
    
    dispatch_queue_t serialQueue;
    
    /*
     * no            0
     * wifi net      1
     * wifi no net   2
     * 3g            3
     */
    NSUInteger flag;

    NSObject *syncObject;
}

@synthesize tcpService;
@synthesize restfulService;
@synthesize isService;

@synthesize needRefreshUnitAndSceneModes;

#pragma mark -
#pragma mark Initializations

- (id)init {
    self = [super init];
    if(self) {
        [self initDefaults];
    }
    return self;
}

- (void)initDefaults {
    /* Property set */
    isService = NO;
    networkMode = NetworkModeNotChecked;
    self.needRefreshUnitAndSceneModes = NO;
    
    syncObject = [[NSObject alloc] init];
    mayUsingInternalNetworkCommands = [NSArray arrayWithObjects:COMMAND_KEY_CONTROL, COMMAND_GET_SCENE_LIST, COMMAND_GET_CAMERA_SERVER, nil];
    serialQueue = dispatch_queue_create("com.queue", DISPATCH_QUEUE_SERIAL);
    
    /* Network monitor */
    reachability = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    [self startMonitorNetworks];
}

#pragma mark -
#pragma mark Execute device command

/*
 *
 * Execute device command
 *.
 * NO Network Environment  ---> RETURN
 * 3G                      ---> TCP CONNECTION
 * WIFI  WITH UNIT         ---> RESTFUL SERVICE
 * WIFI  WITH NO UNIT      ---> TCP CONNECTION
 *
 */
- (void)executeDeviceCommand:(DeviceCommand *)command {
    if(command == nil) return;
    if(!self.isService) {
#ifdef DEBUG
        NSLog(@"[DeliveryService] Service not opened, [%@] can't be executed.", command.commandName);
#endif
        return;
    }
    @synchronized(self) {
        // Execute command will never executed in main thread
        if([NSThread currentThread].isMainThread) {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self executeDeviceCommandInternal:command];
            });
        } else {
            [self executeDeviceCommandInternal:command];
        }
    }
}

- (void)executeDeviceCommandInternal:(DeviceCommand *)command {
    /* Find the best command executor */
    id<CommandExecutor> executor = [self determineCommandExcutor:command];
    if(executor != nil) {
#ifdef DEBUG
//        NSLog(@"Execute [%@] From [%@]", command.commandName, [executor executorName]);
#endif
        [executor executeCommand:command];
    } else {
#ifdef DEBUG
        NSLog(@"[DeliveryService] Executor not found, [%@] can't be executed.", command.commandName);
#endif
    }
}

- (id<CommandExecutor>)determineCommandExcutor:(DeviceCommand *)command {
    /*
     * If the device command has explicit specify the network mode
     * that of course we know which executor should be used
     */
    if(command.commmandNetworkMode == CommandNetworkModeInternal) {
        return self.restfulService;
    } else if(command.commmandNetworkMode == CommandNetworkModeExternal) {
        return self.tcpService;
    }
    
    /*
     * At first , check the command wether has been defined in 
     * Internal network commands list
     */
    if([self commandCanDeliveryInInternalNetwork:command]) {
        if([self currentNetworkMode] == NetworkModeInternal) {
            return self.restfulService;
        }
    }
    
    if(self.tcpService.isConnectted) {
        return self.tcpService;
    }
    
    return nil;
}

- (BOOL)commandCanDeliveryInInternalNetwork:(DeviceCommand *)command {
    if(mayUsingInternalNetworkCommands == nil) return NO;
    /* 
     * This is a special command
     * Get all units only execute from tcp (both master device code and unit server url is blank)
     * Get one unit can execute in rest or tcp
     */
    if([COMMAND_GET_UNITS isEqualToString:command.commandName]) {
        if([NSString isBlank:command.masterDeviceCode]) {
            DeviceCommandGetUnit *cmd = (DeviceCommandGetUnit *)command;
            return ![NSString isBlank:cmd.unitServerUrl];
        } else {
            return YES;
        }
    }
    
    for(int i=0; i<mayUsingInternalNetworkCommands.count; i++) {
        NSString *cmdName = [mayUsingInternalNetworkCommands objectAtIndex:i];
        if([cmdName isEqualToString:command.commandName]) {
            return YES;
        }
    }
    return NO;
}

#pragma mark -
#pragma mark Handle device command

- (void)handleDeviceCommand:(DeviceCommand *)command {
    if(command == nil) return;
    
#ifdef DEBUG
    NSString *networkModeString = [NSString emptyString];
    if(command.commmandNetworkMode == CommandNetworkModeExternal) {
        networkModeString = @"External";
    } else if(command.commmandNetworkMode == CommandNetworkModeInternal) {
        networkModeString = @"Internal";
    }
//    NSLog(@"[DeliveryService] Received [%@] From [%@]", command.commandName, networkModeString);
#endif

    // Security key is invalid or expired
    if(command.resultID == -3000 || command.resultID == -2000 || command.resultID == -1000) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"security_invalid", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] alertAutoDisappear:YES lockView:nil];
        [[SMShared current].app logout];
        return;
    }
    
    // If the resutID of command is equal -100
    // that the command should be ignore,
    // our client will never process this command.
    if(command.resultID == -100) return;
    
    // If the service is not served
    if(!self.isService) {
#ifdef DEBUG
        NSLog(@"[DeliveryService] Service is't opened, can't handle [%@].", command.commandName);
#endif
        return;
    }
    
    DeviceCommandHandler *handler = nil;
    
    if([COMMAND_GET_UNITS isEqualToString:command.commandName]) {
        handler = [[DeviceCommandGetUnitsHandler alloc] init];
    } else if([COMMAND_GET_ACCOUNT isEqualToString:command.commandName]) {
        handler = [[DeviceCommandGetAccountHandler alloc] init];
    } else if([COMMAND_PUSH_NOTIFICATIONS isEqualToString:command.commandName] || [COMMAND_GET_NOTIFICATIONS isEqualToString:command.commandName]) {
        handler = [[DeviceCommandGetNotificationsHandler alloc] init];
    } else if([COMMAND_GET_SCENE_LIST isEqualToString:command.commandName]) {
        handler = [[DeviceCommandGetSceneListHandler alloc] init];
    } else if([COMMAND_PUSH_DEVICE_STATUS isEqualToString:command.commandName]) {
        handler = [[DeviceCommandUpdateDevicesHandler alloc] init];
    }
        
    if(handler != nil) {
        [handler handle:command];
    }
}

- (void)queueCommand:(DeviceCommand *)command {
#ifdef DEBUG
    NSLog(@"[DeliveryService] Queue command [%@].", command.commandName);
#endif
    [self.tcpService queueCommand:command];
}

#pragma mark -
#pragma mark Event Subscriber

- (void)xxEventPublisherNotifyWithEvent:(XXEvent *)event {
    if([event isKindOfClass:[DeviceCommandEvent class]]) {
        DeviceCommandEvent *commandReceivedEvent = (DeviceCommandEvent *)event;
        [self handleDeviceCommand:commandReceivedEvent.command];
    }
}

- (NSString *)xxEventSubscriberIdentifier {
    return @"deviceCommandDeliveryServiceSubscriber";
}

#pragma mark -
#pragma mark Open or stop delivery service

- (void)startService {
    if(!self.isService) {
        
#ifdef DEBUG
        NSLog(@"[DeliveryService] Service starting.");
#endif
        isService = YES;
        
        // Load all units from disk
        [[SMShared current].memory loadUnitsFromDisk];
    
        XXEventSubscription *subscription = [[XXEventSubscription alloc] initWithSubscriber:self eventFilter:[[XXEventNameFilter alloc] initWithSupportedEventName:EventDeviceCommand]];
        [[XXEventSubscriptionPublisher defaultPublisher] subscribeFor:subscription];

        if(tcpConnectChecker != nil) {
            [tcpConnectChecker invalidate];
        }

        // Start a network checker
        // Every 5 seconds to check the tcp is connectted ?
        // If it was closed, then should open it again.
        tcpConnectChecker = [NSTimer scheduledTimerWithTimeInterval:NETWORK_CHECK_INTERVAL target:self selector:@selector(checkTcp) userInfo:nil repeats:YES];
        [tcpConnectChecker fire];
        
#ifdef DEBUG
        NSLog(@"[DeliveryService] Service started.");
#endif
    }
}

- (void)stopService {
    if(self.isService) {
        isService = NO;
        
        [[XXEventSubscriptionPublisher defaultPublisher] unSubscribeForSubscriber:self];
        
        [self stopRefreshCurrentUnit];
        
        // Stop TCP Connection checker
        if(tcpConnectChecker != nil) {
            [tcpConnectChecker invalidate];
            tcpConnectChecker = nil;
        }
        
        // Disconnect tcp connection
        [self.tcpService disconnect];
        
        // Synchronize memory units to disk
        [[SMShared current].memory syncUnitsToDisk];
        
#ifdef DEBUG
        NSLog(@"[COMMAND SERVICE] Stopped.");
#endif
    }
}

#pragma mark -
#pragma mark TCP Connection checker

- (void)checkTcp {
    [self startTcpIfNeed];
}

- (void)startTcpIfNeed {    
    if(self.tcpService.isConnectted
       || self.tcpService.isConnectting) {
        return;
    }
    [self.tcpService connect];
}

- (void)notifyTcpConnectionOpened {
    [self executeDeviceCommand:[CommandFactory commandForType:CommandTypeGetUnits]];
    [self executeDeviceCommand:[CommandFactory commandForType:CommandTypeGetNotifications]];
    [self notifyNetworkModeUpdate:networkMode];
}

- (void)notifyTcpConnectionClosed {
    [self notifyNetworkModeUpdate:networkMode];
}

#pragma mark -
#pragma mark Refresh current unit

- (void)startRefreshCurrentUnit {
    [self stopRefreshCurrentUnit];
    unitRefresTimer = [NSTimer scheduledTimerWithTimeInterval:UNIT_REFRESH_INTERVAL target:self selector:@selector(refreshUnit) userInfo:nil repeats:YES];
    [unitRefresTimer fire];
}

- (void)stopRefreshCurrentUnit {
    if(unitRefresTimer != nil) {
        [unitRefresTimer invalidate];
        unitRefresTimer = nil;
    }
}

- (void)refreshUnit {
    dispatch_async(serialQueue, ^{
        Unit *unit = [SMShared current].memory.currentUnit;
        if(unit != nil) {
            // This is a sync method, not checkInternalOrNotInternalNetwork (async method)
            // Here you must check net work sync, then continue execute command
            [self checkIsReachableInternalUnit];
            
            if(self.needRefreshUnitAndSceneModes) {
                // Update current unit
                DeviceCommand *command = [CommandFactory commandForType:CommandTypeGetUnits];
                command.masterDeviceCode = unit.identifier;
                command.hashCode = unit.hashCode;
                [self executeDeviceCommand:command];
                
                // Update scene list for current unit
                DeviceCommand *getSceneListCommand = [CommandFactory commandForType:CommandTypeGetSceneList];
                getSceneListCommand.masterDeviceCode = unit.identifier;
                getSceneListCommand.hashCode = unit.sceneHashCode;
                [self executeDeviceCommand:getSceneListCommand];
            }
            
            // Send heart beat command
            [self executeDeviceCommand:[CommandFactory commandForType:CommandTypeSendHeartBeat]];
        }
    });
}

- (void)fireRefreshUnit {
    if(unitRefresTimer != nil) {
        [unitRefresTimer fire];
    }
}

#pragma mark -
#pragma mark Network monitor

- (void)startMonitorNetworks {
	// Here we set up a NSNotification observer. The Reachability that caused the notification
	// is passed in the object parameter
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
    [reachability startNotifier];
}

- (void)reachabilityChanged:(NSNotification *)notification {
    Reachability *reach = notification.object;
    if(reach == nil) return;
    if(reach.isReachable) {
        if(reach.isReachableViaWiFi) {
            // WIFI &&   Network
            flag = 1;
        } else if(reach.isReachableViaWWAN) {
            // 3G   &&   Network
            flag = 3;
        } else {
            // Else, ignore
        }
    } else {
        if([Reachability reachabilityForLocalWiFi].currentReachabilityStatus != NotReachable) {
            // WIFI && No Network
            flag = 2;
        } else {
            // No (WIFI && 3G && 2G && Network)
            flag = 0;
        }
    }
    
    if(flag == 1 || flag == 2) {
        [self checkInternalOrNotInternalNetwork];
    } else {
        if(flag == 0) {
            [self setCurrentNetworkMode:NetworkModeNotChecked];
        } else {
            if([self currentNetworkMode] != NetworkModeExternal) {
                [self setCurrentNetworkMode:NetworkModeExternal];
            }
        }
    }
}

- (void)checkInternalOrNotInternalNetwork {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self checkIsReachableInternalUnit];
    });
}

- (void)checkIsReachableInternalUnit {
    @synchronized(syncObject) {
        NSString *url = [self currentUnitNetworkCheckUrl];
        if(url == nil) {
            networkMode = NetworkModeExternal;
            return;
        }
        
        if([Reachability reachabilityForLocalWiFi].currentReachabilityStatus == NotReachable) {
            networkMode = NetworkModeExternal;
            return;
        }
        
        NSMutableURLRequest *request =[[NSMutableURLRequest alloc] initWithURL: [[NSURL alloc] initWithString:url] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:HEART_BEAT_TIMEOUT];
        NSURLResponse *response;
        NSError *error;
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if(error == nil) {
            if(response) {
                NSHTTPURLResponse *rp = (NSHTTPURLResponse *)response;
                if(rp.statusCode == 200 && data != nil) {
                    NSString *unitIdentifier = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                    if([SMShared current].memory.currentUnit != nil) {
                        if([[SMShared current].memory.currentUnit.identifier isEqualToString:unitIdentifier]) {
                            networkMode = NetworkModeInternal;
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [self notifyNetworkModeUpdate:NetworkModeInternal];
                            });
                            return;
                        }
                    }
                }
            }
        }
        networkMode = NetworkModeExternal;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self notifyNetworkModeUpdate:NetworkModeExternal];
        });
    }
}

- (NetworkMode)currentNetworkMode {
    return networkMode;
}

- (void)setCurrentNetworkMode:(NetworkMode)mode {
    @synchronized(syncObject) {
        if(networkMode != mode) {
            networkMode = mode;
            [self notifyNetworkModeUpdate:mode];
        }
    }
}

- (NSString *)currentUnitNetworkCheckUrl {
    if([SMShared current].memory.currentUnit == nil) return nil;
    return [NSString stringWithFormat:@"http://%@:%d/heartbeat", [SMShared current].memory.currentUnit.localIP, [SMShared current].memory.currentUnit.localPort];
}

- (void)notifyNetworkModeUpdate:(NetworkMode)mode {
    [[XXEventSubscriptionPublisher defaultPublisher] publishWithEvent:[[NetworkModeChangedEvent alloc] initWithNetworkMode:mode]];
}

#pragma mark -
#pragma mark Getter and Setters

- (TCPCommandService *)tcpService {
    if(tcpService == nil) {
        tcpService = [[TCPCommandService alloc] init];
    }
    return tcpService;
}

- (RestfulCommandService *)restfulService {
    if(restfulService == nil) {
        restfulService = [[RestfulCommandService alloc] init];
    }
    return restfulService;
}

@end