//
//  SMButton.m
//  SmartHome
//
//  Created by Zhao yang on 9/4/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "SMButton.h"

@implementation SMButton {
    NSMutableDictionary *parameters;
}

@synthesize userObject;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefaults];
    }
    return self;
}
    
- (void)initDefaults {
    parameters = [NSMutableDictionary dictionary];
}
    
- (void)setParameter:(id)object forKey:(NSString *)key {
    if(parameters != nil) {
        [parameters setObject:object forKey:key];
    }
}
    
- (id)parameterForKey:(NSString *)key {
    if(parameters == nil) return nil;
    return [parameters objectForKey:key];
}

@end
