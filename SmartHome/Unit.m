//
//  Unit.m
//  SmartHome
//
//  Created by Zhao yang on 8/30/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "Unit.h"

@implementation Unit

@synthesize identifier;
@synthesize localIP;
@synthesize name;
@synthesize updateTime;
@synthesize zones;


- (id)initWithJson:(NSDictionary *)json {
    self = [super init];
    if(self) {
        if(json != nil) {
            self.identifier = [json notNSNullObjectForKey:@"id"];
            self.localIP = [json notNSNullObjectForKey:@"localip"];
            self.name = [json notNSNullObjectForKey:@"name"];
//            self.updateTime =
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

@end