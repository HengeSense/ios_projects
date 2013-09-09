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

@implementation SMNotification

@synthesize text;
@synthesize type;
@synthesize mac;
@synthesize createTime;
@synthesize data = _data;

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

@end
