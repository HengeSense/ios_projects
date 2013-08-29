//
//  TCPService.m
//  SmartHome
//
//  Created by Zhao yang on 8/28/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "TCPService.h"

@implementation TCPService {
    ExtranetClientSocket *socket;
}

- (id)init {
    self = [super init];
    if(self) {
        
    }
    return self;
}

- (void)executeCommand:(DeviceCommand *)command {
    
}

- (void)clientSocketMessageDiscard:(NSData *)discardMessage {
    
}

- (void)clientSocketMessageReadError {
    
}

- (void)clientSocketWithReceivedMessage:(NSString *)messages {
    
}

@end
