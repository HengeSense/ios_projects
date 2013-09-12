//
//  DeviceCommandVoiceControl.m
//  SmartHome
//
//  Created by Zhao yang on 9/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceCommandVoiceControl.h"

@implementation DeviceCommandVoiceControl

@synthesize voiceText;

- (id)initWithDictionary:(NSDictionary *)json {
    self = [super initWithDictionary:json];
    if(self && json) {
        self.voiceText = [json stringForKey:@"voiceText"];
    }
    return self;
}

- (NSMutableDictionary *)toDictionary {
    NSMutableDictionary *json = [super toDictionary];
    [json setMayBlankString:self.voiceText forKey:@"voiceText"];
    return json;
}

@end
