//
//  Memory.m
//  SmartHome
//
//  Created by hadoop user account on 30/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "Memory.h" 

@implementation Memory

@synthesize units = _units;
@synthesize subscriptions;

- (id)init {
    self = [super init];
    if(self) {
        [self initDefaults];
    }
    return self;
}

- (void)initDefaults {
    subscriptions = [NSMutableDictionary dictionary];
}

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

- (NSArray *)replaceWithUnits:(NSArray *)updateUnits {
    [updateUnits enumerateObjectsUsingBlock:^(Unit *obj, NSUInteger idx, BOOL *stop) {
        Unit *receiveUnit = obj;
        [self.units enumerateObjectsUsingBlock:^(Unit *obj, NSUInteger idx, BOOL *stop) {
            if(obj.identifier == receiveUnit.identifier && obj.updateTime.timeIntervalSince1970 < receiveUnit.updateTime.timeIntervalSince1970){
                [self.units setObject:receiveUnit atIndexedSubscript:idx];
            }
        }];
        
    }];
    return self.units;
}

@end
