//
//  User.m
//  SmartHome
//
//  Created by Zhao yang on 11/14/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "User.h"
#import "SMShared.h"

@implementation User

@synthesize identifier;
@synthesize name;
@synthesize isOwner;
@synthesize userState;
@synthesize mobile;
@synthesize stringForUserState;

- (id)initWithJson:(NSDictionary *)json {
    self = [super initWithJson:json];
    if(self && json) {
        self.identifier = [json noNilStringForKey:@"id"];
        self.name = [json noNilStringForKey:@"screenName"];
        self.mobile = [json noNilStringForKey:@"phoneNumber"];
        self.isOwner = [json boolForKey:@"owner"];
        
        NSString *_status = [json noNilStringForKey:@"status"];
        if([NSString isBlank:_status]) {
            self.userState = UserStateUnknow;
        } else if([@"在线" isEqualToString:_status]) {
            self.userState = UserStateOnline;
        } else if([@"下线" isEqualToString:_status]) {
            self.userState = UserStateOffline;
        } else {
            self.userState = UserStateUnknow;
        }
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

- (BOOL)isCurrentUser {
    if([NSString isBlank:self.identifier]) {
        return NO;
    }
    return [self.identifier isEqualToString:[SMShared current].settings.deviceCode];
}

@end
