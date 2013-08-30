//
//  Device.m
//  SmartHome
//
//  Created by Zhao yang on 8/22/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "Device.h"

@implementation Device

@synthesize eleState;
@synthesize label;
@synthesize mac;
@synthesize name;
@synthesize status;
@synthesize type;

- (id)initWithJson:(NSDictionary *)json {
    self = [super init];
    if(self) {
        if(json != nil) {
            NSLog(@"begin");
            self.eleState = [json notNSNullObjectForKey:@"eleState"];
            self.label = [json notNSNullObjectForKey:@"label"];
            self.mac = [json notNSNullObjectForKey:@"mac"];
            self.status = [json notNSNullObjectForKey:@"status"];
            self.type = [json notNSNullObjectForKey:@"type"];
            NSLog(@"end");
        }
    }
    return self;
}

@end
