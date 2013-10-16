//
//  ZonesView.m
//  SmartHome
//
//  Created by Zhao yang on 9/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ZonesView.h"
#import "UnitView.h"
#import "NSString+StringUtils.h"

@implementation ZonesView

@synthesize unit = _unit_;
@synthesize ownerViewController;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefaults];
        [self initUI];
    }
    return self;
}

- (void)initDefaults {   
}

- (void)initUI {
    self.pagingEnabled = YES;
    self.delegate = self;
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    
}

+ (ZonesView *)zonesViewWithPoint:(CGPoint)point {
    return [[ZonesView alloc] initWithFrame:CGRectMake(point.x, point.y, PANEL_WIDTH, PANEL_HEIGHT)];
}

- (void)loadOrRefreshUnit:(Unit *)unit changed:(BOOL *)anyZoneChanged {
    BOOL changed = [self anyZonesChangedBetween:_unit_ newUnit:unit];
    _unit_ = unit;
    if(changed) {
        [self loadWithZones:_unit_ == nil ? nil : _unit_.zones];
    } else {
        [self refreshWithZones:_unit_ == nil ? nil : _unit_.zones];
    }
    *anyZoneChanged = changed;
}

- (void)refreshWithZones:(NSArray *)zones {
    for(UIView *view in self.subviews) {
        if([view isKindOfClass:[DevicesPanelView class]]) {
            DevicesPanelView *panelView = (DevicesPanelView *)view;
            for(Zone *zone in zones) {
                if([panelView.zone.identifier isEqualToString:zone.identifier]) {
                    panelView.zone = zone;
                    break;
                }
            }
        }
    }
}

- (void)loadWithZones:(NSArray *)zones {
    [self clearSubviews];
    
    int totalPages = (zones == nil) ? 0 : zones.count;
    self.contentSize = CGSizeMake(PANEL_WIDTH * totalPages, PANEL_HEIGHT);
    
    if(zones == nil) return;
    
    for(int i=0; i<zones.count; i++) {
        DevicesPanelView *devicesPanel = [DevicesPanelView devicesPanelViewWithPoint:CGPointMake(i * PANEL_WIDTH, 0)];
        devicesPanel.ownerViewController = self.ownerViewController;
        devicesPanel.zone = [zones objectAtIndex:i];
        [self addSubview:devicesPanel];
    }
}

- (BOOL)anyZonesChangedBetween:(Unit *)oldUnit newUnit:(Unit *)newUnit {
    if(oldUnit == nil && newUnit == nil) return NO;
    if((oldUnit == nil && newUnit != nil) || (oldUnit != nil && newUnit == nil)) return YES;
    if(![oldUnit.identifier isEqualToString:newUnit.identifier]) return YES;
    if((oldUnit.zones == nil && newUnit.zones != nil) || (oldUnit.zones != nil && newUnit.zones == nil)) return YES;
    if(oldUnit.zones.count != newUnit.zones.count) return YES;

    BOOL changed = NO;
    for(Unit *n in newUnit.zones) {
        BOOL found = NO;
        for(Unit *o in oldUnit.zones) {
            if([n.identifier isEqualToString:o.identifier]) {
                found = YES;
                break;
            }
        }
        if(!found) {
            changed = YES;
            break;
        }
    }
    
    return changed;
}

- (void)notifyStatusChanged {
    for(UIView *view in self.subviews) {
        if([view isKindOfClass:[DevicesPanelView class]]) {
            DevicesPanelView *panelView = (DevicesPanelView *)view;
            [panelView notifyStatusChanged];
        }
    }
}

- (void)moveWithZoneIdentifier:(NSString *)zoneIdentifier {
    if([NSString isBlank:zoneIdentifier]) return;
    for(UIView *view in self.subviews) {
        if([view isKindOfClass:[DevicesPanelView class]]) {
            DevicesPanelView *panel = (DevicesPanelView *)view;
            if(panel.zone != nil && [panel.zone.identifier isEqualToString:zoneIdentifier]) {
                self.contentOffset = CGPointMake(panel.frame.origin.x, 0) ;
                return;
            }
        }
    }
}

#pragma mark -
#pragma makr Scroll view delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if(!decelerate) {
        [self checkDevicesPanelViewChanged];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self checkDevicesPanelViewChanged];
}

- (void)checkDevicesPanelViewChanged {
    int pageIndex = self.contentOffset.x / PANEL_WIDTH;
    for(UIView *view in self.subviews) {
        if([view isKindOfClass:[DevicesPanelView class]]) {
            DevicesPanelView *panel = (DevicesPanelView *)view;
            if(panel.frame.origin.x == pageIndex * PANEL_WIDTH) {
                UnitView *unitView = (UnitView *)self.superview;
                if(unitView != nil) {
                    [unitView notifyZonesNavigationChanged:panel.zone.identifier];
                }
                return;
            }
        }
    }
}

@end
