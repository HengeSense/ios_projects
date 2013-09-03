//
//  Unit.m
//  SmartHome
//
//  Created by Zhao yang on 8/30/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "Unit.h"
@interface Unit()
@property (unsafe_unretained) NSUInteger myHash;
@end
@implementation Unit

@synthesize identifier;
@synthesize localIP;
@synthesize name;
@synthesize updateTime;
@synthesize zones;

- (id)initWithJson:(NSDictionary *)json {
    self = [super init];
    if(self) {
        _myHash = (NSUInteger) self;
        if(json != nil) {
            self.identifier = [json notNSNullObjectForKey:@"id"];
            self.localIP = [json notNSNullObjectForKey:@"localip"];
            self.name = [json notNSNullObjectForKey:@"name"];
            NSNumber *_updateTime_ = [json notNSNullObjectForKey:@"updateTime"];
            if(_updateTime_ != nil) {
                self.updateTime = [NSDate dateWithTimeIntervalSince1970:_updateTime_.longLongValue];
            }
            NSDictionary *_zones_ = [json notNSNullObjectForKey:@"zones"];
            NSEnumerator *enumerator = _zones_.keyEnumerator;
            for(NSString *key in enumerator) {
                NSDictionary *_zone_ = [_zones_ objectForKey:key];
                if(_zone_ != nil) {
                    [self.zones setObject:[[Zone alloc] initWithJson:_zone_] forKey:key];
                }
            }
        }
    }
    return self;
}

- (NSMutableDictionary *)zones {
    if(zones == nil) {
        zones = [NSMutableDictionary dictionary];
    }
    return zones;
}

- (Zone *)zoneForId:(NSString *)_id_ {
    return [self.zones objectForKey:_id_];
}

- (NSArray *)zonesAsList {
    NSEnumerator *enumerator = self.zones.keyEnumerator;
    NSMutableArray *zoneList = [NSMutableArray array];
    for(NSString *key in enumerator) {
        [zoneList addObject:[self.zones objectForKey:key]];
    }
    return zoneList;
}
-(BOOL) isEqual:(Unit *)object{
    return [self.identifier isEqual:object.identifier];
}
-(NSUInteger) hash{
    return self.myHash;
}
@end
