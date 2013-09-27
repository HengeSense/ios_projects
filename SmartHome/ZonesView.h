//
//  ZonesView.h
//  SmartHome
//
//  Created by Zhao yang on 9/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DevicesPanelView.h"

@interface ZonesView : UIScrollView<UIScrollViewDelegate>

@property (strong, nonatomic) Unit *unit;
@property (strong, nonatomic) UIViewController *ownerViewController;

+ (ZonesView *)zonesViewWithPoint:(CGPoint)point;

- (void)moveWithZoneIdentifier:(NSString *)zoneIdentifier;

- (void)notifyStatusChanged;

@end
