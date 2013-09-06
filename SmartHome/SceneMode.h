//
//  SceneMode.h
//  SmartHome
//
//  Created by Zhao yang on 9/6/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommand.h"

@interface SceneMode : NSObject

@property (assign, nonatomic) NSInteger code;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *masterDeviceCode;

- (id)initWithJson:(NSDictionary *)json;

@end
