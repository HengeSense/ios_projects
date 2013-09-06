//
//  SelectionItem.m
//  SmartHome
//
//  Created by Zhao yang on 9/6/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "SelectionItem.h"

@implementation SelectionItem

@synthesize identifier;
@synthesize title;

- (id)initWithIdentifier:(NSString *)_id_ andTitle:(NSString *)_t_ {
    self = [super init];
    if(self) {
        self.identifier = _id_;
        self.title = _t_;
    }
    return self;
}

@end
