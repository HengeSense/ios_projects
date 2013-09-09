//
//  NotificationData.m
//  SmartHome
//
//  Created by Zhao yang on 9/9/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NotificationData.h"
#import "NSDictionary+NSNullUtility.h"

@implementation NotificationData

@synthesize masterDeviceCode;
@synthesize requestDeviceCode;
@synthesize dataCommandName;

- (id)initWithJson:(NSDictionary *)json {
    self = [super init];
    if(self) {
        if(json) {
            self.masterDeviceCode = [json notNSNullObjectForKey:@"masterDeviceCode"];
            self.dataCommandName = [json notNSNullObjectForKey:@"className"];
            self.requestDeviceCode = [json notNSNullObjectForKey:@"requsetDeviceCode"];
        }
    }
    return self;
}

@end
