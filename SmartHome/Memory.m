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


    
- (void)subscribeHandler:(Class)handler for:(id)obj {
    NSMutableArray *subscriptions_ = [self.subscriptions objectForKey:handler];
    if(subscriptions_ == nil) {
        subscriptions_ = [NSMutableArray array];
    }
    [subscriptions_ addObject:obj];
    [self.subscriptions setObject:subscriptions_ forKey:(id)handler];
}

-(void) setUnits:(NSArray *)units{
    if(units == nil){
        units = [NSArray new];
    }
    _units = units;
}
- (NSArray *)getSubscriptionsFor:(Class)handler {
    NSArray *subscriptions_ = [self.subscriptions objectForKey:handler];
    if (subscriptions_ == nil) {
        subscriptions_ = [NSArray new];
    }
    return subscriptions_;
}

- (NSMutableDictionary *)subscriptions {
    if(subscriptions == nil) {
        subscriptions = [NSMutableDictionary dictionary];
    }
    return subscriptions;
}

-(void) unSubscribeHandler:(Class)handler for:(id)obj{
    NSMutableArray *handlerArr = [self.subscriptions objectForKey:handler];
    [handlerArr removeObject:obj];
    [self.subscriptions setObject:handlerArr forKey:obj];
}

- (NSArray *) replaceWithUnits:(NSArray *) updateUnits{
    NSArray *memoryUnits = self.units;
    NSArray *receiveUnits = updateUnits;
    __block NSMutableArray *newUnits = [NSMutableArray arrayWithArray:memoryUnits];
    [receiveUnits enumerateObjectsUsingBlock:^(Unit *obj, NSUInteger idx, BOOL *stop) {
        Unit *receiveUnit = obj;
        [memoryUnits enumerateObjectsUsingBlock:^(Unit *obj, NSUInteger idx, BOOL *stop) {
            if(obj.identifier == receiveUnit.identifier&&obj.updateTime.timeIntervalSince1970<receiveUnit.updateTime.timeIntervalSince1970){
                [newUnits setObject:receiveUnit atIndexedSubscript:idx];
            }
        }];
        
    }];
    
    return newUnits;

}
@end
