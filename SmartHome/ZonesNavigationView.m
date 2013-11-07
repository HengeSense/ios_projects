//
//  ZonesNavigationView.m
//  SmartHome
//
//  Created by Zhao yang on 9/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ZonesNavigationView.h"
#import "DevicesPanelView.h"
#import "UnitView.h"
#import "SMButton.h"

@implementation ZonesNavigationView

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
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
}

+ (ZonesNavigationView *)zonesNavigationViewWithPoint:(CGPoint)point {
    return [[ZonesNavigationView alloc] initWithFrame:CGRectMake(point.x, point.y, 80, PANEL_HEIGHT)];
}

- (void)loadOrRefreshWithZones:(NSArray *)zones {
    [self clearSubviews];
    
    int totalElements = zones == nil ? 0 : zones.count;
//    int totalPage = (totalElements + 5 - (totalElements % 5)) / 5;
    
    CGFloat height = (totalElements <= 5 ? PANEL_HEIGHT : (36 * totalElements));
    self.contentSize = CGSizeMake(80, height);
    
    if(zones == nil) return;
    
    for(int i=0; i<zones.count; i++) {
        CGFloat y = ((i + 5 - (i % 5)) / 5 - 1) * PANEL_HEIGHT + (i % 5) * 36;
        Zone *zone = [zones objectAtIndex:i];
        SMButton *btnZone = [[SMButton alloc] initWithFrame:CGRectMake(0, y, 80, 28)];
        btnZone.userObject = zone.identifier;
        [self setButtonSelected:btnZone isSelected:NO];
        [btnZone setTitle:zone.name forState:UIControlStateNormal];
        [btnZone addTarget:self action:@selector(btnZonePressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btnZone];
    }
}

- (void)btnZonePressed:(SMButton *)sender {
    if(sender == nil) return;
    NSString *identifier = sender.userObject;
    UnitView *unitView = (UnitView *)self.superview;
    if(unitView != nil) {
        [self highLightedWithZoneIdentifier:identifier];
        [unitView notifyCurrentSelectionZoneChanged:identifier];
    }
}

- (void)setButtonSelected:(SMButton *)button isSelected:(BOOL)isSelected {
    if(button == nil) return;
    if(isSelected) {
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:18.f];
    } else {
        [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.f];
    }
}

- (void)highLightedWithZoneIdentifier:(NSString *)zoneIdentifier {
    if([NSString isBlank:zoneIdentifier]) return;
    for(UIView *view in self.subviews) {
        if([view isKindOfClass:[SMButton class]]) {
            SMButton *btn = (SMButton *)view;
            if([btn.userObject isEqualToString:zoneIdentifier]) {
                if(btn.frame.origin.y < self.contentOffset.y) {
                    self.contentOffset = CGPointMake(self.contentOffset.x, btn.frame.origin.y);
                }
                if(btn.frame.origin.y >= (self.contentOffset.y + PANEL_HEIGHT)) {
                    
                    self.contentOffset = CGPointMake(self.contentOffset.x, btn.frame.origin.y - (PANEL_HEIGHT / 5) * 4);
                }
                [self setButtonSelected:btn isSelected:YES];
            } else {
                [self setButtonSelected:btn isSelected:NO];
            }
        }
    }
}

@end
