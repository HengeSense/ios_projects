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
            if(_zones_ != nil && [_zones_ isMemberOfClass:[NSDictionary class]]) {
                NSEnumerator *enumerator = _zones_.objectEnumerator;
                for(NSDictionary *dic in enumerator) {
                    
                }
                
            }
            
//            self.zones
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
