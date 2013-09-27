//
//  ZonesNavigationView.h
//  SmartHome
//
//  Created by Zhao yang on 9/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZonesNavigationView : UIScrollView

+ (ZonesNavigationView *)zonesNavigationViewWithPoint:(CGPoint)point;

- (void)loadOrRefreshWithZones:(NSArray *)zones;
- (void)highLightedWithZoneIdentifier:(NSString *)zoneIdentifier;

@end
