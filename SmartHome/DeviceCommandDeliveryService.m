//
//  DeviceCommandDeliveryService.m
//  SmartHome
//
//  Created by Zhao yang on 8/29/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandDeliveryService.h"

#import "Reachability.h"
#import "DeviceCommandGetUnitsHandler.h"
#import "DeviceCommandUpdateAccountHandler.h"
#import "DeviceCommandGetAccountHandler.h"
#import "DeviceCommandGetNotificationsHandler.h"
#import "DeviceCommandVoiceControlHandler.h"
#import "DeviceCommandUpdateDevicesHandler.h"
#import "DeviceCommandGetSceneListHandler.h"
#import "DeviceCommandGetCameraServerHandler.h"

#import "AlertView.h"

#define NETWORK_CHECK_INTERVAL 5

@implementation DeviceCommandDeliveryService {
    Reachability* reachability;
    NSTimer *tcpConnectChecker;
    NSArray *mayUsingInternalNetworkCommands;
}

@synthesize tcpService;
@synthesize restfulService;
@synthesize isService;

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
    isService = NO;
    reachability = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    mayUsingInternalNetworkCommands = [NSArray arrayWithObjects:@"FindZKListCommand", @"KeyControlCommand", @"FindDeviceSceneCommand", nil];
}

#pragma mark -
#pragma mark Device command delivery methods

/*
 *
 * Execute device command
 *
 * NO Network Environment  ---> RETURN
 * 3G                      ---> TCP CONNECTION
 * WIFI  WITH UNIT         ---> RESTFUL SERVICE
 * WIFI  WITH NO UNIT      ---> TCP CONNECTION
 *
 */
- (void)executeDeviceCommand:(DeviceCommand *)command {
    if(command == nil) return;
    if(!self.isService) return;
    
    NSLog(@"is reachble %@", reachability.isReachable ? @"yes" : @"no");
    NSLog(@"is reachble via wifi %@", reachability.isReachableViaWiFi ? @"yes" : @"no");
    NSLog(@"is reachble via 3g %@", reachability.isReachableViaWWAN ? @"yes" : @"no");
    
    // If the command can be delivery in internal network
    if([self commandCanDeliveryInInternalNetwork:command]) {
        
        
    }
    
    if(self.tcpService.isConnectted) {
        [self.tcpService executeDeviceCommand:command];
    }
}

/*
 * To Handle Response From Server
 *
 * Restful or Tcp Connection Response
 */
- (void)handleDeviceCommand:(DeviceCommand *)command {

    if(command == nil) return;

    // Security key is invalid or expired
    if(command.resultID == -3000 || command.resultID == -2000 || command.resultID == -1000) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"security_invalid", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] alertAutoDisappear:YES lockView:nil];
        [[SMShared current].app logout];
        return;
    }
    
    // This command should be ignore,
    // Client will never process this command.
    if(command.resultID == -100) return;
    
    
    // If the service is not served
    if(!self.isService) return;
    
    DeviceCommandHandler *handler = nil;
    
    if([@"FindZKListCommand" isEqualToString:command.commandName]) {
        handler = [[DeviceCommandGetUnitsHandler alloc] init];
    } else if([@"AccountUpdateCommand" isEqualToString:command.commandName]) {
        handler = [[DeviceCommandUpdateAccountHandler alloc] init];
    } else if([@"AccountProfileCommand" isEqualToString:command.commandName]) {
        handler = [[DeviceCommandGetAccountHandler alloc] init];
    } else if([@"MessageQueueCommand" isEqualToString:command.commandName] || [@"AccountMQListCommand" isEqualToString:command.commandName]) {
        handler = [[DeviceCommandGetNotificationsHandler alloc] init];
    } else if([@"FindDeviceSceneCommand" isEqualToString:command.commandName]) {
        handler = [[DeviceCommandGetSceneListHandler alloc] init];
    } else if([@"VoiceControlCommand" isEqualToString:command.commandName]) {
        handler = [[DeviceCommandVoiceControlHandler alloc] init];
    } else if([@"DeviceFingerExcuteCommand" isEqualToString:command.commandName]) {
        handler = [[DeviceCommandUpdateDevicesHandler alloc] init];
    } else if([@"DeviceChangeNameCommand" isEqualToString:command.commandName]) {
        // ...
    } else if([@"RequestCameraCommand" isEqualToString:command.commandName]) {
        handler = [[DeviceCommandGetCameraServerHandler alloc] init];
    }
        
    if(handler != nil) {
        [handler handle:command];
    }
}


