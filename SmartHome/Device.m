//
//  Device.m
//  SmartHome
//
//  Created by Zhao yang on 8/22/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "Device.h"

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

- (id)initWithJson:(NSDictionary *)json {
    self = [super init];
    if(self) {
        if(json != nil) {
            self.identifier = [json notNSNullObjectForKey:@"code"];
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

@end
