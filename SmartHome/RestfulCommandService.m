//
//  RestfulCommandService.m
//  SmartHome
//
//  Created by Zhao yang on 9/2/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "RestfulCommandService.h"
#import "NSString+StringUtils.h"
#import "SMShared.h"

@implementation RestfulCommandService

- (id)init {
    self = [super init];
    if(self) {
        [super setupWithUrl:[NSString emptyString]];
        self.client.timeoutInterval = 3;
    }
    return self;
}

- (void)executeCommand:(DeviceCommand *)command {
    
    Unit *unit = [[SMShared current].memory findUnitByIdentifier:command.masterDeviceCode];
    if(unit != nil) {
        command.restAddress = unit.localIP;
        command.restPort = unit.localPort;
    }
    
    if([COMMAND_GET_UNITS isEqualToString:command.commandName]) {
        DeviceCommandGetUnit *getUnitCommand = (DeviceCommandGetUnit *)command;
        if([NSString isBlank:getUnitCommand.unitServerUrl]) {
            [self getUnitByIdentifier:getUnitCommand.masterDeviceCode address:getUnitCommand.restAddress port:getUnitCommand.restPort hashCode:getUnitCommand.hashCode];
        } else {
            [self getUnitByUrl:getUnitCommand.unitServerUrl];
        }
    } else if([COMMAND_KEY_CONTROL isEqualToString:command.commandName]) {
        DeviceCommandUpdateDevice *updateDevice = (DeviceCommandUpdateDevice *)command;
        NSData *data = [JsonUtils createJsonDataFromDictionary:[updateDevice toDictionary]];
        [self updateDeviceWithAddress:updateDevice.restAddress port:updateDevice.restPort data:data];
    } else if([COMMAND_GET_SCENE_LIST isEqualToString:command.commandName]) {
        
    }
}

- (NSString *)executorName {
    return @"RESTFUL SERVICE";
}

#pragma mark -
#pragma mark Update devices from rest server

- (void)updateDeviceWithAddress:(NSString *)address port:(NSInteger)port data:(NSData *)data {
    NSString *url = [NSString stringWithFormat:@"http://%@:%d/executor", address, port];
    [self.client postForUrl:url acceptType:@"application/json" contentType:@"application/json" body:data success:@selector(updateDeviceSuccess:) error:@selector(updateDeviceFailed:) for:self callback:nil];
}

- (void)updateDeviceSuccess:(RestResponse *)resp {
    if(resp.statusCode == 200) {
        DeviceCommand *command = [CommandFactory commandFromJson:[JsonUtils createDictionaryFromJson:resp.body]];
        [[SMShared current].deliveryService handleDeviceCommand:command];
        return;
    }
    
    [self updateDeviceFailed:resp];
}

- (void)updateDeviceFailed:(RestResponse *)resp {
    NSLog(@"Update device from rest failed, status code is %d", resp.statusCode);
}

#pragma mark -
#pragma mark Get units from rest server

- (void)getUnitByIdentifier:(NSString *)unitIdentifier address:(NSString *)addr port:(NSInteger)port hashCode:(NSNumber *)hashCode {
        NSString *url = [NSString stringWithFormat:@"http://%@:%d/gatewaycfg?hashCode=%d", addr, port, hashCode.integerValue];
        [self getUnitByUrl:url];
}

- (void)getUnitByUrl:(NSString *)url {
    [self.client getForUrl:url acceptType:@"application/json" success:@selector(getUnitSucess:) error:@selector(getUnitFailed:) for:self callback:nil];
}

- (void)getUnitSucess:(RestResponse *)resp {
    if(resp.statusCode == 200) {
        NSDictionary *json = [JsonUtils createDictionaryFromJson:resp.body];        
        if(json != nil) {
            Unit *unit = [[Unit alloc] initWithJson:json];
            if(unit != nil) {
                DeviceCommandUpdateUnits *updateUnit = [[DeviceCommandUpdateUnits alloc] init];
                updateUnit.commandName = COMMAND_GET_UNITS;
                updateUnit.masterDeviceCode = unit.identifier;
                [updateUnit.units addObject:unit];
                [[SMShared current].deliveryService handleDeviceCommand:updateUnit];
            }
        }
        return;
    } else if(resp.statusCode == 204) {
        // ignore this ... do not need to refresh local unit
        return;
    }
    [self getUnitFailed:resp];
}

- (void)getUnitFailed:(RestResponse *)resp {
    NSLog(@"Get units from rest failed, staus code is %d", resp.statusCode);
}

#pragma mark -
#pragma mark Scene list from rest server






#pragma mark -
#pragma mark Key control from rest server


@end
