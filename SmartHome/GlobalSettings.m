//
//  GlobalSettings.m
//  SmartHome
//
//  Created by Zhao yang on 8/8/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "GlobalSettings.h"
#import "NSString+StringUtils.h"
#import "NSDictionary+Extension.h"
#import "NSMutableDictionary+Extension.h"

#define GLOBAL_SETTINGS_KEY       @"global_settings.key"
#define ACCOUNT_KEY               @"account.key"
#define SECRET_KEY_KEY            @"secret_key.key"
#define TCP_ADDRESS_KEY           @"tcp_address.key"
#define DEVICE_CODE_KEY           @"device_code.key"
#define FIRST_TIME_OPEN_APP_KEY   @"first_time_opa.key"
#define IS_VOICE_KEY              @"is_voice.key"
#define IS_SHAKE_KEY              @"is_shake.key"
#define DEVICE_TOKEN_KEY          @"device_token.key"

@implementation GlobalSettings

@synthesize account;
@synthesize secretKey;
@synthesize deviceCode;
@synthesize deviceToken;
@synthesize tcpAddress;
@synthesize isFirstTimeOpenApp;
@synthesize isShake;
@synthesize isVoice;

- (id)init {
    self = [super init];
    if(self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *settings = [defaults objectForKey:GLOBAL_SETTINGS_KEY];
        if(settings == nil) {
            //no settings file before
            self.isFirstTimeOpenApp = YES;
            self.account = [NSString emptyString];
            self.secretKey = [NSString emptyString];
            self.tcpAddress = [NSString emptyString];
            self.deviceCode = [NSString emptyString];
            self.deviceToken = [NSString emptyString];
            self.isVoice = YES;
            self.isShake = NO;
        } else {
            //already have a setting file
            //need to fill object property
            self.account = [settings noNilStringForKey:ACCOUNT_KEY];
            self.secretKey = [settings noNilStringForKey:SECRET_KEY_KEY];
            self.tcpAddress = [settings noNilStringForKey:TCP_ADDRESS_KEY];
            self.deviceCode = [settings noNilStringForKey:DEVICE_CODE_KEY];
            self.isFirstTimeOpenApp = [settings boolForKey:FIRST_TIME_OPEN_APP_KEY];
            self.isShake = [settings boolForKey:IS_SHAKE_KEY];
            self.isVoice = [settings boolForKey:IS_VOICE_KEY];
            self.deviceToken = [settings noNilStringForKey:DEVICE_TOKEN_KEY];
        }
    }
    return self;
}

- (NSDictionary *)toDictionary {
    //convert self to a dictionary
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setMayBlankString:self.account forKey:ACCOUNT_KEY];
    [dictionary setMayBlankString:self.secretKey forKey:SECRET_KEY_KEY];
    [dictionary setMayBlankString:self.deviceToken forKey:DEVICE_TOKEN_KEY];
    [dictionary setMayBlankString:self.tcpAddress forKey:TCP_ADDRESS_KEY];
    [dictionary setMayBlankString:self.deviceCode forKey:DEVICE_CODE_KEY];
    [dictionary setBool:self.isFirstTimeOpenApp forKey:FIRST_TIME_OPEN_APP_KEY];
    [dictionary setBool:self.isShake forKey:IS_SHAKE_KEY];
    [dictionary setBool:self.isVoice forKey:IS_VOICE_KEY];
    return dictionary;
}

- (void)saveSettingsInternal {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self toDictionary] forKey:GLOBAL_SETTINGS_KEY];
    [defaults synchronize];
}

- (void)clearAuth {
    @synchronized(self) {
        self.secretKey = [NSString emptyString];
        self.account = [NSString emptyString];
        self.deviceCode = [NSString emptyString];
        self.deviceToken = [NSString emptyString];
        [self saveSettingsInternal];
    }
}

- (void)saveSettings {
    @synchronized(self) {
        [self saveSettingsInternal];
    }
}

@end
