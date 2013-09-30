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
#import "Unit.h"
#import "SMShared.h"

#define APP_KEY @"A001"

static NSString *IP;

@implementation DeviceFinder

@synthesize delegate;
@synthesize deviceIdentifier;

- (id)init {
    self = [super init];
    if (!IP) {
        IPAddressTool *ipTool = [[IPAddressTool alloc] init];
        IP = [ipTool deviceIPAdress];
    }
    return  self;
}

#pragma mark -
#pragma mark Service

- (void)startFindingDevice {
    AsyncUdpSocket *udpSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    NSMutableArray *ipArr = [NSMutableArray arrayWithArray:[IP componentsSeparatedByString:@"."]];
    [ipArr removeLastObject];
    [ipArr addObject:@"255"];
    NSString *broadCastAddress = [ipArr componentsJoinedByString:@"."];
    NSData *sendData = [APP_KEY dataUsingEncoding:NSUTF8StringEncoding];
    [udpSocket enableBroadcast:YES error:nil];
    [udpSocket sendData:sendData toHost:broadCastAddress port:5050 withTimeout:5 tag:1];
    [udpSocket receiveWithTimeout:5 tag:0];
}

- (void)requestForBindingUnit {
    DeviceCommand *bindingUnitCommand = [CommandFactory commandForType:CommandTypeBindingUnit];
    bindingUnitCommand.masterDeviceCode = self.deviceIdentifier;
    [[SMShared current].deliveryService executeDeviceCommand:bindingUnitCommand];
}

#pragma mark-
#pragma mark UDP Delegate

- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port {
    NSDictionary *json =[JsonUtils createDictionaryFromJson:data];
    self.deviceIdentifier = [json noNilStringForKey:@"deviceCode"];
    Unit *unit = [[SMShared current].memory findUnitByIdentifier:self.deviceIdentifier];
    if(unit == nil) {
        if ([self.delegate respondsToSelector:@selector(askwhetherBinding)]) {
            [self.delegate askwhetherBinding];
        }
    }
    return  NO;
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error {
#ifdef DEBUG
    NSLog(@"[UDP DEVICE FINDER] NOT SEND.");
#endif
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag {
#ifdef DEBUG
    NSLog(@"[UDP DEVICE FINDER] SEND.");
#endif
}

@end
