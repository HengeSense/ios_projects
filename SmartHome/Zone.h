//
//  Zone.h
//  SmartHome
//
//  Created by Zhao yang on 8/30/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Zone : NSObject

// Collections of devices
@property (strong, nonatomic) NSDictionary *accessories;
@property (strong, nonatomic) NSString *name;

@end
