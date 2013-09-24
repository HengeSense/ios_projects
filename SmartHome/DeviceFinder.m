//
//  DeviceFinder.m
//  SmartHome
//
//  Created by Zhao yang on 8/27/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceFinder.h"
#import "AsyncUdpSocket.h"
#import "IPAddressTool.h"
#import "IPAddress.h"
#import "JsonUtils.h"
#import "NSDictionary+Extension.h"

//5050
static NSString *IP;
@implementation DeviceFinder
-(id) init{
    self = [super init];
    if (!IP) {
        IPAddressTool *ipTool = [[IPAddressTool alloc] init];
        IP = [ipTool deviceIPAdress];
    }
    return  self;
}
-(void) startFindingDevice{
    if (self) {
        AsyncUdpSocket *udpSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
        NSLog(@"host:%@",IP);
        NSMutableArray *ipArr = [NSMutableArray arrayWithArray:[IP componentsSeparatedByString:@"."]];
        [ipArr removeLastObject];
        [ipArr addObject:@"255"];
        NSString *broadCastAddress = [ipArr componentsJoinedByString:@"."];
        NSString *str = @"A001";
        NSData *sendData = [str dataUsingEncoding:NSUTF8StringEncoding];
        NSLog(@"broadCastAddress:%@",broadCastAddress);
        [udpSocket enableBroadcast:YES error:nil];
        [udpSocket sendData:sendData toHost:broadCastAddress port:5050 withTimeout:5 tag:1];
        [udpSocket receiveWithTimeout:5 tag:0];
    }
}
-(BOOL) onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port{
    NSDictionary *json =[JsonUtils createDictionaryFromJson:data];

    NSString *deviceCode = [json noNilStringForKey:@"deviceCode"];
    
    NSLog(@"receive data:%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    NSLog(@"json:%@",json);
    NSLog(@"deviceCode:%@",deviceCode);
    NSLog(@"server ip:%@",host);
    return  YES;
}
- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error {
    NSLog(@"not send");
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
    NSLog(@"send");
}

@end
