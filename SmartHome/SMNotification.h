//
//  SMNotification.h
//  SmartHome
//
//  Created by Zhao yang on 9/9/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotificationData.h"

@interface SMNotification : NSObject

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *mac;
@property (strong, nonatomic) NSDate *createTime;
@property (strong, nonatomic) NotificationData *data;

@property (assign, nonatomic, readonly) BOOL isInfo;
@property (assign, nonatomic, readonly) BOOL isWarning;
@property (assign, nonatomic, readonly) BOOL isValidation;
@property (assign, nonatomic, readonly) BOOL isMessage;
@property (assign, nonatomic, readonly) BOOL isInfoOrMessage;

- (id)initWithJson:(NSDictionary *)json;

@end
