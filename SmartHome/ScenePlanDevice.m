//
//  ScenePlanDevice.m
//  SmartHome
//
//  Created by Zhao yang on 12/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ScenePlanDevice.h"

@implementation ScenePlanDevice

@synthesize scenePlanZone;
@synthesize deviceIdentifier;
@synthesize device = _device_;
@synthesize status;

- (id)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self) {
        self.deviceIdentifier = [json noNilStringForKey:@"cc"];
        self.status = [json integerForKey:@"ss"];
    }
    return self;
}

- (id)initWithDevice:(Device *)device {
    self = [super init];
    if(self && device) {
        self.deviceIdentifier = device.identifier;
        self.device = device;
        self.status = -100;
    }
    return self;
}

- (NSMutableDictionary *)toJson {
    NSMutableDictionary *json = [super toJson];
    [json setInteger:self.status forKey:@"ss"];
    [json setMayBlankString:self.deviceIdentifier forKey:@"cc"];
    return json;
}

#pragma mark -
#pragma mark ScenePlanDevice getter and setter's

- (Device *)device {
    if(_device_ == nil) {
        Zone *zone = self.scenePlanZone.zone;
        if(zone != nil) {
            _device_ = [zone deviceForId:self.deviceIdentifier];
        }
    }
    return _device_;
}

@end
