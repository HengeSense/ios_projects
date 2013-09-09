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

@implementation SMNotification

@synthesize text;
@synthesize type;
@synthesize mac;
@synthesize createTime;
@synthesize data = _data;

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
        NSArray *_datas_ = [json notNSNullObjectForKey:@"data"];
        if(_datas_ != nil && _datas_.count > 0) {
            for(int i=0; i<_datas_.count; i++) {
                NSDictionary *_data_ = [_datas_ objectAtIndex:i];
                if(_data_ != nil) {
                    [self.data addObject:[[SMNotification alloc] initWithJson:_data_]];
                }
            }
        }
    }
    return self;
}

- (NSMutableArray *)data {
    if(_data == nil) {
        _data = [NSMutableArray array];
    }
    return _data;
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
