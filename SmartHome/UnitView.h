//
//  UnitView.h
//  SmartHome
//
//  Created by Zhao yang on 9/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZonesView.h"
#import "ZonesNavigationView.h"

@interface UnitView : UIView

@property (strong, nonatomic) UIViewController *ownerViewController;

+ (UnitView *)unitViewWithPoint:(CGPoint)point;
+ (UnitView *)unitViewWithPoint:(CGPoint)point ownerViewController:(UIViewController *)owner;

- (void)loadOrRefreshUnit:(Unit *)unit;

- (void)notifyCurrentSelectionZoneChanged:(NSString *)zoneIdentifier;
- (void)notifyZonesNavigationChanged:(NSString *)zoneIdentifier;

- (void)notifyStatusChanged;

@end
