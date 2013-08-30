//
//  DeviceCommand.h
//  SmartHome
//
//  Created by Zhao yang on 8/19/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+NSNullUtility.h"

@interface DeviceCommand : NSObject

@property (strong, nonatomic) NSString *deviceCode;
@property (strong, nonatomic) NSString *className;
@property (strong, nonatomic) NSString *masterDeviceCode;
@property (strong, nonatomic) NSString *appKey;
@property (strong, nonatomic) NSString *security;
@property (strong, nonatomic) NSString *phoneNumber;
@property (strong, nonatomic) NSDate *commandTime;

- (void)initWithDictionary:(NSDictionary *)json;
- (NSDictionary *)toDictionary;

@end
