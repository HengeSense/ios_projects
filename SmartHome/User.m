//
//  User.m
//  SmartHome
//
//  Created by Zhao yang on 11/14/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "User.h"

@implementation User

@synthesize identifier;
@synthesize name;
@synthesize userState;
@synthesize mobile;
@synthesize stringForUserState;

- (id)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self && json) {
        
    }
    return self;
}

- (NSMutableDictionary *)toJson {
    NSMutableDictionary *json = [super toJson];
    
    return json;
}

- (NSString *)stringForUserState {
    if(self.userState == UserStateOnline) {
        return NSLocalizedString(@"online", @"");
    } else if(self.userState == UserStateOffline) {
        return NSLocalizedString(@"offline", @"");
    } else {
        return NSLocalizedString(@"unknow", @"");
    }
}

@end
