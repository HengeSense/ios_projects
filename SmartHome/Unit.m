//
//  Unit.m
//  SmartHome
//
//  Created by Zhao yang on 8/30/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "Unit.h"
#import "NSString+StringUtils.h"

@interface Unit()

@end

@implementation Unit

@synthesize identifier;
@synthesize localPort;
@synthesize localIP;
@synthesize name;
@synthesize status;
@synthesize updateTime;
@synthesize zones;
@synthesize devices;
@synthesize hashCode;

@synthesize sceneHashCode;
@synthesize scenesModeList = _scenesModeList_;

- (id)initWithJson:(NSDictionary *)json {
    self = [super init];
    if(self) {
        if(json != nil) {
            self.identifier = [json notNSNullObjectForKey:@"_id"];
            if(self.identifier != nil) {
                self.identifier = [self.identifier substringToIndex:self.identifier.length-4];
            }
            self.localIP = [json notNSNullObjectForKey:@"localIp"];
            self.name = [json notNSNullObjectForKey:@"name"];
            self.localPort = [json numberForKey:@"localPort"].integerValue;
            self.status = [json notNSNullObjectForKey:@"status"];
            self.hashCode = [json numberForKey:@"hashCode"];
            self.updateTime = [json dateForKey:@"updateTime"];
            self.sceneHashCode = [json numberForKey:@"sceneHashCode"];
            
            NSArray *_zones_ = [json notNSNullObjectForKey:@"zones"];
            for(int i=0; i<_zones_.count; i++) {
                NSDictionary *_zone_ = [_zones_ objectAtIndex:i];
                Zone *zone = [[Zone alloc] initWithJson:_zone_];
                [self.zones addObject:zone];
            }
        }
    }
    return self;
}

- (NSDictionary *)toJson {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:([NSString isBlank:self.identifier] ? [NSString emptyString] : [NSString stringWithFormat:@"%@A001", self.identifier]) forKey:@"_id"];
    [json setObject:([NSString isBlank:self.localIP] ? [NSString emptyString] : self.localIP) forKey:@"localIp"];
    [json setObject:([NSString isBlank:self.name] ? [NSString emptyString] : self.name) forKey:@"name"];
    [json setObject:[NSNumber numberWithInteger:self.localPort] forKey:@"localPort"];
    [json setObject:([NSString isBlank:self.status] ? [NSString emptyString] : self.status) forKey:@"status"];
    [json setObject:(self.updateTime == nil ? [NSNumber numberWithInteger:0] : [NSNumber numberWithLongLong:self.updateTime.timeIntervalSince1970]) forKey:@"updateTime"];
    [json setObject:(self.hashCode == nil ? [NSNumber numberWithInteger:0] : self.hashCode) forKey:@"hashCode"];
    [json setObject:(self.sceneHashCode == nil ? [NSNumber numberWithInteger:0] : self.sceneHashCode) forKey:@"sceneHashCode"];
    
    // zones ...
    NSMutableArray *_zones_ = [NSMutableArray array];
    for(int i=0; i<self.zones.count; i++) {
        Zone *zone = [self.zones objectAtIndex:i];
        [_zones_ addObject:[zone toJson]];
    }
    [json setObject:_zones_ forKey:@"zones"];
    
    
    // sceneUpdateTime
    
    // scenesModeList
    
    return json;
}

- (NSMutableArray *)zones {
    if(zones == nil) {
        zones = [NSMutableArray array];
    }
    return zones;
}

- (Zone *)zoneForId:(NSString *)_id_ {
    if([NSString isBlank:_id_]) return nil;
    for(int i=0; i<self.zones.count; i++) {
        Zone *zone = [self.zones objectAtIndex:i];
        if([_id_ isEqualToString:zone.identifier]) {
            return zone;
        }
    }
    return nil;
}

- (NSMutableArray *)scenesModeList {
    if(_scenesModeList_ == nil) {
        _scenesModeList_ = [NSMutableArray array];
    }
    return _scenesModeList_;
}

- (NSArray *)devices {
    NSMutableArray *_devices_ = [NSMutableArray array];
    if(self.zones.count != 0) {
        for(int i=0; i<self.zones.count; i++) {
            Zone *zone = [self.zones objectAtIndex:i];
            if(zone.devices != nil && zone.devices.count > 0) {
                [_devices_ addObjectsFromArray:zone.devices];
            }
        }
    }
    return _devices_;
}

@end
