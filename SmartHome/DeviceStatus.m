//
//  DeviceStatus.m
//  SmartHome
//
//  Created by Zhao yang on 9/11/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceStatus.h"
#import "NSDictionary+NSNullUtility.h"

@implementation DeviceStatus

@synthesize state;
@synthesize status;
@synthesize deviceIdentifer;

- (id)initWithJson:(NSDictionary *)json {
    self = [super init];
    if(self && json) {
        self.deviceIdentifer = [json stringForKey:@"id"];
        self.status = [json numberForKey:@"status"].integerValue;
        self.state = [json numberForKey:@"state"].integerValue;
    }
    return self;
}

@end
