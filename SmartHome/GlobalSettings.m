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

#define ACCOUNT_PHONE_KEY    @"account.phone.key"
#define IS_VALID_KEY         @"is.valid.key"

@implementation GlobalSettings

@synthesize accountPhone;
@synthesize isValid;

- (id)init {
    self = [super init];
    if(self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *settings = [defaults objectForKey:GLOBAL_SETTINGS_KEY];
        if(settings == nil) {
            //no settings file before
            self.isValid = NO;
            self.accountPhone = [NSString emptyString];
        } else {
            //already have a setting file
            //need to fill object property
            NSString *acc_phone_obj = [settings notNSNullObjectForKey:ACCOUNT_PHONE_KEY];
            NSString *is_valid_obj  = [settings notNSNullObjectForKey:IS_VALID_KEY];
            
            if(![NSString isBlank:acc_phone_obj]) {
                self.accountPhone = acc_phone_obj;
            } else {
                self.accountPhone = [NSString emptyString];
            }
            
            if(![NSString isBlank:is_valid_obj]) {
                if([@"yes" isEqualToString:is_valid_obj]) {
                    self.isValid = YES;
                } else {
                    self.isValid = NO;
                }
            }
        }
    }
    return self;
}

- (NSDictionary *)toDictionary {
    //convert self to a dictionary
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    [dictionary setObject:(self.isValid ? @"yes" : @"no") forKey:IS_VALID_KEY];
    [dictionary setObject:self.accountPhone forKey:ACCOUNT_PHONE_KEY];
    
    return dictionary;
}

- (void)saveSettings {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self toDictionary] forKey:GLOBAL_SETTINGS_KEY];
    [defaults synchronize];
}

@end
