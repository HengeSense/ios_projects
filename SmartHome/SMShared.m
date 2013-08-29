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

+ (SMShared *)current {
    static SMShared *shared;
    if(shared == nil) {
        shared = [[SMShared alloc] init];
    }
    return shared;
}

@end
