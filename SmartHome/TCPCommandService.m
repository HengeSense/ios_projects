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
    [socket connect];
}

- (void)disconnect {
    [socket close];
}

- (BOOL)isConnect {
    if(socket == nil) return NO;
    return socket.isConnect;
}

- (void)executeDeviceCommand:(DeviceCommand *)command {
    if(command == nil) return;
    [queue pushCommand:command];
    [self flushQueue];
}

- (void)flushQueue {
    @synchronized(self) {
        if(self.isConnect && [socket canWrite] && queue.count > 0) {
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
    NSLog(@"some socket data will discard, the length is %d .", discardMessage.length);
}

- (void)clientSocketMessageReadError {
    NSLog(@"socket reading error.");
}

- (void)clientSocketWithReceivedMessage:(NSData *)messages {
    NSString *receivedJson = [[NSString alloc] initWithData:messages encoding:NSUTF8StringEncoding];
//    NSLog(receivedJson);
    
    DeviceCommand *command = [CommandFactory commandFromJson:[JsonUtils createDictionaryFromJson:messages]];
    [[SMShared current].deliveryService handleDeviceCommand:command];
}

- (void)notifyConnectionClosed {
    NSLog(@"socket closed");
}

- (void)notifyConnectionOpened {
    NSLog(@"socket opened");
}


@end
