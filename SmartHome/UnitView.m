//
//  UnitView.m
//  SmartHome
//
//  Created by Zhao yang on 9/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "UnitView.h"

@implementation UnitView {
    ZonesView *zonesView;
    ZonesNavigationView *zonesNavigationView;
    
    NSString *lastedSelectionZoneIdentifier;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefaults];
        [self initUI];
    }
    return self;
}

+ (UnitView *)unitViewWithPoint:(CGPoint)point {
    return [[UnitView alloc] initWithFrame:CGRectMake(point.x, point.y, 320, PANEL_HEIGHT)];
}

+ (UnitView *)unitViewWithPoint:(CGPoint)point ownerViewController:(UIViewController *)owner {
    UnitView *unitView = [self unitViewWithPoint:point];
    unitView.ownerViewController = owner;
    return unitView;
}

- (void)initDefaults {
    lastedSelectionZoneIdentifier = [NSString emptyString];
}

- (void)initUI {
    if(zonesView == nil) {
        zonesView = [ZonesView zonesViewWithPoint:CGPointMake(0, 0)];
        [self addSubview:zonesView];
    }
    
    if(zonesNavigationView == nil) {
        zonesNavigationView = [ZonesNavigationView zonesNavigationViewWithPoint:CGPointMake(220, 0)];
        [self addSubview:zonesNavigationView];
    }
}

- (void)loadOrRefreshUnit:(Unit *)unit {
    /*    */
    zonesView.ownerViewController = self.ownerViewController;
//    BOOL changed;
    [zonesView loadOrRefreshUnit:unit];
    
    /*    */
    [zonesNavigationView loadOrRefreshWithZones:unit.zones];
    
    BOOL found = NO;
    for(Zone *zone in unit.zones) {
        if([lastedSelectionZoneIdentifier isEqualToString:zone.identifier]) {
            found = YES;
            break;
        }
    }
    
    if(!found) {
        if(unit != nil && unit.zones != nil && unit.zones.count > 0) {
            Zone *zone = [unit.zones objectAtIndex:0];
            lastedSelectionZoneIdentifier = zone.identifier;
        }
    }
    
//    if(changed) {
        [self notifyCurrentSelectionZoneChanged:lastedSelectionZoneIdentifier];
//    }
    
    [self notifyZonesNavigationChanged:lastedSelectionZoneIdentifier];
}

- (void)notifyCurrentSelectionZoneChanged:(NSString *)zoneIdentifier {
    lastedSelectionZoneIdentifier = zoneIdentifier;
    [zonesView moveWithZoneIdentifier:zoneIdentifier];
}

- (void)notifyZonesNavigationChanged:(NSString *)zoneIdentifier {
    lastedSelectionZoneIdentifier = zoneIdentifier;
    [zonesNavigationView highLightedWithZoneIdentifier:zoneIdentifier];
}

- (void)notifyStatusChanged {
    for(UIView *view in self.subviews) {
        if([view isKindOfClass:[ZonesView class]]) {
            ZonesView *zv = (ZonesView *)view;
            [zv notifyStatusChanged];
        }
    }
}

@end
