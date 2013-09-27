//
//  DevicesPanelView.h
//  SmartHome
//
//  Created by Zhao yang on 9/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Unit.h"
#import "DeviceButton.h"
#import "UIView+Extensions.h"

#define PANEL_WIDTH      210
#define PANEL_HEIGHT     180

@interface DevicesPanelView : UIScrollView

@property (strong, nonatomic) Zone *zone;
@property (strong, nonatomic) UIViewController *ownerViewController;

+ (DevicesPanelView *)devicesPanelViewWithPoint:(CGPoint)point;

- (void)notifyStatusChanged;

@end
