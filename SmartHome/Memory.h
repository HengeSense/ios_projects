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

@property (strong, atomic) NSMutableArray *units;
@property (strong, atomic, readonly) Unit *currentUnit;
@property (strong, nonatomic, readonly) NSMutableDictionary *subscriptions;

/*
 *
 */
- (void)subscribeHandler:(Class)handler for:(id)obj;

/*
 *
 */
- (void)unSubscribeHandler:(Class)handler for:(id)obj;

/*
 *
 */
- (NSArray *)getSubscriptionsFor:(Class)handler;

/*
 *
 */
- (NSArray *)updateUnits:(NSArray *)newUnits;


- (void)changeCurrentUnitTo:(NSString *)unitIdentifier;


- (void)updateSceneList:(NSString *)unitIdentifier sceneList:(NSArray *)sceneList hashCode:(NSNumber *)hashCode;

- (void)clearUnits;

@end
