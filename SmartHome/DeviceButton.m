//
//  DeviceButton.m
//  SmartHome
//
//  Created by Zhao yang on 8/21/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceButton.h"
#import "NSString+StringUtils.h"
#import "PageableScrollView.h"
#import "PageableNavView.h"
#import "AirConditionViewController.h"
#import "TVViewController.h"
#import "CameraViewController.h"

@implementation DeviceButton {
    UIButton *btn;
    UILabel *lblTitle;
    NSMutableDictionary *statusImage;
}

@synthesize device = _device_;
@synthesize ownerController;

#pragma mark -
#pragma mark initializations

- (id)initWithFrame:(CGRect)frame andDevice:(Device *)device
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefaults];
        [self initUI];
        self.device = device;
    }
    return self;
}

- (void)initDefaults {
    if(statusImage == nil) {
        statusImage = [NSMutableDictionary dictionary];
    }
}

- (void)initUI {
    if(btn == nil) {
        btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        btn.center = CGPointMake(self.bounds.size.width / 2, btn.center.y);
        [btn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    
    if(lblTitle == nil) {
        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 31, 70, 21)];
        lblTitle.center = CGPointMake(self.bounds.size.width / 2, lblTitle.center.y);
        lblTitle.font = [UIFont systemFontOfSize:13.f];
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.textColor = [UIColor lightTextColor];
        lblTitle.backgroundColor = [UIColor clearColor];
        [self addSubview:lblTitle];
    }
}

+ (DeviceButton *)buttonWithDevice:(Device *)device point:(CGPoint)point owner:(UIViewController *)owner {
    DeviceButton *btnDevice = [[DeviceButton alloc] initWithFrame:CGRectMake(point.x, point.y, 70, 52) andDevice:device];
    btnDevice.ownerController = owner;
    return btnDevice;
}

#pragma mark -
#pragma mark services

- (void)registerImage:(UIImage *)img forStatus:(NSString *)s {
    if(statusImage == nil) return;
    [statusImage setObject:img forKey:s];
}

- (void)refresh {
    if(lblTitle != nil) {
        if(self.device && ![NSString isBlank:self.device.name]) {
            lblTitle.text = self.device.name;
        } else {
            lblTitle.text = [NSString emptyString];
        }
    }
    if(self.device != nil && statusImage != nil && btn != nil) {
        UIImage *image = [statusImage objectForKey:[NSNumber numberWithInteger:self.device.status].stringValue];
        if(image != nil) {
            [btn setBackgroundImage:image forState:UIControlStateNormal];
            [btn setBackgroundImage:image forState:UIControlStateHighlighted];
        }
    }
}

- (void)initializeStatusImages {
    [statusImage removeAllObjects];
    if(_device_ != nil) {
        if(_device_.isLightOrInlight) {
            
        } else if(_device_.isCurtainOrSccurtain) {
            
        } else if(_device_.isTV) {
           [self registerImage:[UIImage imageNamed:@"icon_tv_on.png"] forStatus:[NSNumber numberWithInteger:1].stringValue];
            [self registerImage:[UIImage imageNamed:@"icon_tv_off.png"] forStatus:[NSNumber numberWithInteger:0].stringValue];
        } else if(_device_.isSTB) {
        
        } else if(_device_.isAircondition) {
           [self registerImage:[UIImage imageNamed:@"icon_aircondition_on.png"] forStatus:[NSNumber numberWithInteger:1].stringValue];
            [self registerImage:[UIImage imageNamed:@"icon_aircondition_off.png"] forStatus:[NSNumber numberWithInteger:0].stringValue];
        } else if(_device_.isSocket) {
            [self registerImage:[UIImage imageNamed:@"icon_device_off.png"] forStatus:[NSNumber numberWithInteger:0].stringValue];
            [self registerImage:[UIImage imageNamed:@"icon_device_on.png"] forStatus:[NSNumber numberWithInteger:1].stringValue];
        } else if(_device_.isCamera) {
            [self registerImage:[UIImage imageNamed:@"icon_camera_off.png"] forStatus:[NSNumber numberWithInteger:0].stringValue];
            [self registerImage:[UIImage imageNamed:@"icon_camera_on.png"] forStatus:[NSNumber numberWithInteger:1].stringValue];
        }
    }
}

- (void)setDevice:(Device *)device {
    _device_ = device;
    [self initializeStatusImages];
    [self refresh];
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents {
    if(btn != nil) {
        [btn addTarget:target action:action forControlEvents:controlEvents];
    }
}

#pragma mark -
#pragma mark event

- (void)btnPressed:(id)sender {
    if(self.device == nil) return;
    
    if(_device_.isLightOrInlight) {
        
    } else if(_device_.isCurtainOrSccurtain) {
        
    } else if(_device_.isTV || _device_.isSTB) {
        TVViewController *tvViewController = [[TVViewController alloc] init];
        tvViewController.title = _device_.name;
        tvViewController.delegate = [self findContainerView];
        [self.ownerController presentModalViewController:tvViewController animated:YES];
    } else if(_device_.isAircondition) {
        AirConditionViewController *airConditionViewController = [[AirConditionViewController alloc] init];
        airConditionViewController.title = _device_.name;
        airConditionViewController.delegate = [self findContainerView];
        [self.ownerController presentModalViewController:airConditionViewController animated:YES];
    } else if(_device_.isSocket) {
        
    } else if(_device_.isCamera) {
        CameraViewController *cameraViewController = [[CameraViewController alloc] init];
        cameraViewController.title = _device_.name;
        cameraViewController.delegate = [self findContainerView];
        [self.ownerController presentModalViewController:cameraViewController animated:YES];
    }
}

- (PageableScrollView *)findContainerView {
    UIView *view = self.superview.superview.superview;
    if(view != nil && [view isMemberOfClass:[PageableScrollView class]]) {
        PageableScrollView *p_view = (PageableScrollView *)view;
        return p_view;
    }
    return nil;
}

@end
