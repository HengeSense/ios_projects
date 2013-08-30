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
@property (strong, nonatomic, readonly) NSMutableDictionary *subscriptions;

- (void)subscribeHandler:(Class)handler for:(id)obj;
- (void)unSubscribeHandler:(Class)handler for:(id)obj;
- (NSArray *)getSubscriptionsFor:(Class)handler;

@end
