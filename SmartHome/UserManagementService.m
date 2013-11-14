//
//  UserManagementService.m
//  SmartHome
//
//  Created by Zhao yang on 11/14/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "UserManagementService.h"
#import "SMShared.h"

#define USER_MANAGE_URL @"http://smarthome.hentre.com:6868/FrontServer-1.0/mgr/acc"

@implementation UserManagementService

- (id)init {
    self = [super init];
    if(self) {
        [self setupWithUrl:[NSString stringWithFormat:@"%@/mgr/acc", [SMShared current].settings.restAddress]];
    }
    return self;
}

- (void)usersForUnit:(NSString *)unitIdentifier success:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb {
    NSString *url = [NSString stringWithFormat:@"/list/%@?deviceCode=%@&appKey=%@&security=%@", unitIdentifier, [SMShared current].settings.deviceCode, APP_KEY, [SMShared current].settings.secretKey];
    [self.client getForUrl:url acceptType:@"text/*" success:s error:f for:t callback:cb];
}

- (void)unBindUnit:(NSString *)unitIdentifier forUser:(NSString *)userIdentifier success:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb {
    NSString *url = [NSString stringWithFormat:@"/unbind/%@?deviceCode=%@&appKey=%@&security=%@", unitIdentifier, [SMShared current].settings.deviceCode, APP_KEY, [SMShared current].settings.secretKey];
    [self.client getForUrl:url acceptType:@"text/*" success:s error:f for:t callback:cb];
}

@end
