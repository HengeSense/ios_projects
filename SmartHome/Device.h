//
//  Device.h
//  SmartHome
//
//  Created by Zhao yang on 8/22/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+NSNullUtility.h"

@interface Device : NSObject

@property (strong, nonatomic) NSString *eleState;
@property (strong, nonatomic) NSString *label;
@property (strong, nonatomic) NSString *mac;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSString *type;

- (id)initWithJson:(NSDictionary *)json;

@end
