//
//  DeviceCommandUpdateAccount.m
//  SmartHome
//
//  Created by Zhao yang on 9/3/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandUpdateAccount.h"

@implementation DeviceCommandUpdateAccount

@synthesize oldPwd;
@synthesize pwdToUpdate;
@synthesize screenName;
@synthesize email;

- (id)initWithDictionary:(NSDictionary *)json {
    self = [super initWithDictionary:json];
    if(self) {
        self.screenName = [json stringForKey:@"screenName"];
        self.email = [json stringForKey:@"email"];
    }
    return self;
}

- (NSMutableDictionary *)toDictionary {
    NSMutableDictionary *json = [super toDictionary];
    [json setMayBlankString:self.oldPwd forKey:@"oldPwd"];
    [json setMayBlankString:self.pwdToUpdate forKey:@"newPwd"];
    [json setMayBlankString:self.screenName forKey:@"screenName"];
    [json setMayBlankString:self.email forKey:@"email"];
    return json;
}

- (BOOL)isEqual:(id)object {
    if(![super isEqual:object]) {
        return NO;
    }
    if(![object isKindOfClass:[DeviceCommandUpdateAccount class]]) {
        return NO;
    }
    DeviceCommandUpdateAccount *cmd = (DeviceCommandUpdateAccount *)object;
    
    if(![NSString string:self.oldPwd isEqualString:cmd.oldPwd]) {
        return NO;
    }
    
    if(![NSString string:self.pwdToUpdate isEqualString:cmd.pwdToUpdate]) {
        return NO;
    }
    
    if(![NSString string:self.screenName isEqualString:cmd.screenName]) {
        return NO;
    }
    
    if(![NSString string:self.email isEqualString:cmd.email]) {
        return NO;
    }
    
    return YES;
}

@end
