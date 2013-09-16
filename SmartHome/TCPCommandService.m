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
    
    /*      */
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

- (void)executeDeviceCommand:(DeviceCommand *)command {
    if(command == nil) return;
    [queue pushCommand:command];
    
    [self performSelectorInBackground:@selector(flushQueue) withObject:nil];
}

- (void)flushQueue {
    @synchronized(self) {
        if(self.isConnectted && [socket canWrite] && queue.count > 0) {
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
    NSData *dd =    [JsonUtils createJsonDataFromDictionary:[JsonUtils createDictionaryFromJson:messages]];
    NSLog([[NSString alloc] initWithData:dd encoding:NSUTF8StringEncoding]);
    
    DeviceCommand *command = [CommandFactory commandFromJson:[JsonUtils createDictionaryFromJson:messages]];
    [[SMShared current].deliveryService handleDeviceCommand:command];
}

- (void)notifyConnectionClosed {
    @synchronized(self) {
        flag = NO;
        NSLog(@"socket closed");
    }
}

- (void)notifyConnectionOpened {
    NSLog(@"socket opened");
}


@end
