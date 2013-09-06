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
@synthesize scenesModeList;

- (id)initWithJson:(NSDictionary *)json {
    self = [super init];
    if(self) {
        if(json != nil) {
            self.identifier = [json notNSNullObjectForKey:@"_id"];
            self.localIP = [json notNSNullObjectForKey:@"localIp"];
            self.name = [json notNSNullObjectForKey:@"name"];
            self.localPort = [json numberForKey:@"localPort"].integerValue;
            self.status = [json notNSNullObjectForKey:@"status"];
            
            NSNumber *_updateTime_ = [json notNSNullObjectForKey:@"updateTime"];
            if(_updateTime_ != nil) {
                self.updateTime = [NSDate dateWithTimeIntervalSince1970:_updateTime_.longLongValue];
            }
            
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
//-(void) encodeWithCoder:(NSCoder *) encoder{
//    [encoder encodeObject:self.identifier forKey:@"indentifier"];
//    [encoder encodeObject:[NSNumber numberWithInteger:self.localPort ] forKey:@"localPort"];
//    [encoder encodeObject:self.localIP forKey:@"localIP"];
//    [encoder encodeObject:self.name forKey:@"name"];
//    [encoder encodeObject:self.status forKey:@"status"];
//    [encoder encodeObject:self.updateTime forKey:@"updateTime"];
//    [encoder encodeObject:self.zones forKey:@"zones"];
//    [encoder encodeObject:self.devices forKey:@"device"];
//    [encoder encodeObject:self.scenesModeList forKey:@"scenesModeList"];
//    
//}
//-(id) initWithCoder:(NSCoder *) decoder{
//    return  nil;
//}
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
