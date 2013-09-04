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

@property (strong, nonatomic) NSMutableArray *devices;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *identifier;

- (id)initWithJson:(NSDictionary *)json;

- (Device *)deviceForId:(NSString *)_id_;

@end
