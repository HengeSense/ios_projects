//
//  UnitFinder.m
//  SmartHome
//
//  Created by Zhao yang on 8/27/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "UnitFinder.h"
#import "AsyncUdpSocket.h"
#import "JsonUtils.h"
#import "SMNetworkTool.h"
#import "NSDictionary+Extension.h"
#import "Unit.h"
#import "SMShared.h"

#define APP_KEY @"A001"

@implementation UnitFinder {
    BOOL hasReceivedData;
}

@synthesize delegate;

#pragma mark -
#pragma mark Service

- (void)findUnit {
    hasReceivedData = NO;
    
    // Get local ip
    NSString *localIp = [SMNetworkTool getLocalIp];
    
    if([NSString isBlank:localIp]) {
        // Get local ip failed .
        [self findUnitOnError:nil];
        return;
    }
    
    // Get broadcast address
    NSMutableArray *ipArr = [NSMutableArray arrayWithArray:[localIp componentsSeparatedByString:@"."]];
    [ipArr removeLastObject];
    [ipArr addObject:@"255"];
    NSString *broadCastAddress = [ipArr componentsJoinedByString:@"."];
#ifdef DEBUG
    NSLog(@"[UDP UNIT FINDER] Local Ip is %@, Broadcast Address is %@", localIp, broadCastAddress);
#endif
    
    // Initial udp socket
    AsyncUdpSocket *udpSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    
    // Broadcast to local network
    NSError *error;
    if([udpSocket enableBroadcast:YES error:&error]) {
        [udpSocket sendData:[self generateBroadcastMessage] toHost:broadCastAddress port:5050 withTimeout:5 tag:1];
        [udpSocket receiveWithTimeout:5 tag:0];
    } else {
        if(error != nil) {
#ifdef DEBUG
            NSString *errorMessage = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
            NSLog(@"[UDP UNIT FINDER] Broadcast failed, Reason is [%@]", [NSString isBlank:errorMessage] ? [NSString emptyString] : errorMessage);
#endif
            [self findUnitOnError:error];
        }
    }
    
    [udpSocket closeAfterReceiving];
}

- (NSData *)generateBroadcastMessage {
    return [APP_KEY dataUsingEncoding:NSUTF8StringEncoding];
}

#pragma mark-
#pragma mark UDP Delegate

- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port {
    
    hasReceivedData = YES;
    
    NSDictionary *json =[JsonUtils createDictionaryFromJson:data];
    
    if(json == nil) {
        [self findUnitOnError:nil];
        return NO;
    }
    
    NSString *unitIdentifier = [json noNilStringForKey:@"deviceCode"];
    NSString *unitUrl = [NSString stringWithFormat:@"http://%@:%d/gatewaycfg",[json noNilStringForKey:@"ipv4"], 8777];
    
    if ([self.delegate respondsToSelector:@selector(findUnitSuccessWithIdentifier:url:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate findUnitSuccessWithIdentifier:unitIdentifier url:unitUrl];
        });
    }
    
    return  NO;
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error {
#ifdef DEBUG
    NSString *errorMessage = [error.userInfo objectForKey:NSLocalizedDescriptionKey];
    NSLog(@"[UDP UNIT FINDER] Broadcast(on udp socket) message failed, Reason is [%@]", [NSString isBlank:errorMessage] ? [NSString emptyString] : errorMessage);
#endif
    [self findUnitOnError:error];
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
#ifdef DEBUG
    NSLog(@"[UDP UNIT FINDER] Broadcast message successfully.");
#endif
}

- (void)onUdpSocketDidClose:(AsyncUdpSocket *)sock {
    if(!hasReceivedData) {
        [self findUnitOnError:nil];
    }
#ifdef DEBUG
    NSLog(@"[UDP UNIT FINDER] Closed.");
#endif
}

- (void)findUnitOnError:(NSError *)error {
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(findUnitFailed:)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate findUnitFailed:error];
        });
    }
}

@end
