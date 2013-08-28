//
//  NSObject+SMExtension.m
//  SmartHome
//
//  Created by Zhao yang on 8/28/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NSObject+SMExtension.h"

@implementation NSObject (SMExtension)

- (GlobalSettings *)settings {
    return self.app.settings;
}

- (AccountService *)accountService {
    return self.app.accountService;
}

- (AppDelegate *)app {
    return [UIApplication sharedApplication].delegate;
}

@end