#pragma mark -
#pragma mark Restful handle

- (void)getUnitSucess:(RestResponse *)resp {
    if(resp.statusCode == 200) {
        NSDictionary *json = [JsonUtils createDictionaryFromJson:resp.body];
        if(json != nil) {
            Unit *unit = [[Unit alloc] initWithJson:json];
            if(unit != nil) {
                DeviceCommandUpdateUnits *updateUnit = [[DeviceCommandUpdateUnits alloc] init];
                updateUnit.commandName = @"FindZKListCommand";
                updateUnit.masterDeviceCode = unit.identifier;
                [updateUnit.units addObject:unit];
                [self handleDeviceCommand:updateUnit];
                return;
            }
        }
    }
    
    [self getUnitFailed:resp];
}

- (void)getUnitFailed:(RestResponse *)resp {
    NSLog(@"failed status code is %d", resp.statusCode);
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
            // wifi
            NSLog(@"reach via wifi");
        } else if(reach.isReachableViaWWAN) {
            // wwan
            NSLog(@"reach via wwan");
        }
    } else {
        // not reachable
        if([Reachability reachabilityForLocalWiFi].currentReachabilityStatus != NotReachable) {
            NSLog(@"local wifi");
        } else {
            NSLog(@"can't find any network environment");
        }
    }
}

#pragma mark -
#pragma mark Service switch

- (void)startService {
    if(!self.isService) {
        isService = YES;
        
        // Load all units from disk
        [[SMShared current].memory loadUnitsFromDisk];

        if(tcpConnectChecker != nil) {
            [tcpConnectChecker invalidate];
        }

        // Start network checker
        // Every 5 seconds to check the tcp is connectted
        // If it was closed , then open it again
        tcpConnectChecker = [NSTimer scheduledTimerWithTimeInterval:NETWORK_CHECK_INTERVAL target:self selector:@selector(checkTcp) userInfo:nil repeats:YES];
        [tcpConnectChecker fire];
    }
}

- (void)stopService {
    if(self.isService) {
        isService = NO;
        
        // Stop TCP Connection checker
        if(tcpConnectChecker != nil) {
            [tcpConnectChecker invalidate];
            tcpConnectChecker = nil;
        }
        
        // Disconnect tcp connection
        [self.tcpService disconnect];
        tcpService = nil;
        
        // Synchronize memory units to disk
        [[SMShared current].memory syncUnitsToDisk];
    }
}

#pragma mark -
#pragma mark TCP Connection checker

- (void)checkTcp {
    [self startTcpIfNeed];
}

- (void)startTcpIfNeed {    
    if(self.tcpService.isConnectted || self.tcpService.isConnectting) {
        return;
    }
    [self performSelectorInBackground:@selector(startTcp) withObject:nil];
}

- (void)startTcp {
    [self.tcpService connect];
}

#pragma mark -
#pragma mark utils

- (BOOL)commandCanDeliveryInInternalNetwork:(DeviceCommand *)command {
    if(mayUsingInternalNetworkCommands == nil) return NO;

    for(int i=0; i<mayUsingInternalNetworkCommands.count; i++) {
        NSString *cmdName = [mayUsingInternalNetworkCommands objectAtIndex:i];
        if([cmdName isEqualToString:command.commandName]) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark -
#pragma mark getter and setters

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