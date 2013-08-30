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
