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
                NSEnumerator *enumerator = _accessories_.keyEnumerator;
                for(NSString *key in enumerator) {
                    NSDictionary *_device_ = [_accessories_ objectForKey:key];
                    if(_device_ != nil) {
                        [self.accessories setObject:[[Device alloc] initWithJson:_device_] forKey:key];
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
