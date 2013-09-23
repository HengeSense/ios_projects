//
//  DeviceFinder.m
//  SmartHome
//
//  Created by Zhao yang on 8/27/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceFinder.h"
#import "AsyncUdpSocket.h"
#import "IPAddress.h"
//5050

@implementation DeviceFinder
-(void) startFindingDevice{
    if (self) {
        AsyncUdpSocket *udpSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
        NSString *host = [[[IPAddress alloc] init] getIPAddress];
        NSMutableArray *ipArr = [NSMutableArray arrayWithArray:[host componentsSeparatedByString:@"."]];
        [ipArr setObject:@"255" atIndexedSubscript:3];
        NSString *broadCastAddress = [ipArr componentsJoinedByString:@"."];
        NSString *str = @"A001";
        NSData *sendData = [str dataUsingEncoding:NSUTF8StringEncoding];
        
        [udpSocket enableBroadcast:YES error:nil];
        [udpSocket sendData:sendData toHost:broadCastAddress port:5050 withTimeout:5 tag:1];
        [udpSocket receiveWithTimeout:5 tag:0];
    }
}
-(BOOL) onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port{
    NSLog(@"receive data:%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    return  YES;
}
- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error {
    NSLog(@"not send");
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
    NSLog(@"send");
}

@end
