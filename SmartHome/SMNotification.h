//
//  SMNotification.h
//  SmartHome
//
//  Created by Zhao yang on 9/9/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SMNotification : NSObject

@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *mac;
@property (strong, nonatomic) NSDate *createTime;
@property (strong, nonatomic) NSMutableArray *data;

- (id)initWithJson:(NSDictionary *)json;

@end
