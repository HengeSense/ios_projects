//
//  CameraAdjustViewController.h
//  SmartHome
//
//  Created by hadoop user account on 21/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NavViewController.h"
#import "DirectionButton.h"
@interface CameraAdjustViewController : NavViewController<DirectionButtonDelegate>
@property (strong,nonatomic) DirectionButton *directionButton;
@end
