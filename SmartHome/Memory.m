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
    if(obj == nil || handler == nil) return;
    NSMutableArray *subscriptions_ = [self.subscriptions objectForKey:[handler description]];
    if(subscriptions_ == nil) {
        subscriptions_ = [NSMutableArray array];
        [subscriptions_ addObject:obj];
        [self.subscriptions setObject:subscriptions_ forKey:[handler description]];
        return;
    }
    BOOL found = NO;
    for(int i=0; i<subscriptions_.count; i++) {
        if(obj == [subscriptions_ objectAtIndex:i]) {
            found = YES;
            break;
        }
    }
    if(!found) {
        [subscriptions_ addObject:obj];
    }
}

- (NSArray *)getSubscriptionsFor:(Class)handler {
    if(handler == nil) return nil;
    return [self.subscriptions objectForKey:[handler description]];
}

- (void)unSubscribeHandler:(Class)handler for:(id)obj {
    if(obj == nil || handler == nil) return;
    NSMutableArray *subscriptions_ = [self.subscriptions objectForKey:[handler description]];
    if(subscriptions_ != nil) {
        [subscriptions_ removeObject:obj];
    }
}

- (NSMutableDictionary *)subscriptions {
    if(subscriptions == nil) {
        subscriptions = [NSMutableDictionary dictionary];
    }
    return subscriptions;
}

@end
