//
//  Device.m
//  SmartHome
//
//  Created by Zhao yang on 8/22/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "Device.h"
#import "NSString+StringUtils.h"

@implementation Device

@synthesize category;
@synthesize ep;
@synthesize identifier;
@synthesize ip;
@synthesize irType;
@synthesize state;
@synthesize status;
@synthesize port;
@synthesize pwd;
@synthesize resolution;
@synthesize type;
@synthesize name;
@synthesize nwkAddr;
@synthesize user;

@synthesize isRemote;
@synthesize isSccurtain;
@synthesize isCurtain;
@synthesize isInlight;
@synthesize isLightOrInlight;
@synthesize isAircondition;
@synthesize isCurtainOrSccurtain;
@synthesize isLight;
@synthesize isSocket;
@synthesize isSTB;
@synthesize isTV;
@synthesize isCamera;

@synthesize isOnline;

- (id)initWithJson:(NSDictionary *)json {
    self = [super init];
    if(self) {
        if(json != nil) {
            self.category = [json notNSNullObjectForKey:@"category"];
            self.ep = [json numberForKey:@"ep"].integerValue;
            self.identifier = [json notNSNullObjectForKey:@"code"];
            self.ip = [json notNSNullObjectForKey:@"ip"];
            self.irType = [json numberForKey:@"irType"].integerValue;
            self.status = [json numberForKey:@"status"].integerValue;
            self.state = [json numberForKey:@"state"].integerValue;
            self.port = [json numberForKey:@"port"].integerValue;
            self.pwd = [json notNSNullObjectForKey:@"pwd"];
            self.resolution = [json numberForKey:@"resolution"].integerValue;
            self.type = [json numberForKey:@"type"].integerValue;
            self.name = [json notNSNullObjectForKey:@"name"];
            self.nwkAddr = [json notNSNullObjectForKey:@"nwkAddr"];
            self.user = [json notNSNullObjectForKey:@"user"];
        }
    }
    return self;
}

- (NSDictionary *)toJson {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:([NSString isBlank:self.category] ? [NSString emptyString] : self.category) forKey:@"category"];
    [json setObject:[NSNumber numberWithInteger:self.ep] forKey:@"ep"];
    [json setObject:([NSString isBlank:self.identifier] ? [NSString emptyString] : self.identifier) forKey:@"code"];
    [json setObject:([NSString isBlank:self.ip] ? [NSString emptyString] : self.ip) forKey:@"ip"];
    [json setObject:[NSNumber numberWithInteger:self.irType] forKey:@"irType"];
    [json setObject:[NSNumber numberWithInteger:self.status] forKey:@"status"];
    [json setObject:[NSNumber numberWithInteger:self.state] forKey:@"state"];
    [json setObject:[NSNumber numberWithInteger:self.port] forKey:@"port"];
    [json setObject:([NSString isBlank:self.pwd] ? [NSString emptyString] : self.pwd) forKey:@"pwd"];
    [json setObject:[NSNumber numberWithInteger:self.resolution] forKey:@"resolution"];
    [json setObject:[NSNumber numberWithInteger:self.type] forKey:@"type"];
    [json setObject:([NSString isBlank:self.name] ? [NSString emptyString] : self.name) forKey:@"name"];
    [json setObject:([NSString isBlank:self.nwkAddr] ? [NSString emptyString] : self.nwkAddr) forKey:@"nwkAddr"];
    [json setObject:([NSString isBlank:self.user] ? [NSString emptyString] : self.user) forKey:@"user"];
    return json;
}

- (NSString *)commandString {
    return [NSString stringWithFormat:@"%@-%@-%d", self.category, self.identifier, self.status];
}

#pragma mark -
#pragma mark device type or state

- (BOOL)isLight {
    return [@"light" isEqualToString:self.category];
}

- (BOOL)isInlight {
    return [@"lnlight" isEqualToString:self.category];
}

- (BOOL)isLightOrInlight {
    return [self isLight] || [self isInlight];
}

- (BOOL)isSocket {
    return [@"socket" isEqualToString:self.category];
}

- (BOOL)isCurtain {
    return [@"curtain" isEqualToString:self.category];
}

- (BOOL)isSccurtain {
    return [@"sccurtain" isEqualToString:self.category];
}

- (BOOL)isCurtainOrSccurtain {
    return [self isCurtain] || [self isSccurtain];
}

- (BOOL)isRemote {
    return [@"remote" isEqualToString:self.category];
}

- (BOOL)isTV {
    return [self isRemote] && self.irType == 1;
}

- (BOOL)isAircondition {
    return [self isRemote] && self.irType == 4;
}

- (BOOL)isSTB {
    return [self isRemote] && self.irType == 3;
}

- (BOOL)isCamera {
    return [@"camera" isEqualToString:self.category];
}

- (BOOL)isOnline {
    return self.state == 1;
}

@end
