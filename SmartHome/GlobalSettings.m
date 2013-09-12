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

#define GLOBAL_SETTINGS_KEY       @"global_settings.key"
#define ACCOUNT_KEY               @"account.key"
#define SECRET_KEY_KEY            @"secret_key.key"
#define ANY_UNITS_BINDING_KEY     @"any_units_binding.key"
#define TCP_ADDRESS_KEY           @"tcp_address.key"
#define DEVICE_CODE_KEY           @"device_code.key"

@implementation GlobalSettings

@synthesize account;
@synthesize secretKey;
@synthesize tcpAddress;
@synthesize anyUnitsBinding;
@synthesize deviceCode;

- (id)init {
    self = [super init];
    if(self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *settings = [defaults objectForKey:GLOBAL_SETTINGS_KEY];
        if(settings == nil) {
            //no settings file before
            self.anyUnitsBinding = NO;
            self.account = [NSString emptyString];
            self.secretKey = [NSString emptyString];
            self.tcpAddress = [NSString emptyString];
            self.deviceCode = [NSString emptyString];
        } else {
            //already have a setting file
            //need to fill object property
            
            NSString *account_obj = [settings notNSNullObjectForKey:ACCOUNT_KEY];
            NSString *secret_key_obj = [settings notNSNullObjectForKey:SECRET_KEY_KEY];
            NSString *any_unit_binding_obj  = [settings notNSNullObjectForKey:ANY_UNITS_BINDING_KEY];
            NSString *tcp_address_obj = [settings notNSNullObjectForKey:TCP_ADDRESS_KEY];
            NSString *device_code_obj = [settings notNSNullObjectForKey:DEVICE_CODE_KEY];
            
            if(![NSString isBlank:device_code_obj]) {
                self.deviceCode = device_code_obj;
            } else {
                self.deviceCode = [NSString emptyString];
            }
            
            if(![NSString isBlank:account_obj]) {
                self.account = account_obj;
            } else {
                self.account = [NSString emptyString];
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
            
            if(![NSString isBlank:tcp_address_obj]) {
                self.tcpAddress = tcp_address_obj;
            } else {
                self.tcpAddress = [NSString emptyString];
            }
        }
    }
    return self;
}

- (NSDictionary *)toDictionary {
    //convert self to a dictionary
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setObject:self.account forKey:ACCOUNT_KEY];
    [dictionary setObject:self.secretKey forKey:SECRET_KEY_KEY];
    [dictionary setObject:(self.anyUnitsBinding ? @"yes" : @"no") forKey:ANY_UNITS_BINDING_KEY];
    [dictionary setObject:self.tcpAddress forKey:TCP_ADDRESS_KEY];
    [dictionary setObject:self.deviceCode forKey:DEVICE_CODE_KEY];
    return dictionary;
}

- (void)clearAuth {
    self.secretKey = [NSString emptyString];
    self.account = [NSString emptyString];
    self.deviceCode = [NSString emptyString];
    [self saveSettings];
}

- (void)saveSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self toDictionary] forKey:GLOBAL_SETTINGS_KEY];
    [defaults synchronize];
}

@end
