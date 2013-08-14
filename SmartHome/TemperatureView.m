//
//  TemperatureView.m
//  SmartHome
//
//  Created by Zhao yang on 8/14/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "TemperatureView.h"
#import "ImageFactory.h"

@implementation TemperatureView {
    UIImageView *firstNumberView;
    UIImageView *secondNumberView;
    UIImageView *temperatureSymbolView;
}

@synthesize temperature;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initUI {
    if(firstNumberView == nil) {
        firstNumberView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self addSubview:firstNumberView];
    }
    
    if(secondNumberView == nil) {
        secondNumberView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self addSubview:secondNumberView];
    }
    
    if(temperatureSymbolView == nil) {
        temperatureSymbolView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [self addSubview:temperatureSymbolView];
    }
}

+ (TemperatureView *)createTemperatureView {
    TemperatureView *temperatureView = [[TemperatureView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    return temperatureView;
}

- (void)setTemperature:(NSInteger)t {
    temperature = t;
    if(t < -9 || t > 99) {
        // empty
        return;
    }
    if(t < 0) {
        //first number is - 'abs(t)'
        return;
    }
    
    if(t >= 0 && t <= 9) {
        //first number is zero 0t
        return;
    }
    
    if(t > 9) {
        //减去第一位乘以10
        return;
    }
//    [[ImageFactory sharedImageFactory] imageForNumber:t];
    /*
     firstNumberView.image = [UIImage imageNamed:@""];
     secondNumberView.image = [UIImage imageNamed:@""];
     temperatureSymbolView.image = [UIImage imageNamed:@""];
     */
    
}

@end
