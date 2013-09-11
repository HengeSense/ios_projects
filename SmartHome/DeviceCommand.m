//
//  DeviceCommand.m
//  SmartHome
//
//  Created by Zhao yang on 8/19/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommand.h"
#import "NSString+StringUtils.h"
#import "JsonUtils.h"
#import "SMShared.h"

@implementation DeviceCommand

@synthesize result;
@synthesize resultID;
@synthesize deviceCode;
@synthesize commandName;
@synthesize commandTime;
@synthesize masterDeviceCode;
@synthesize appKey;
@synthesize security;
@synthesize tcpAddress;
@synthesize hashCode;
@synthesize updateTime;
@synthesize describe;

- (id)initWithDictionary:(NSDictionary *)json {
    self = [super init];
    if(self) {
        if(json != nil) {
            self.deviceCode = [json notNSNullObjectForKey:@"deviceCode"];
            self.commandName = [json notNSNullObjectForKey:@"_className"];
            self.masterDeviceCode = [json notNSNullObjectForKey:@"masterDeviceCode"];
            self.tcpAddress = [json notNSNullObjectForKey:@"tcp"];
            self.result = [json notNSNullObjectForKey:@"id"];
            self.describe = [json notNSNullObjectForKey:@"describe"];
            self.hashCode = [json numberForKey:@"hashCode"];
            self.resultID = [json numberForKey:@"resultId"].integerValue;
            self.security = [json notNSNullObjectForKey:@"security"];
            self.commandTime = [json dateForKey:@"commandTime"];
        }
    }
    return self;
}

- (NSMutableDictionary *)toDictionary {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    // commons
    [json setObject:APP_KEY forKey:@"appKey"];
    [json setObject:[SMShared current].settings.secretKey forKey:@"security"];
    
    if(![NSString isBlank:self.deviceCode]) {
        [json setObject:self.deviceCode forKey:@"deviceCode"];
    }
    
    if(![NSString isBlank:self.commandName]) {
        [json setObject:self.commandName forKey:@"_className"];
    }
    
    if(![NSString isBlank:self.masterDeviceCode]) {
        [json setObject:self.masterDeviceCode forKey:@"masterDeviceCode"];
    }
    
    if(![NSString isBlank:self.describe]) {
        [json setObject:self.describe forKey:@"describe"];
    }
    
    if(self.commandTime != nil) {
        [json setObject:[NSNumber numberWithLongLong:(long long)self.commandTime.timeIntervalSince1970] forKey:@"commandTime"];
    }
    
    if([@"FindZKListCommand" isEqualToString:commandName] || [@"FindDeviceSceneCommand" isEqualToString:commandName]) {
        if(self.hashCode != nil) {
            [json setObject:self.hashCode forKey:@"hashCode"];
        }
    }

    return json;
}

- (NSString *)appKey {
    return APP_KEY;
}

- (NSString *)deviceCode {
    if([NSString isBlank:deviceCode]) {
        return [SMShared current].settings.deviceCode;
    }
    return deviceCode;
}

- (NSString *)security {
    if([NSString isBlank:security]) {
        return [SMShared current].settings.secretKey;
    }
    return security;
}

@end
