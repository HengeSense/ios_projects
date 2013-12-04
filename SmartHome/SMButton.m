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

@synthesize identifier;
@synthesize userObject;
@synthesize longPressDelegate = _longPressDelegate_;

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

#pragma mark -
#pragma mark Extension for parameters
    
- (void)setParameter:(id)object forKey:(NSString *)key {
    if(parameters != nil) {
        [parameters setObject:object forKey:key];
    }
}
    
- (id)parameterForKey:(NSString *)key {
    if(parameters == nil) return nil;
    return [parameters objectForKey:key];
}

#pragma mark -
#pragma mark Extenstions for long press

- (void)setLongPressDelegate:(id<LongPressDelegate>)longPressDelegate {
    for(UIGestureRecognizer *gesture in self.gestureRecognizers) {
        if([gesture isKindOfClass:[UILongPressGestureRecognizer class]]) {
            [gesture removeTarget:self action:@selector(longPressed:)];
        }
    }
    _longPressDelegate_ = longPressDelegate;
    if(_longPressDelegate_ != nil) {
        UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressed:)];
        [self addGestureRecognizer:longPressGesture];
    }
}

- (void)longPressed:(UILongPressGestureRecognizer *)gesture {
    if(self.longPressDelegate != nil && gesture.state == UIGestureRecognizerStateBegan) {
        [self.longPressDelegate smButtonLongPressed:self];
    }
}

@end
