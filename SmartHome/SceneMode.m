//
//  SceneMode.m
//  SmartHome
//
//  Created by Zhao yang on 9/6/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "SceneMode.h"

@implementation SceneMode

@synthesize masterDeviceCode;
@synthesize code;
@synthesize name;

- (id)initWithJson:(NSDictionary *)json {
    self = [super init];
    if(self && json) {
        self.name = [json stringForKey:@"name"];
        self.code = [json integerForKey:@"code"];
    }
    return self;
}

@end
