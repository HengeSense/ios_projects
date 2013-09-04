//
//  CommandFactory.m
//  SmartHome
//
//  Created by Zhao yang on 9/3/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "CommandFactory.h"
#import "DeviceCommandUpdateAccount.h"
#import "DeviceCommandUpdateUnits.h"

@implementation CommandFactory

+ (DeviceCommand *)commandForType:(CommandType)type {
    if(type == CommandTypeNone) return nil;
    
    if(type == CommandTypeUpdateAccount) {
        DeviceCommandUpdateAccount *command = [[DeviceCommandUpdateAccount alloc] init];
        command.commandName = @"AccountUpdateCommand";
        return command;
    } else if(type == CommandTypeGetAccount) {
        DeviceCommand *command = [[DeviceCommand alloc] init];
        command.commandName = @"AccountProfileCommand";
        return command;
    } else if(type == CommandTypeUpdateUnits) {
        
    }
    
    return nil;
}


+ (DeviceCommand *)commandFromJson:(NSDictionary *)json {
    NSString *commandName = [json notNSNullObjectForKey:@"_className"];
    if([NSString isBlank:commandName]) return nil;
    
    DeviceCommand *command = nil;
    if([@"FindZKListCommand" isEqualToString:commandName]) {
        command = [[DeviceCommandUpdateUnits alloc] initWithDictionary:json];
    } else if([@"AccountUpdateCommand" isEqualToString:commandName]) {
        command = [[DeviceCommand alloc] initWithDictionary:json];
    } else if([@"AccountProfileCommand" isEqualToString:commandName]) {
        command = [[DeviceCommandUpdateAccount alloc] initWithDictionary:json];
    }
    
    return command;
}

@end
