//
//  GlobalSettings.m
//  SmartHome
//
//  Created by Zhao yang on 8/8/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "GlobalSettings.h"
#import "NSString+StringUtils.h"
#import "NSDictionary+NSNullUtility.h"

#define GLOBAL_SETTINGS_KEY       @"global_settings.key"
#define ACCOUNT_KEY               @"account.key"
#define PASSWORD_KEY              @"password.key"
#define SECRET_KEY_KEY            @"secret_key.key"
#define ANY_UNITS_BINDING_KEY     @"any_units_binding.key"

@implementation GlobalSettings

@synthesize account;
@synthesize password;
@synthesize secretKey;
@synthesize anyUnitsBinding;

- (id)init {
    self = [super init];
    if(self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *settings = [defaults objectForKey:GLOBAL_SETTINGS_KEY];
        if(settings == nil) {
            //no settings file before
            self.anyUnitsBinding = NO;
            self.account = [NSString emptyString];
            self.password = [NSString emptyString];
            self.secretKey = [NSString emptyString];
        } else {
            //already have a setting file
            //need to fill object property
            
            NSString *account_obj = [settings notNSNullObjectForKey:ACCOUNT_KEY];
            NSString *password_obj = [settings notNSNullObjectForKey:PASSWORD_KEY];
            NSString *secret_key_obj = [settings notNSNullObjectForKey:SECRET_KEY_KEY];
            NSString *any_unit_binding_obj  = [settings notNSNullObjectForKey:ANY_UNITS_BINDING_KEY];
            
            if(![NSString isBlank:account_obj]) {
                self.account = account_obj;
            } else {
                self.account = [NSString emptyString];
            }
            
            if(![NSString isBlank:password_obj]) {
                self.password = password_obj;
            } else {
                self.password = [NSString emptyString];
            }
            
            if(![NSString isBlank:secret_key_obj]) {
                self.secretKey = secret_key_obj;
            } else {
                self.secretKey = [NSString emptyString];
            }
            
            if(![NSString isBlank:any_unit_binding_obj]) {
                if([@"yes" isEqualToString:any_unit_binding_obj]) {
                    self.anyUnitsBinding = YES;
                } else {
                    self.anyUnitsBinding = NO;
                }
            }
        }
    }
    return self;
}

- (NSDictionary *)toDictionary {
    //convert self to a dictionary
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:self.account forKey:ACCOUNT_KEY];
    [dictionary setObject:self.password forKey:PASSWORD_KEY];
    [dictionary setObject:self.secretKey forKey:SECRET_KEY_KEY];
    [dictionary setObject:(self.anyUnitsBinding ? @"yes" : @"no") forKey:ANY_UNITS_BINDING_KEY];
    return dictionary;
}

- (void)clearAuth {
    self.secretKey = [NSString emptyString];
    self.account = [NSString emptyString];
    self.password = [NSString emptyString];
    [self saveSettings];
}

- (void)saveSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self toDictionary] forKey:GLOBAL_SETTINGS_KEY];
    [defaults synchronize];
}

@end
