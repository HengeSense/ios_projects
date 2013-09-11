//
//  NSDictionary+NSNullUtility.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NSDictionary+NSNullUtility.h"
#import "NSDate+Extension.h"

@implementation NSDictionary (NSNullUtility)

- (id)notNSNullObjectForKey:(id)key {
    id obj = [self objectForKey:key];
    if(obj == [NSNull null]) return nil;
    return obj;
}

- (NSString *)stringForKey:(id)key {
    NSString *str = [self notNSNullObjectForKey:key];
    if(str != nil) {
        return str;
    }
    return nil;
}

- (BOOL)boolForKey:(id)key {
    NSString *_bool_ = [self notNSNullObjectForKey:key];
    if(_bool_ != nil) {
        return [@"yes" isEqualToString:_bool_];
    }
    return NO;
}

- (NSNumber *)numberForKey:(id)key {
    NSNumber *number = [self notNSNullObjectForKey:key];
    if(number != nil) return number;
    return [NSNumber numberWithInt:0];
}

- (NSDate *)dateForKey:(id)key {
    NSNumber *_date_ = [self notNSNullObjectForKey:key];
    if(_date_ == nil) return nil;
    return [NSDate dateWithTimeIntervalMillisecondSince1970:_date_.longLongValue];
}

@end
