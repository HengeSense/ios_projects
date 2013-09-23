//
//  DeviceFinder.m
//  SmartHome
//
//  Created by Zhao yang on 8/27/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceFinder.h"
#import "AsyncUdpSocket.h"

//5050

@implementation DeviceFinder

+ (void)startFindingDevice {
    AsyncUdpSocket *udpSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    
    NSString *str = @"hello";
    
NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
       [udpSocket sendData:data toHost:@"192.168.0.255" port:5050 withTimeout:-1 tag:0];
 
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error {
    NSLog(@"not send");
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
    NSLog(@"send");
}

@end
