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
@synthesize currentUnit;
@synthesize subscriptions;

- (id)init {
    self = [super init];
    if(self) {
        [self initDefaults];
    }
    return self;
}

- (void)initDefaults {
    if(self.units == nil) {
        self.units = [NSMutableArray array];
    }
}

- (void)subscribeHandler:(Class)handler for:(id)obj {
    @synchronized(self.subscriptions) {
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
}

- (NSArray *)getSubscriptionsFor:(Class)handler {
    @synchronized(self.subscriptions) {
        if(handler == nil) return nil;
        return [self.subscriptions objectForKey:[handler description]];
    }
}

- (void)unSubscribeHandler:(Class)handler for:(id)obj {
    @synchronized(self.subscriptions) {
        if(obj == nil || handler == nil) return;
        NSMutableArray *subscriptions_ = [self.subscriptions objectForKey:[handler description]];
        if(subscriptions_ != nil) {
            [subscriptions_ removeObject:obj];
        }
    }
}

- (NSArray *)updateUnits:(NSArray *)newUnits {
    @synchronized(self) {
        
        if(newUnits == nil || newUnits.count == 0) {
            [self.units removeAllObjects];
            return self.units;
        }
        
        if(self.units.count == 0) {
            [self.units addObjectsFromArray:newUnits];
            return self.units;
        }
        
        NSMutableDictionary *updateList = [NSMutableDictionary dictionary];
        NSMutableArray *createList = [NSMutableArray array];
        
        for(int i=0; i<newUnits.count; i++) {
            Unit *newUnit = [newUnits objectAtIndex:i];
            
            BOOL unitFound = NO;
            for(int j=0; j<self.units.count; j++) {
                Unit *oldUnit = [self.units objectAtIndex:j];
                if([oldUnit.identifier isEqualToString:newUnit.identifier]) {
                    unitFound = YES;
                    if(newUnit.updateTime.timeIntervalSince1970 > oldUnit.updateTime.timeIntervalSince1970) {
                        [updateList setObject:newUnit forKey:[NSNumber numberWithInteger:j].stringValue];
                        break;
                    }
                }
            }
            
            if(!unitFound) {
                [createList addObject:newUnit];
            }
        }
        
        if(updateList.count > 0) {
            NSEnumerator *keyEnumerator = updateList.keyEnumerator;
            for(NSString *key in keyEnumerator) {
                NSInteger replaceIndex = [key integerValue];
                [self.units setObject:[updateList objectForKey:key] atIndexedSubscript:replaceIndex];
            }
        }
        
        if(createList.count > 0) {
            for(int i=0; i<createList.count; i++) {
                [self.units addObject:[createList objectAtIndex:i]];
            }
        }
        
        return self.units;
        
    }
}

- (void)clearUnits {
    @synchronized(self) {
        [self.units removeAllObjects];
    }
}

- (Unit *)currentUnit {
    if(self.units.count == 0) return nil;
    return [self.units objectAtIndex:0];
}

- (NSMutableDictionary *)subscriptions {
    if(subscriptions == nil) {
        subscriptions = [NSMutableDictionary dictionary];
    }
    return subscriptions;
}

@end
