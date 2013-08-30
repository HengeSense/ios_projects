//
//  TCPCommandService.m
//  SmartHome
//
//  Created by Zhao yang on 8/28/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "TCPCommandService.h"


/*
 CommunicationMessage *ms =   [[CommunicationMessage alloc] init];
 //                ms.deviceCommand = [[DeviceCommand alloc] init];
 //                ms.deviceCommand.deviceCode = [UIDevice currentDevice].identifierForVendor.UUIDString;
 //                ms.deviceCommand.className = @"FindZKListCommand";
 //                ms.deviceCommand.commandTime = [[NSDate alloc] init];
 //                ms.deviceCommand.security = self.settings.secretKey;
 //                ms.deviceCommand.appKey = @"A001";
 //                ms.deviceCommand.masterDeviceCode = @"fieldunit";
 //                ms.deviceCommand.phoneNumber = self.settings.account;
 //
 //
 NSData *ddd =  [ms generateData];
 [self writeData:ddd];
 
 */

@implementation TCPCommandService {
    ExtranetClientSocket *socket;
}

- (id)init {
    self = [super init];
    if(self) {
        [self initDefaults];
    }
    return self;
}

- (void)initDefaults {
    if(socket == nil) {
        socket = [[ExtranetClientSocket alloc] init];
        socket.messageHandlerDelegate = self;
    }
}

- (void)executeDeviceCommand:(DeviceCommand *)command {
    if(command == nil) return;
    CommunicationMessage *message = [[CommunicationMessage alloc] init];
    message.deviceCommand = command;
    NSData *data = [message generateData];
    if(data != nil) {
        [socket writeData:data];
    }
}

#pragma mark -
#pragma mark message handler

- (void)clientSocketMessageDiscard:(NSData *)discardMessage {
    NSLog(@"message discard");
}

- (void)clientSocketMessageReadError {
    NSLog(@"socket error");
}

- (void)clientSocketWithReceivedMessage:(NSString *)messages {
    NSLog(@"%@",messages);
}

@end
