//
//  DeviceCommandUpdateAccount.m
//  SmartHome
//
//  Created by Zhao yang on 9/3/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandUpdateAccount.h"
#import "NSString+StringUtils.h"

@implementation DeviceCommandUpdateAccount

@synthesize oldPwd;
@synthesize pwdToUpdate;
@synthesize screenName;
@synthesize email;

- (id)initWithDictionary:(NSDictionary *)json {
    self = [super initWithDictionary:json];
    if(self) {
        self.screenName = [json notNSNullObjectForKey:@"screenName"];
        self.email = [json notNSNullObjectForKey:@"email"];
    }
    return self;
}

- (NSMutableDictionary *)toDictionary {
    NSMutableDictionary *json = [super toDictionary];
    
    if(![NSString isBlank:self.oldPwd]) {
        [json setObject:self.oldPwd forKey:@"oldPwd"];
    } else {
        [json setObject:[NSString emptyString] forKey:@"oldPwd"];
    }
    
    if(![NSString isBlank:self.pwdToUpdate]) {
        [json setObject:self.pwdToUpdate forKey:@"newPwd"];
    } else {
        [json setObject:[NSString emptyString] forKey:@"newPwd"];
    }
    
    if(![NSString isBlank:self.screenName]) {
        [json setObject:self.screenName forKey:@"screenName"];
    } else {
        [json setObject:[NSString emptyString] forKey:@"screenName"];
    }
    
    if(![NSString isBlank:self.email]) {
        [json setObject:self.email forKey:@"email"];
    } else {
        [json setObject:[NSString emptyString] forKey:@"email"];
    }
    
    return json;
}

@end
