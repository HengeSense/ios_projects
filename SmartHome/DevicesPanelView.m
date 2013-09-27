//
//  DevicesPanelView.m
//  SmartHome
//
//  Created by Zhao yang on 9/26/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DevicesPanelView.h"
#import "UnitView.h"
#import "DeviceButton.h"

#define DEVICE_WIDTH     70
#define DEVICE_HEIGHT    52
#define DEVICE_MARGIN_Y  12

@implementation DevicesPanelView

@synthesize zone = _zone_;
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

+ (DevicesPanelView *)devicesPanelViewWithPoint:(CGPoint)point {
    return [[DevicesPanelView alloc] initWithFrame:CGRectMake(point.x, point.y, PANEL_WIDTH, PANEL_HEIGHT)];
}

- (void)initDefaults {
}

- (void)initUI {
    self.pagingEnabled = YES;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
}

- (void)setZone:(Zone *)zone {
    _zone_ = zone;
    [self loadWithDevices:_zone_ == nil ? nil : _zone_.devices];
}

- (void)loadWithDevices:(NSArray *)devices {
    [self clearSubviews];
    
    int totalPages = [self calcTotalPagesWithElementsCount:((devices == nil) ? 0 : devices.count)];
    self.contentSize = CGSizeMake(PANEL_WIDTH, totalPages * PANEL_HEIGHT);
    
    if(devices == nil) return;
    
    for(int i=0; i<devices.count; i++) {
        int xIndex = i % 3;
        CGFloat x = xIndex * DEVICE_WIDTH;
        
        int yIndex = (i % 3 == 0) ? i / 3 : (i - i % 3) / 3;
        CGFloat y = (yIndex / 3) * PANEL_HEIGHT + (yIndex % 3) * (DEVICE_HEIGHT + DEVICE_MARGIN_Y);
        
        Device *device = [devices objectAtIndex:i];
        DeviceButton *btnDevice = [DeviceButton buttonWithDevice:device point:CGPointMake(x, y) owner:self.ownerViewController];
        
        [self addSubview:btnDevice];
    }
}

- (void)notifyStatusChanged {
    for(UIView *view in self.subviews) {
        if([view isKindOfClass:[DeviceButton class]]) {
            DeviceButton *btn = (DeviceButton *)view;
            [btn refresh];
        }
    }
}

- (NSInteger)calcTotalPagesWithElementsCount:(NSInteger)elementsCount {
    int totalPages = 0;
    if(elementsCount <= 9) totalPages = 1;
    int remainder = elementsCount % 9;
    if(remainder == 0) {
        totalPages = elementsCount / 9;
    } else {
        totalPages = (elementsCount - remainder) / 9 + 1;
    }
    return totalPages;
}

@end
