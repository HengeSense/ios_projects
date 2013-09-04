//
//  NSDictionary+NSNullUtility.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NSDictionary+NSNullUtility.h"

@implementation NSDictionary (NSNullUtility)

- (id)notNSNullObjectForKey:(id)key {
    id obj = [self objectForKey:key];
    if(obj == [NSNull null]) return nil;
    return obj;
}

- (NSNumber *)numberForKey:(id)key {
    NSNumber *number = [self notNSNullObjectForKey:key];
    if(number != nil) return number;
    return [NSNumber numberWithInt:0];
}

@end
