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
        command.commandName = COMMAND_UPDATE_ACCOUNT;
        return command;
    } else if(type == CommandTypeGetAccount) {
        DeviceCommand *command = [[DeviceCommand alloc] init];
        command.commandName = COMMAND_GET_ACCOUNT;
        return command;
    } else if(type == CommandTypeGetUnits) {
        DeviceCommandGetUnit *command = [[DeviceCommandGetUnit alloc] init];
        command.commandName = COMMAND_GET_UNITS;
        return command;
    } else if(type == CommandTypeGetNotifications) {
        DeviceCommand *command = [[DeviceCommand alloc] init];
        command.commandName = COMMAND_GET_NOTIFICATIONS;
        return command;
    } else if(type == CommandTypeGetSceneList) {
        DeviceCommand *command = [[DeviceCommand alloc] init];
        command.commandName = COMMAND_GET_SCENE_LIST;
        return command;
    } else if(type == CommandTypeUpdateDeviceViaVoice) {
        DeviceCommandVoiceControl *command = [[DeviceCommandVoiceControl alloc] init];
        command.commandName = COMMAND_VOICE_CONTROL;
        return command;
    } else if(type == CommandTypeUpdateDevice) {
        DeviceCommandUpdateDevice *command = [[DeviceCommandUpdateDevice alloc] init];
        command.commandName = COMMAND_KEY_CONTROL;
        return command;
    } else if(type == CommandTypeUpdateUnitName) {
        DeviceCommandUpdateUnitName *command = [[DeviceCommandUpdateUnitName alloc] init];
        command.commandName = COMMAND_CHANGE_UNIT_NAME;
        return command;
    } else if(type == CommandTypeGetCameraServer) {
        DeviceCommandGetCameraServer *command = [[DeviceCommandGetCameraServer alloc] init];
        command.commandName = COMMAND_GET_CAMERA_SERVER;
        return command;
    } else if(type == CommandTypeBindingUnit) {
        DeviceCommandBindingUnit *command = [[DeviceCommandBindingUnit alloc] init];
        command.commandName = COMMAND_BING_UNIT;
        return command;
    }
    
    return nil;
}


+ (DeviceCommand *)commandFromJson:(NSDictionary *)json {
    NSString *commandName = [json notNSNullObjectForKey:@"_className"];
    if([NSString isBlank:commandName]) return nil;
    
    DeviceCommand *command = nil;
    if([COMMAND_GET_UNITS isEqualToString:commandName]) {
        command = [[DeviceCommandUpdateUnits alloc] initWithDictionary:json];
    } else if([COMMAND_UPDATE_ACCOUNT isEqualToString:commandName]) {
        command = [[DeviceCommand alloc] initWithDictionary:json];
    } else if([COMMAND_GET_ACCOUNT isEqualToString:commandName]) {
        command = [[DeviceCommandUpdateAccount alloc] initWithDictionary:json];
    } else if([COMMAND_PUSH_NOTIFICATIONS isEqualToString:commandName] || [COMMAND_GET_NOTIFICATIONS isEqualToString:commandName]) {
        command = [[DeviceCommandUpdateNotifications alloc] initWithDictionary:json];
    } else if([COMMAND_GET_SCENE_LIST isEqualToString:commandName]) {
        command = [[DeviceCommandUpdateSceneMode alloc] initWithDictionary:json];
    } else if([COMMAND_VOICE_CONTROL isEqualToString:commandName]) {
        command = [[DeviceCommandVoiceControl alloc] initWithDictionary:json];
    } else if([COMMAND_PUSH_DEVICE_STATUS isEqualToString:commandName]) {
        command = [[DeviceCommandUpdateDevices alloc] initWithDictionary:json];
    } else if([COMMAND_GET_CAMERA_SERVER isEqualToString:commandName]) {
        command = [[DeviceCommandReceivedCameraServer alloc] initWithDictionary:json];
    } else if([COMMAND_CHANGE_UNIT_NAME isEqualToString:commandName]) {
        
    }
    
    return command;
}

@end
