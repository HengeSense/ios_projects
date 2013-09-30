//
//  DeviceCommandDeliveryService.h
//  SmartHome
//
//  Created by Zhao yang on 8/29/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

/*  Command Executor */
#import "TCPCommandService.h"
#import "RestfulCommandService.h"

#import "CommandFactory.h"
#import "Reachability.h"

typedef NS_ENUM(NSUInteger, NetworkMode) {
    NetworkModeNotChecked,
    NetworkModeExternal,
    NetworkModeInternal
};

@interface DeviceCommandDeliveryService : NSObject

@property (strong, nonatomic, readonly) TCPCommandService *tcpService;
@property (strong, nonatomic, readonly) RestfulCommandService *restfulService;
@property (assign, nonatomic, readonly) BOOL isService;

/* Execute or handle command */
- (void)executeDeviceCommand:(DeviceCommand *)command;
- (void)handleDeviceCommand:(DeviceCommand *)command;

/* Start or stop command delivery service */
- (void)startService;
- (void)stopService;

/* External or Internal Network Checker */
- (NetworkMode)currentNetworkMode;
- (void)checkInternalOrNotInternalNetwork;

/* Start and Stop refresh current unit */
- (void)startRefreshCurrentUnit;
- (void)stopRefreshCurrentUnit;

@end
