//
//  ScenePlanZone.m
//  SmartHome
//
//  Created by Zhao yang on 12/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ScenePlanZone.h"
#import "ScenePlanDevice.h"

@implementation ScenePlanZone

@synthesize scenePlan;
@synthesize zoneIdentifier;
@synthesize scenePlanDevices = _scenePlanDevices_;
@synthesize zone = _zone_;


- (id)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self) {
        self.zoneIdentifier = [json noNilStringForKey:@"zc"];
        
        NSArray *_devices_ = [json arrayForKey:@"cs"];
        if(_devices_ != nil) {
            for(int i=0; i<_devices_.count; i++) {
                NSDictionary *_device_ = [_devices_ objectAtIndex:i];
                ScenePlanDevice *device = [[ScenePlanDevice alloc] initWithJson:_device_];
                device.scenePlanZone = self;
                [self.scenePlanDevices addObject:device];
            }
        }
    }
    return self;
}

- (id)initWithZone:(Zone *)zone {
    self = [super init];
    if(self && zone) {
        self.zoneIdentifier = zone.identifier;
        self.zone = zone;
        for(int i=0; i<zone.devices.count; i++) {
            Device *device = [zone.devices objectAtIndex:i];
            ScenePlanDevice *devicePlan = [[ScenePlanDevice alloc] initWithDevice:device];
            devicePlan.scenePlanZone = self;
            [self.scenePlanDevices addObject:devicePlan];
        }
    }
    return self;
}

- (NSMutableDictionary *)toJson {
    NSMutableDictionary *json = [super toJson];
    [json setMayBlankString:self.zoneIdentifier forKey:@"zc"];
    
    NSMutableArray *_devices_ = [NSMutableArray array];
    for(int i=0; i<self.scenePlanDevices.count; i++) {
        ScenePlanDevice *devicePlan = [self.scenePlanDevices objectAtIndex:i];
        [_devices_ addObject:[devicePlan toJson]];
    }
    [json setObject:_devices_ forKey:@"cs"];
    
    return json;
}

- (ScenePlanDevice *)devicePlanForIdentifier:(NSString *)identifier {
    if([NSString isBlank:identifier]) return nil;
    for(int i=0; i<self.scenePlanDevices.count; i++) {
        ScenePlanDevice *devicePlan = [self.scenePlanDevices objectAtIndex:i];
        if([devicePlan.deviceIdentifier isEqualToString:identifier]) {
            return devicePlan;
        }
    }
    return nil;
}

#pragma mark -
#pragma mark ScenePlanZone getter and setter's

- (NSMutableArray *)scenePlanDevices {
    if(_scenePlanDevices_ == nil) {
        _scenePlanDevices_ = [NSMutableArray array];
    }
    return _scenePlanDevices_;
}

- (Zone *)zone {
    if(_zone_ == nil) {
        Unit *unit = self.scenePlan.unit;
        if(unit != nil) {
            _zone_ = [unit zoneForId:self.zoneIdentifier];
        }
    }
    return _zone_;
}

@end
