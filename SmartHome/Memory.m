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


- (id)init {
    self = [super init];
    if(self) {
        [self initDefaults];
    }
    return self;
}

- (void)initDefaults {
    if(self.subscriptions == nil) {
        subscriptions = [NSMutableDictionary dictionary];
    }
    if(self.units == nil) {
        self.units = [NSMutableArray array];
    }
}

- (void)subscribeHandler:(Class)handler for:(id)obj {
    if(obj == nil || handler == nil) return;
    NSMutableArray *subscriptions_ = [self.subscriptions objectForKey:[handler description]];
    if(subscriptions_ == nil) {
        NSLog(@"--> %@", [handler description]);
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
    NSArray *arr = [self.subscriptions objectForKey:[handler description]];
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
    if(updateUnits == nil || updateUnits.count == 0) return self.units;
    if(self.units.count == 0) {
        [self.units addObjectsFromArray:updateUnits];
        return self.units;
    }
    
    for(int i=0; i<self.units.count; i++) {
        Unit *unit = [self.units objectAtIndex:i];
        for(int j=0; j<updateUnits.count; j++) {
            Unit *_unit_ = [updateUnits objectAtIndex:j];
            if([unit.identifier isEqualToString:_unit_.identifier]) {
               if(_unit_.updateTime.timeIntervalSince1970 > unit.updateTime.timeIntervalSince1970) {
                
                   break;
               }
            }
        }
    }
        
    return self.units;
}

@end
