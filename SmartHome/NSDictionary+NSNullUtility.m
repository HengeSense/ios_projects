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

- (NSDate *)dateForKey:(id)key {
    NSNumber *_date_ = [self notNSNullObjectForKey:key];
    if(_date_ == nil) return nil;
    return [NSDate dateWithTimeIntervalSince1970:_date_.longLongValue];
}

@end
