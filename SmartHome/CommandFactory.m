//
//  CommandFactory.m
//  SmartHome
//
//  Created by Zhao yang on 9/3/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "CommandFactory.h"

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
    } else if(type == CommandTypeGetUnits) {
        DeviceCommand *command = [[DeviceCommand alloc] init];
        command.commandName = @"FindZKListCommand";
        return command;
    } else if(type == CommandTypeGetNotifications) {
        DeviceCommand *command = [[DeviceCommand alloc] init];
        command.commandName = @"AccountMQListCommand";
        return command;
    } else if(type == CommandTypeGetSceneList) {
        DeviceCommand *command = [[DeviceCommand alloc] init];
        command.commandName = @"FindDeviceSceneCommand";
        return command;
    } else if(type == CommandTypeUpdateDeviceViaVoice) {
        DeviceCommandVoiceControl *command = [[DeviceCommandVoiceControl alloc] init];
        command.commandName = @"VoiceControlCommand";
        return command;
    } else if(type == CommandTypeUpdateDevice) {
        DeviceCommandUpdateDevice *command = [[DeviceCommandUpdateDevice alloc] init];
        command.commandName = @"KeyControlCommand";
        return command;
    } else if(type == CommandTypeUpdateUnitName) {
        DeviceCommandUpdateUnitName *command = [[DeviceCommandUpdateUnitName alloc] init];
        command.commandName = @"DeviceChangeNameCommand";
        return command;
    } else if(type == CommandTypeGetCameraServer) {
        DeviceCommandGetCameraServer *command = [[DeviceCommandGetCameraServer alloc] init];
        command.commandName = @"RequestCameraCommand";
        return command;
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
    } else if([@"MessageQueueCommand" isEqualToString:commandName] || [@"AccountMQListCommand" isEqualToString:commandName]) {
        command = [[DeviceCommandUpdateNotifications alloc] initWithDictionary:json];
    } else if([@"FindDeviceSceneCommand" isEqualToString:commandName]) {
        command = [[DeviceCommandUpdateSceneMode alloc] initWithDictionary:json];
    } else if([@"VoiceControlCommand" isEqualToString:commandName]) {
        command = [[DeviceCommandVoiceControl alloc] initWithDictionary:json];
    } else if([@"DeviceFingerExcuteCommand" isEqualToString:commandName]) {
        command = [[DeviceCommandUpdateDevices alloc] initWithDictionary:json];
    } else if([@"RequestCameraCommand" isEqualToString:commandName]) {
        command = [[DeviceCommandReceivedCameraServer alloc] initWithDictionary:json];
    }
    
    return command;
}

@end
