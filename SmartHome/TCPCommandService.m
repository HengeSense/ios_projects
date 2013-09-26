//
//  TCPCommandService.m
//  SmartHome
//
//  Created by Zhao yang on 8/28/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "TCPCommandService.h"
#import "NSString+StringUtils.h"
#import "SMShared.h"
#import "CommandFactory.h"

@implementation TCPCommandService {
    ExtranetClientSocket *socket;
    SMCommandQueue *queue;
    
    /* This flat to make sure only call connect method once */
    BOOL flag;
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
        NSString *tcpAddress = [SMShared current].settings.tcpAddress;
        NSArray *addressSet = [tcpAddress componentsSeparatedByString:@":"];
        if(addressSet == nil || addressSet.count != 2) {
            NSLog(@"TCP COMMAND SOCKET] Server address error [ %@ ]", tcpAddress == nil ? [NSString emptyString] : tcpAddress);
            return;
        }
        NSString *addr = [addressSet objectAtIndex:0];
        NSString *port = [addressSet objectAtIndex:1];
        socket = [[ExtranetClientSocket alloc] initWithIPAddress:addr andPort:port.integerValue];
        socket.messageHandlerDelegate = self;
    }
    
    if(queue == nil) {
        queue = [[SMCommandQueue alloc] init];
    }
}

- (void)connect {
    @synchronized(self) {
        if(flag) return;
        flag = YES;
    }
    [socket connect];
}

- (void)disconnect {
    [socket close];
}

- (BOOL)isConnectted {
    if(socket == nil) return NO;
    return socket.isConnect;
}

- (BOOL)isConnectting {
    if(socket == nil) return NO;
    return socket.isConnectting;
}

- (void)executeCommand:(DeviceCommand *)command {
    if(![queue contains:command]) {
        [queue pushCommand:command];
        [self flushQueue];
    }
}

- (NSString *)executorName {
    return @"TCP SERVICE";
}

- (void)flushQueue {
    @synchronized(self) {
        if([socket canWrite] && queue.count > 0) {
            NSMutableData *dataToSender = [NSMutableData data];
            DeviceCommand *command = [queue popup];
            while (command != nil) {
                CommunicationMessage *message = [[CommunicationMessage alloc] init];
                message.deviceCommand = command;
                NSData *data = [message generateData];
                if(data != nil) {
                    [dataToSender appendData:data];
                }
                command = [queue popup];
            }
            if(dataToSender.length > 0) {
                [socket writeData:dataToSender];
            }
        }
    }
}

#pragma mark -
#pragma mark message handler

- (void)clientSocketSenderReady {
    [self flushQueue];
}

- (void)clientSocketMessageDiscard:(NSData *)discardMessage {
    NSLog(@"[TCP COMMAND SOCKET] Some data will discard, the length is %d", discardMessage.length);
}

- (void)clientSocketMessageReadError {
    NSLog(@"[TCP COMMAND SOCKET] socket data reading or format error");
}

- (void)clientSocketWithReceivedMessage:(NSData *)messages {
    DeviceCommand *command = [CommandFactory commandFromJson:[JsonUtils createDictionaryFromJson:messages]];
    [[SMShared current].deliveryService handleDeviceCommand:command];
}

- (void)notifyConnectionClosed {
    @synchronized(self) {
        flag = NO;
        NSLog(@"[TCP COMMAND SOCKET] Closed");
    }
}

- (void)notifyConnectionOpened {
    NSLog(@"[TCP COMMAND SOCKET] Opened");
    [[SMShared current].deliveryService executeDeviceCommand:[CommandFactory commandForType:CommandTypeGetUnits]];
}

@end
