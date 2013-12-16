//
//  SMShared.m
//  SmartHome
//
//  Created by Zhao yang on 8/29/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "SMShared.h"

@implementation SMShared

- (GlobalSettings *)settings {
    return self.app.settings;
}

- (AccountService *)accountService {
    return self.app.accountService;
}

- (AppDelegate *)app {
    return [UIApplication sharedApplication].delegate;
}

- (Memory *)memory {
    return self.app.memory;
}

- (DeviceCommandDeliveryService *)deliveryService {
    return self.app.deviceCommandDeliveryService;
}

+ (SMShared *)current {
    static SMShared *shared = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shared = [[SMShared alloc] init];
    });
    return shared;
}

@end
