//
//  Users.m
//  SmartHome
//
//  Created by Zhao yang on 11/14/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "Users.h"

@implementation Users

@synthesize users;

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

- (User *)userWithId:(NSString *)identifier {
    if(self.users == nil) return nil;
    if([NSString isBlank:identifier]) return nil;
    for(int i=0; i<self.users.count; i++) {
        User *user = [self.users objectAtIndex:i];
        if([identifier isEqualToString:user.identifier]) {
            return user;
        }
    }
    return nil;
}

- (User *)userWithForMobile:(NSString *)mobile {
    if(self.users == nil) return nil;
    if([NSString isBlank:mobile]) return nil;
    for(int i=0; i<self.users.count; i++) {
        User *user = [self.users objectAtIndex:i];
        if([mobile isEqualToString:user.mobile]) {
            return user;
        }
    }
    return nil;
}

@end
