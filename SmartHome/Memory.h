//
//  Memory.h
//  SmartHome
//
//  Created by hadoop user account on 30/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Memory : NSObject

@property (strong, nonatomic) NSArray *units;
@property (strong, nonatomic) NSMutableDictionary *subscriptions;

- (void)subscribeHandler:(NSString *)handlerName for:(id)obj;
- (NSArray *)getSubscriptionsFor:(NSString *)handlerName;

@end
