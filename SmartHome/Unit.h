//
//  Unit.h
//  SmartHome
//
//  Created by Zhao yang on 8/30/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+NSNullUtility.h"
#import "Zone.h"

@interface Unit : NSObject

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *localIP;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSDate *updateTime;

// Collections of zones
@property (strong, nonatomic) NSMutableDictionary *zones;

- (id)initWithJson:(NSDictionary *)json;

@end
