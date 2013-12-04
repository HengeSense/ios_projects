//
//  ScenePlan.h
//  SmartHome
//
//  Created by Zhao yang on 12/3/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "Entity.h"
#import "Unit.h"
#import "SMShared.h"


#pragma mark -
#pragma mark Scene Plan

@class ScenePlanZone;
@class ScenePlanDevice;

@interface ScenePlan : Entity

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *scenePlanIdentifier;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *ownerAccount;
@property (strong, nonatomic) NSString *unitIdentifier;
@property (strong, nonatomic) NSDate *lastUpdateTime;
@property (strong, nonatomic) NSMutableArray *scenePlanZones;
@property (strong, nonatomic) NSString *securityIdentifier;

@property (strong, nonatomic) Unit *unit;

- (id)initWithUnit:(Unit *)unit;

- (ScenePlanZone *)zonePlanForIdentifier:(NSString *)identifier;
- (ScenePlanDevice *)devicePlanForIdentifier:(NSString *)identifier;

@end





#pragma mark -
#pragma mark Scene Plan Device






