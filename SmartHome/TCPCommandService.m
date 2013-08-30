//
//  TCPCommandService.m
//  SmartHome
//
//  Created by Zhao yang on 8/28/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "TCPCommandService.h"


/*
 
 
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
