//
//  Zone.h
//  SmartHome
//
//  Created by Zhao yang on 8/30/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+NSNullUtility.h"
#import "Device.h"

@interface Zone : NSObject

// Collections of devices
@property (strong, nonatomic) NSMutableDictionary *accessories;
@property (strong, nonatomic) NSString *name;

- (id)initWithJson:(NSDictionary *)json;

- (NSArray *)devicesAsList;
- (Device *)deviceForId:(NSString *)_id_;

@end
