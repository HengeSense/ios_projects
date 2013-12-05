//
//  SceneMode.h
//  SmartHome
//
//  Created by Zhao yang on 9/6/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommand.h"
#import "Entity.h"

@interface SceneMode : Entity

@property (assign, nonatomic) NSInteger code;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *masterDeviceCode;
@property (strong, nonatomic) NSString *type;

@property (assign, nonatomic, readonly) BOOL isSecurityMode;

@end
