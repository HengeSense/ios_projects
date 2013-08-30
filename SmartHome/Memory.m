//
//  Memory.m
//  SmartHome
//
//  Created by hadoop user account on 30/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "Memory.h"

@implementation Memory

@synthesize units;
@synthesize subscriptions;


    
- (void)subscribeHandler:(Class)handler for:(id)obj {
//    NSMutableArray *subscriptions_ = [self.subscriptions objectForKey:handlerName];
//    if(subscriptions_ == nil) {
//        subscriptions_ = [NSMutableArray array];
//    }
}


- (NSArray *)getSubscriptionsFor:(Class)handler {
    return nil;
}

- (NSMutableDictionary *)subscriptions {
    if(subscriptions == nil) {
        subscriptions = [NSMutableDictionary dictionary];
    }
    return subscriptions;
}

@end
