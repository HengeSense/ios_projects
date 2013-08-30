//
//  Zone.m
//  SmartHome
//
//  Created by Zhao yang on 8/30/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "Zone.h"

@implementation Zone

@synthesize accessories;
@synthesize name;

- (id)initWithJson:(NSDictionary *)json {
    self = [super init];
    if(self) {
        if(json != nil) {
            self.name = [json notNSNullObjectForKey:@"name"];
             NSDictionary *_accessories_ = [json notNSNullObjectForKey:@"accessories"];
            if(_accessories_ != nil) {
                NSEnumerator *enumerator = _accessories_.objectEnumerator;
                for(NSDictionary *_accessory_ in enumerator) {
                    Device *device = [[Device alloc] initWithJson:_accessory_];
                    if(device != nil) {
                        
                    }
                }
            }
        }
    }
    return self;
}



- (NSMutableDictionary *)accessories {
    if(accessories == nil) {
        accessories = [NSMutableDictionary dictionary];
    }
    return accessories;
}

@end
