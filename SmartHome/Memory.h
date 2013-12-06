//
//  Memory.h
//  SmartHome
//
//  Created by hadoop user account on 30/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Unit.h"
#import "DeviceStatus.h"

@protocol UnitManagerDelegate <NSObject>

- (void)unitManagerNotifyCurrentUnitWasChanged:(NSString *)unitIdentifier;

@end

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
 *  Update the new units to memory
 */
- (NSArray *)replaceUnits:(NSArray *)newUnits;

/*
 *  Update unit devices status for a unit
 */
- (void)updateUnitDevices:(NSArray *)devicesStatus forUnit:(NSString *)identifier;

/*
 *  find a unit by unit identifier (code)
 */
- (Unit *)findUnitByIdentifier:(NSString *)identifier;

/*
 *  remove a unit by identifier
 */
- (void)removeUnitByIdentifier:(NSString *)identifier;

/*
 *  change the current unit vai unit identifier (code)
 */
- (void)changeCurrentUnitTo:(NSString *)unitIdentifier;

/*
 *  set scene list for a unit
 */
- (void)updateSceneList:(NSString *)unitIdentifier sceneList:(NSArray *)sceneList hashCode:(NSNumber *)hashCode;

/*
 *  get all units identifier to a array
 */
- (NSArray *)allUnitsIdentifierAsArray;

/*
 *  clear all units from memory
 */
- (void)clearUnits;

/* 
 *  load units from disk file
 */
- (void)loadUnitsFromDisk;

/*
 *
 */
- (NSArray *)updateUnit:(Unit *)unit;


/*
 *
 */
- (BOOL)hasUnit;


/*
 * clear both subscriptions and units
 */
- (void)clear;


/*
 *  sync memory units to disk file
 */
- (void)syncUnitsToDisk;


@end
