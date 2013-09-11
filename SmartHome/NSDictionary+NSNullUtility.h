//
//  NSDictionary+NSNullUtility.h
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (NSNullUtility)

- (id)notNSNullObjectForKey:(id)key;

- (BOOL)boolForKey:(id)key;
- (NSString *)stringForKey:(id)key;
- (NSNumber *)numberForKey:(id)key;
- (NSDate *)dateForKey:(id)key;

@end
