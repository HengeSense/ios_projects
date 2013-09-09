//
//  Message.m
//  SmartHome
//
//  Created by hadoop user account on 6/09/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "Message.h"

@implementation Message
@synthesize text;
@synthesize messageState;
@synthesize messageType;
@synthesize createTime;
@synthesize data;

-(id) init{
    self = [super init];
    if (self) {
        self.messageState = MessageStateUnread;
        self.messageType = MessageTypeNormal;
    }
    return self;
}
@end
