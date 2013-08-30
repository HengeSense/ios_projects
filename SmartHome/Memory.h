//
//  Memory.h
//  SmartHome
//
//  Created by hadoop user account on 30/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Unit.h"
@interface Memory : NSObject

@property (strong, nonatomic) NSArray *units;


@property (strong, nonatomic) NSMutableDictionary *subscriptions;

- (void)subscribeHandler:(Class)handler for:(id)obj;
- (NSArray *)getSubscriptionsFor:(Class)handler;
- (NSArray *) replaceWithUnits:(NSArray *) units;
- (void) unSubscribeHandler:(Class) handler for:(id) obj;
@end
