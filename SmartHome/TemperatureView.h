//
//  TemperatureView.h
//  SmartHome
//
//  Created by Zhao yang on 8/14/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TemperatureView : UIView

@property (assign, nonatomic) NSInteger temperature;

+ (TemperatureView *)createTemperatureView;

@end
