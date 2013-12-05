//
//  SceneMode.m
//  SmartHome
//
//  Created by Zhao yang on 9/6/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "SceneMode.h"

@implementation SceneMode

@synthesize masterDeviceCode;
@synthesize code;
@synthesize name;
@synthesize type;

- (id)initWithJson:(NSDictionary *)json {
    self = [super init];
    if(self && json) {
        self.name = [json stringForKey:@"name"];
        self.type = [json stringForKey:@"type"];
        self.code = [json integerForKey:@"code"];
        self.masterDeviceCode = [json noNilStringForKey:@"masterDeviceCode"];
    }
    return self;
}

- (NSMutableDictionary *)toJson {
    NSMutableDictionary *json = [super toJson];
    if(json) {
        [json setInteger:self.code forKey:@"code"];
        [json setNoBlankString:self.type forKey:@"type"];
        [json setMayBlankString:self.name forKey:@"name"];
        [json setMayBlankString:self.masterDeviceCode forKey:@"masterDeviceCode"];
    }
    return json;
}

- (BOOL)isSecurityMode {
    if([NSString isBlank:self.type]) return YES;
    if([@"b" isEqualToString:self.type]) {
        return NO;
    } else if([@"s" isEqualToString:self.type]) {
        return YES;
    } else {
        return YES;
    }
}

@end
