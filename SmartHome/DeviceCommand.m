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
@synthesize describe;

@synthesize fromInternalNetwork;

- (id)initWithDictionary:(NSDictionary *)json {
    self = [super init];
    if(self) {
        if(json != nil) {
            self.deviceCode = [json stringForKey:@"deviceCode"];
            self.commandName = [json stringForKey:@"_className"];
            self.masterDeviceCode = [json stringForKey:@"masterDeviceCode"];
            self.tcpAddress = [json stringForKey:@"tcp"];
            self.result = [json stringForKey:@"id"];
            self.describe = [json stringForKey:@"describe"];
            self.hashCode = [json numberForKey:@"hashCode"];
            self.resultID = [json integerForKey:@"resultId"];
            self.security = [json stringForKey:@"security"];
            self.commandTime = [json dateForKey:@"commandTime"];
        }
    }
    return self;
}

- (NSMutableDictionary *)toDictionary {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    
    // commons
    [json setObject:APP_KEY forKey:@"appKey"];
    [json setNoNilObject:[SMShared current].settings.secretKey forKey:@"security"];
    [json setNoBlankString:self.deviceCode forKey:@"deviceCode"];
    [json setNoBlankString:self.commandName forKey:@"_className"];
    [json setNoBlankString:self.masterDeviceCode forKey:@"masterDeviceCode"];
    [json setNoBlankString:self.describe forKey:@"describe"];
    [json setDateLongLongValue:self.commandTime forKey:@"commandTime"];
    
    if(([@"FindZKListCommand" isEqualToString:commandName] && ![NSString isBlank:self.masterDeviceCode]) || [@"FindDeviceSceneCommand" isEqualToString:commandName]) {
        if(self.hashCode != nil) {
            [json setObject:self.hashCode forKey:@"hashCode"];
        } else {
            [json setObject:[NSNumber numberWithInteger:0] forKey:@"hashCode"];
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

- (BOOL)isEqual:(id)object {
    if(object == nil) return NO;
    if(self == object) return YES;
    if([object isKindOfClass:[self class]]) {
        DeviceCommand *cmd = (DeviceCommand *)object;
        if(![self.commandName isEqualToString:cmd.commandName]) {
            return NO;
        }
        if(![NSString string:self.masterDeviceCode isEqualString:cmd.masterDeviceCode]) {
            return NO;
        }
        
        if((self.hashCode == nil && cmd.hashCode != nil) || (self.hashCode != nil && cmd.hashCode == nil))
        {
            return NO;
        }
        if(self.hashCode != nil) {
            if(![self.hashCode isEqual:cmd.hashCode]) {
                return NO;
            }
        }
        return YES;
    }
    return NO;
}

@end
