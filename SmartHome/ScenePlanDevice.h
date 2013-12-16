//
//  ScenePlanDevice.h
//  SmartHome
//
//  Created by Zhao yang on 12/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "Entity.h"
#import "ScenePlanZone.h"

@interface ScenePlanDevice : Entity

@property (strong, nonatomic) ScenePlanZone *scenePlanZone;
@property (strong, nonatomic) NSString *deviceIdentifier;
@property (assign, nonatomic) NSInteger status;
@property (strong, nonatomic) NSString *nwkAddr;
@property (strong, nonatomic) NSString *category;

@property (strong, nonatomic) Device *device;

- (id)initWithDevice:(Device *)device;

@end
