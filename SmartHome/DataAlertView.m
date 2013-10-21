//
//  DataAlertView.m
//  SmartHome
//
//  Created by Zhao yang on 10/21/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DataAlertView.h"

@implementation DataAlertView {
    NSMutableDictionary *userInfo;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setParameter:(id)parameter forKey:(NSString *)key {
    if(userInfo == nil) {
        userInfo = [NSMutableDictionary dictionary];
    }
    [userInfo setObject:parameter forKey:key];
}

- (id)parameterForKey:(NSString *)key {
    if(userInfo == nil) return nil;
    return [userInfo objectForKey:key];
}

@end
