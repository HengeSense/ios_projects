//
//  DeviceCommand.h
//  SmartHome
//
//  Created by Zhao yang on 8/19/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+NSNullUtility.h"
#import "SMShared.h"
#import "ServiceBase.h"
#import "JsonUtils.h"

@interface DeviceCommand : NSObject

@property (strong, nonatomic) NSString *result;
@property (strong, nonatomic) NSString *deviceCode;
@property (strong, nonatomic) NSString *commandName;
@property (strong, nonatomic) NSString *masterDeviceCode;
@property (strong, nonatomic, readonly) NSString *appKey;
@property (strong, nonatomic) NSString *security;
@property (strong, nonatomic) NSString *tcpAddress;
@property (strong, nonatomic) NSDate *commandTime;

- (id)initWithDictionary:(NSDictionary *)json;
- (NSMutableDictionary *)toDictionary;

@end
