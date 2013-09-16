//
//  DeviceCommandDeliveryService.m
//  SmartHome
//
//  Created by Zhao yang on 8/29/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandDeliveryService.h"

#import "DeviceCommandGetUnitsHandler.h"
#import "DeviceCommandUpdateAccountHandler.h"
#import "DeviceCommandGetAccountHandler.h"
#import "DeviceCommandGetNotificationsHandler.h"
#import "DeviceCommandVoiceControlHandler.h"
#import "DeviceCommandUpdateDevicesHandler.h"
#import "DeviceCommandGetSceneListHandler.h"

#import "AlertView.h"

#define NETWORK_CHECK_INTERVAL 5

@implementation DeviceCommandDeliveryService {
    NSTimer *tcpConnectChecker;
}

@synthesize tcpService;
@synthesize restfulService;
@synthesize isService;

- (id)init {
    self = [super init];
    if(self) {
        [self initDefaults];
    }
    return self;
}

- (void)initDefaults {
    isService = NO;
}

/*
 *
 *
 *
 */
- (void)executeDeviceCommand:(DeviceCommand *)command {
    if(!self.isService) return;
    
    [self.tcpService executeDeviceCommand:command];
}

/*
 *
 *
 */
- (void)handleDeviceCommand:(DeviceCommand *)command {
    if(command == nil) return;
    
    if(command.resultID == -3000 || command.resultID == -2000 || command.resultID == -1000) {
        [[SMShared current].app logout];
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"security_invalid", @"") forType:AlertViewTypeFailed];
        [[AlertView currentAlertView] alertAutoDisappear:YES lockView:nil];
        return;
    }
    
    if(command.resultID == -100) {
        NSLog(@"device command has been ignore .. [ %@ ]", command.commandName);
        //ignore this command
        return;
    }
    
    // if is not served
    if(!self.isService) return;
    
    DeviceCommandHandler *handler = nil;
    if([@"FindZKListCommand" isEqualToString:command.commandName]) {
        handler = [[DeviceCommandGetUnitsHandler alloc] init];
    } else if([@"AccountUpdateCommand" isEqualToString:command.commandName]) {
        handler = [[DeviceCommandUpdateAccountHandler alloc] init];
    } else if([@"AccountProfileCommand" isEqualToString:command.commandName]) {
        handler = [[DeviceCommandGetAccountHandler alloc] init];
    } else if([@"AccountMQListCommand" isEqualToString:command.commandName]) {
        handler = [[DeviceCommandGetNotificationsHandler alloc] init];
    } else if([@"FindDeviceSceneCommand" isEqualToString:command.commandName]) {
        handler = [[DeviceCommandGetSceneListHandler alloc] init];
    } else if([@"VoiceControlCommand" isEqualToString:command.commandName]) {
        handler = [[DeviceCommandVoiceControlHandler alloc] init];
    } else if([@"DeviceFingerExcuteCommand" isEqualToString:command.commandName]) {
        handler = [[DeviceCommandUpdateDevicesHandler alloc] init];
    } else if([@"DeviceChangeNameCommand" isEqualToString:command.commandName]) {
        
    }
        
    if(handler != nil) {
        [handler handle:command];
    }
}

- (void)startService {
    if(!self.isService) {
        isService = YES;
        
        // load all units from disk
        [[SMShared current].memory loadUnitsFromDisk];
        
        // start network checker
        if(tcpConnectChecker != nil) {
            [tcpConnectChecker invalidate];
        }
        tcpConnectChecker = [NSTimer scheduledTimerWithTimeInterval:NETWORK_CHECK_INTERVAL target:self selector:@selector(checkTcp) userInfo:nil repeats:YES];
        [tcpConnectChecker fire];
    }
}

- (void)stopService {
    if(self.isService) {
        if(tcpConnectChecker != nil) {
            [tcpConnectChecker invalidate];
            tcpConnectChecker = nil;
        }
        [self.tcpService disconnect];
        [[SMShared current].memory syncUnitsToDisk];
        isService = NO;
    }
}

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
#pragma mark getter and setters

- (TCPCommandService *)tcpService {
    if(tcpService == nil) {
        tcpService = [[TCPCommandService alloc] init];
    }
    return tcpService;
}

- (RestfulCommandService *)restfulService {
    return nil;
}

@end