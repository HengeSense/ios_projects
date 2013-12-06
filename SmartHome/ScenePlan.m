//
//  ScenePlan.m
//  SmartHome
//
//  Created by Zhao yang on 12/3/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ScenePlan.h"
#import "SMShared.h"
#import "ScenePlanZone.h"
#import "ScenePlanDevice.h"

@implementation ScenePlan

@synthesize identifier = _identifier_;
@synthesize name;
@synthesize ownerAccount;
@synthesize unit = _unit_;
@synthesize scenePlanIdentifier;
@synthesize unitIdentifier;
@synthesize lastUpdateTime;
@synthesize securityIdentifier;
@synthesize scenePlanZones = _scenePlanZones_;

- (id)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self) {
        self.identifier = [json stringForKey:@"id"];
        self.ownerAccount = [json noNilStringForKey:@"dc"];
        self.unitIdentifier = [json noNilStringForKey:@"mc"];
        self.scenePlanIdentifier = [json noNilStringForKey:@"si"];
        self.name = [json noNilStringForKey:@"sn"];
        self.securityIdentifier = [json noNilStringForKey:@"sc"];
        
        NSArray *_zones_ = [json arrayForKey:@"ss"];
        if(_zones_ != nil) {
            for(int i=0; i<_zones_.count; i++) {
                NSDictionary *_zone_ = [_zones_ objectAtIndex:i];
                ScenePlanZone *zone = [[ScenePlanZone alloc] initWithJson:_zone_];
                zone.scenePlan = self;
                [self.scenePlanZones addObject:zone];
            }
        }
    }
    return self;
}

- (id)initWithUnit:(Unit *)unit {
    self = [super init];
    if(self && unit != nil) {
        self.unitIdentifier = unit.identifier;
        self.ownerAccount = [SMShared current].settings.deviceCode;
        for(int i=0; i<unit.zones.count; i++) {
            Zone *zone = [unit.zones objectAtIndex:i];
            ScenePlanZone *zonePlan = [[ScenePlanZone alloc] initWithZone:zone];
            zonePlan.scenePlan = self;
            [self.scenePlanZones addObject:zonePlan];
        }
    }
    return self;
}

- (NSMutableDictionary *)toJson {
    NSMutableDictionary *json = [super toJson];
    [json setMayBlankString:self.identifier forKey:@"id"];
    [json setMayBlankString:self.ownerAccount forKey:@"dc"];
    [json setMayBlankString:self.unitIdentifier forKey:@"mc"];
    [json setMayBlankString:self.scenePlanIdentifier forKey:@"si"];
    [json setMayBlankString:self.name forKey:@"sn"];
    [json setMayBlankString:self.securityIdentifier forKey:@"sc"];
    
    NSMutableArray *_zones_ = [NSMutableArray array];
    for(int i=0; i<self.scenePlanZones.count; i++) {
        ScenePlanZone *zone = [self.scenePlanZones objectAtIndex:i];
        [_zones_ addObject:[zone toJson]];
    }
    [json setObject:_zones_ forKey:@"ss"];
    
    return json;
}

- (ScenePlanZone *)zonePlanForIdentifier:(NSString *)identifier {
    if([NSString isBlank:identifier]) return nil;
    for(int i=0; i<self.scenePlanZones.count; i++) {
        ScenePlanZone *planZone = [self.scenePlanZones objectAtIndex:i];
        if([planZone.zoneIdentifier isEqualToString:identifier]) {
            return planZone;
        }
    }
    return nil;
}

- (void)execute {
    DeviceCommandUpdateDevice *command = (DeviceCommandUpdateDevice *)[CommandFactory commandForType:CommandTypeUpdateDevice];
    command.masterDeviceCode = self.unitIdentifier;
    for(int i=0; i<self.scenePlanZones.count; i++) {
        ScenePlanZone *zonePlan = [self.scenePlanZones objectAtIndex:i];
        for(int j=0; j<zonePlan.scenePlanDevices.count; j++) {
            ScenePlanDevice *devicePlan = [zonePlan.scenePlanDevices objectAtIndex:j];
            if(devicePlan.status != -100) {
                if(devicePlan.device.isRemote) {
                    [command addCommandString:[devicePlan.device commandStringForRemote:devicePlan.status]];
                } else {
                    [command addCommandString:[devicePlan.device commandStringForStatus:devicePlan.status]];
                }
            }
        }
    }
    if(![NSString isBlank:self.securityIdentifier]) {
        [command addCommandString:[NSString stringWithFormat:@"scene-%@", self.securityIdentifier]];
    }
    
//    NSData *data = [JsonUtils createJsonDataFromDictionary:[command toDictionary]];
//    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [[SMShared current].deliveryService executeDeviceCommand:command];
}

- (ScenePlanDevice *)devicePlanForIdentifier:(NSString *)identifier {
    if([NSString isBlank:identifier]) return nil;
    for(int i=0; i<self.scenePlanZones.count; i++) {
        ScenePlanZone *planZone = [self.scenePlanZones objectAtIndex:i];
        ScenePlanDevice *devicePlan = [planZone devicePlanForIdentifier:identifier];
        if(devicePlan != nil) {
            return devicePlan;
        }
    }
    return nil;
}

- (NSString *)identifier {
    if([NSString isBlank:_identifier_]) {
        return [NSString stringWithFormat:@"%@%@%@", self.ownerAccount, self.unitIdentifier, self.scenePlanIdentifier];
    }
    return _identifier_;
}

- (Unit *)unit {
    if(_unit_ == nil) {
        _unit_ = [[SMShared current].memory findUnitByIdentifier:self.unitIdentifier];
    }
    return _unit_;
}

- (NSMutableArray *)scenePlanZones {
    if(_scenePlanZones_ == nil) {
        _scenePlanZones_ = [NSMutableArray array];
    }
    return _scenePlanZones_;
}

@end
