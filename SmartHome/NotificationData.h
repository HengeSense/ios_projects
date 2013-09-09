//
//  NotificationData.h
//  SmartHome
//
//  Created by Zhao yang on 9/9/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationData : NSObject

@property (strong, nonatomic) NSString *masterDeviceCode;
@property (strong, nonatomic) NSString *requestDeviceCode;
@property (strong, nonatomic) NSString *dataCommandName;

- (id)initWithJson:(NSDictionary *)json;
- (NSDictionary *)toJson;

@end
