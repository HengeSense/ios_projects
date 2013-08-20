//
//  CommunicationMessage.h
//  SmartHome
//
//  Created by Zhao yang on 8/19/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceCommand.h"
#import "NSString+StringUtils.h"
#import "BitUtils.h"
#import "JsonUtils.h"

@interface CommunicationMessage : NSObject

@property (strong, nonatomic) DeviceCommand *deviceCommand;

- (NSData *)generateData;

@end
