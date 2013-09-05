//
//  DeviceButton.h
//  SmartHome
//
//  Created by Zhao yang on 8/21/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Device.h"

@interface DeviceButton : UIView

@property (strong, nonatomic) Device *device;
@property (strong, nonatomic) UIViewController *ownerController;


- (id)initWithFrame:(CGRect)frame andDevice:(Device *)device;
- (void)initDefaults;
- (void)initUI;

+ (DeviceButton *)buttonWithDevice:(Device *)device point:(CGPoint)point owner:(UIViewController *)owner;

// 
- (void)refresh;

@end
