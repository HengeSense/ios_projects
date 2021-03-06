//
//  SMNetworkTool.m
//  SmartHome
//
//  Created by Zhao yang on 10/21/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "SMNetworkTool.h"
#import "NSString+StringUtils.h"
#include <ifaddrs.h>
#include <arpa/inet.h>

@implementation SMNetworkTool

+ (NSString *)getLocalIp {
    NSString *address = [NSString emptyString];
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while (temp_addr != NULL) {
            if( temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if ([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            
            temp_addr = temp_addr->ifa_next;
        }
    }
    
    // Free memory
    freeifaddrs(interfaces);
    
    return address;
}

@end
