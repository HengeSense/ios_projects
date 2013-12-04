//
//  ScenePlanZone.h
//  SmartHome
//
//  Created by Zhao yang on 12/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "Entity.h"
#import "Unit.h"
#import "ScenePlan.h"

#pragma mark -
#pragma mark Scene Plan Zone

@class ScenePlanDevice;

@interface ScenePlanZone : Entity

@property (strong, nonatomic) ScenePlan *scenePlan;
@property (strong, nonatomic) NSString *zoneIdentifier;
@property (strong, nonatomic) NSMutableArray *scenePlanDevices;

@property (strong, nonatomic) Zone *zone;

- (id)initWithZone:(Zone *)zone;

- (ScenePlanDevice *)devicePlanForIdentifier:(NSString *)identifier;

@end


