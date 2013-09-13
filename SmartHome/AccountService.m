//
//  AccountService.m
//  SmartHome
//
//  Created by Zhao yang on 8/23/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "AccountService.h"
#import "NSString+StringUtils.h"

#define SMS_URL @"http://172.16.8.162:6868/FrontServer-1.0/auth"
#define MD5_KEY @"FFFF"

@implementation AccountService

- (id)init {
    self = [super init];
    if(self) {
        [self setupWithUrl:SMS_URL];
    }
    return self;
}

- (void)sendVerificationCodeFor:(NSString *)phoneNumber success:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb {
    NSString *checkCode = [NSString md5HexDigest:[NSString stringWithFormat:@"%@%@", phoneNumber, MD5_KEY]];
    NSString *url = [NSString stringWithFormat:@"/regist?mobileCode=%@&checkCode=%@", phoneNumber, checkCode];
    [self.client getForUrl:url acceptType:@"text/*" success:s error:f for:t callback:cb];
}

- (void)registerWithPhoneNumber:(NSString *)phoneNumber checkCode:(NSString *)checkCode success:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb {
    NSString *url = [NSString stringWithFormat:@"/regist/confirm?mobileCode=%@&checkCode=%@&phoneType=%@&mac=%@&appKey=%@", phoneNumber, checkCode, PHONE_TYPE, phoneNumber, APP_KEY];
    [self.client getForUrl:url acceptType:@"text/*" success:s error:f for:t callback:cb];
}

- (void)loginWithAccount:(NSString *)account password:(NSString *)pwd success:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb {
    NSString *url = [NSString stringWithFormat:@"/login?mobileCode=%@&pwd=%@&appKey=%@&phoneType=%@",account, pwd,APP_KEY, PHONE_TYPE];
    [self.client getForUrl:url acceptType:@"text/*" success:s error:f for:t callback:cb];
}

- (void)sendPasswordToMobile:(NSString *)phoneNumber success:(SEL)s failed:(SEL)f target:(id)t callback:(id)cb {
    NSString *url = [NSString stringWithFormat:@"/forget/pwd?mobileCode=%@&checkCode=%@", phoneNumber, [NSString md5HexDigest:[NSString stringWithFormat:@"%@FFFF", phoneNumber]]];
    [self.client getForUrl:url acceptType:@"text/*" success:s error:f for:t callback:cb];
}
                     
@end
