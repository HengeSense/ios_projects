//
//  TemperatureView.m
//  SmartHome
//
//  Created by Zhao yang on 8/14/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "TemperatureView.h"

@implementation TemperatureView

@synthesize temperature;
@synthesize hasTemperature;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

+ (TemperatureView *)createTemperatureView {
    return nil;
}

- (void)setTemperature:(NSInteger)t {
    temperature = t;
    self.hasTemperature = YES;
}

@end
