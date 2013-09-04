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

@property (strong, nonatomic) NSString *category;
@property (assign, nonatomic) NSInteger ep;
@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *ip;
@property (assign, nonatomic) NSInteger irType;
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *nwkAddr;
@property (assign, nonatomic) NSInteger port;
@property (strong, nonatomic) NSString *pwd;
@property (assign, nonatomic) NSInteger resolution;
@property (assign, nonatomic) NSInteger state;
@property (assign, nonatomic) NSInteger status;
@property (assign, nonatomic) NSInteger type;
@property (strong, nonatomic) NSString *user;

- (id)initWithJson:(NSDictionary *)json;

@end
