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
            
        }
    }
    return self;
}

@end
