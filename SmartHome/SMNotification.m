//
//  SMNotification.m
//  SmartHome
//
//  Created by Zhao yang on 9/9/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "SMNotification.h"
#import "NSDictionary+NSNullUtility.h"
#import "NotificationData.h"
#import "NSString+StringUtils.h"

#import "SMDateFormatter.h"

@implementation SMNotification

@synthesize text;
@synthesize type;
@synthesize mac;
@synthesize createTime;
@synthesize data = _data;
@synthesize hasRead;
@synthesize hasProcess;
@synthesize identifier;

@synthesize isInfo;
@synthesize isValidation;
@synthesize isMessage;
@synthesize isWarning;
@synthesize isInfoOrMessage;

- (id)initWithJson:(NSDictionary *)json {
    self = [super init];
    if(self) {
        self.text = [json notNSNullObjectForKey:@"text"];
        self.mac = [json notNSNullObjectForKey:@"mac"];
        self.type = [json notNSNullObjectForKey:@"type"];
        self.createTime = [json dateForKey:@"createTime"];
        self.identifier = [json notNSNullObjectForKey:@"id"];
        self.hasRead = [json boolForKey:@"hasRead"];
        self.hasProcess = [json boolForKey:@"hasProcess"];
        NSDictionary *_data_ = [json notNSNullObjectForKey:@"data"];
        if(_data_ != nil) {
            self.data = [[NotificationData alloc] initWithJson:_data_];
        }
    }
    return self;
}

- (NSDictionary *)toJson {
    NSMutableDictionary *json = [NSMutableDictionary dictionary];
    [json setObject:([NSString isBlank:self.text] ? [NSString emptyString] : self.text) forKey:@"text"];
    [json setObject:([NSString isBlank:self.mac] ? [NSString emptyString] : self.mac) forKey:@"mac"];
    [json setObject:([NSString isBlank:self.type] ? [NSString emptyString] : self.type) forKey:@"type"];
    [json setObject:([NSString isBlank:self.identifier] ? [NSString emptyString] : self.identifier) forKey:@"id"];
    [json setObject:(self.hasProcess ? @"yes" : @"no") forKey:@"hasProcess"];
    [json setObject:(self.hasRead ? @"yes" : @"no") forKey:@"hasRead"];
    if(self.createTime != nil) {
        [json setObject:[NSNumber numberWithLongLong:self.createTime.timeIntervalSince1970] forKey:@"createTime"];
    }
    if(self.data != nil) {
        [json setObject:[self.data toJson] forKey:@"data"];
    }
    
    return json;
}

- (BOOL)isWarning {
    if([NSString isBlank:self.type]) return NO;
    return  [@"AL" isEqualToString:self.type];
}

- (BOOL)isValidation {
    if([NSString isBlank:self.type]) return NO;
    return  [@"CF" isEqualToString:self.type];
}

- (BOOL)isInfo {
    if([NSString isBlank:self.type]) return NO;
    return  [@"AT" isEqualToString:self.type];
}

- (BOOL)isMessage {
    if([NSString isBlank:self.type]) return NO;
    return  [@"MS" isEqualToString:self.type];
}

- (BOOL)isInfoOrMessage {
    return self.isMessage || self.isInfo;
}

@end
