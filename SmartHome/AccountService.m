//
//  AccountService.m
//  SmartHome
//
//  Created by Zhao yang on 8/23/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "AccountService.h"
#import "NSString+StringUtils.h"

#define SMS_URL @"http://172.16.8.162:6868/FrontServer-1.0/auth/regist"

@implementation AccountService

- (id)init {
    self = [super init];
    if(self) {
        [self setupWithUrl:SMS_URL];
    }
    return self;
}

- (void)sendVerificationCodeFor:(NSString *)phoneNumber success:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb {
    NSString *key = [phoneNumber substringFromIndex:7];
    NSString *checkCode = [NSString stringWithFormat:@"%@%@", phoneNumber, [NSString md5HexDigest:key]];
    NSString *url = [NSString stringWithFormat:@"?mobileCode=%@&checkCode=%@", phoneNumber, checkCode];
    
    [self.client getForUrl:url acceptType:@"text/*" success:s error:f for:t callback:cb];
}

@end
