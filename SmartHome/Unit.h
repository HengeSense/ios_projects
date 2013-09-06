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
@property (assign, nonatomic) NSInteger localPort;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSDate *updateTime;
@property (strong, nonatomic) NSMutableArray *zones;

@property (strong, nonatomic, readonly) NSArray *devices;

- (id)initWithJson:(NSDictionary *)json;
- (Zone *)zoneForId:(NSString *)_id_;

@end
