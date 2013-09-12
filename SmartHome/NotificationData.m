//
//  NotificationData.m
//  SmartHome
//
//  Created by Zhao yang on 9/9/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NotificationData.h"

@implementation NotificationData

@synthesize masterDeviceCode;
@synthesize requestDeviceCode;
@synthesize dataCommandName;

- (id)initWithJson:(NSDictionary *)json {
    self = [super init];
    if(self) {
        if(json) {
            self.masterDeviceCode = [json stringForKey:@"masterDeviceCode"];
            self.dataCommandName = [json stringForKey:@"className"];
            self.requestDeviceCode = [json stringForKey:@"requsetDeviceCode"];
        }
    }
    return self;
}

- (NSDictionary *)toJson {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setMayBlankString:self.masterDeviceCode forKey:@"masterDeviceCode"];
    [json setMayBlankString:self.dataCommandName forKey:@"className"];
    [json setMayBlankString:self.requestDeviceCode forKey:@"requsetDeviceCode"];
    return json;
}

@end
