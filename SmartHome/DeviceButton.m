//
//  DeviceButton.m
//  SmartHome
//
//  Created by Zhao yang on 8/21/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceButton.h"
#import "NSString+StringUtils.h"
#import "AirConditionViewController.h"
#import "TVViewController.h"
#import "CameraViewController.h"
#import "BackgroundMusicViewController.h"
#import "CommandFactory.h"
#import "DeviceUtils.h"

#define ON  0
#define OFF 1

#define OPEN  1
#define CLOSE 3
#define STOP  2

#define TWO_TIMES_CLICK_INTERVAL 500

@implementation DeviceButton {
    UIButton *btn;
    UILabel *lblTitle;
    NSMutableDictionary *statusImage;
    
    double lastClickedTime;
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
    
    lastClickedTime = -1;
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
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] init];
    [tapGesture addTarget:self action:@selector(btnPressed:)];
    [self addGestureRecognizer:tapGesture];
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
            lblTitle.text = NSLocalizedString(@"no_name", @"");
        }
    }
    if(self.device != nil) {
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
            [self registerImage:[UIImage imageNamed:@"icon_light_on.png"] forStatus:[NSNumber numberWithInteger:ON].stringValue];
            [self registerImage:[UIImage imageNamed:@"icon_light_off.png"] forStatus:[NSNumber numberWithInteger:OFF].stringValue];
        } else if(_device_.isCurtainOrSccurtain) {
            [self registerImage:[UIImage imageNamed:@"icon_curtain_on.png"] forStatus:[NSNumber numberWithInteger:OPEN].stringValue];
            [self registerImage:[UIImage imageNamed:@"icon_curtain_on.png"] forStatus:[NSNumber numberWithInteger:CLOSE].stringValue];
            [self registerImage:[UIImage imageNamed:@"icon_curtain_on.png"] forStatus:[NSNumber numberWithInteger:STOP].stringValue];
        } else if(_device_.isTV) {
            [self registerImage:[UIImage imageNamed:@"icon_tv_on.png"] forStatus:[NSNumber numberWithInteger:ON].stringValue];
            [self registerImage:[UIImage imageNamed:@"icon_tv_off.png"] forStatus:[NSNumber numberWithInteger:OFF].stringValue];
        } else if(_device_.isSTB) {
            [self registerImage:[UIImage imageNamed:@"icon_stb_on.png"] forStatus:[NSNumber numberWithInteger:ON].stringValue];
            [self registerImage:[UIImage imageNamed:@"icon_stb_off.png"] forStatus:[NSNumber numberWithInteger:OFF].stringValue];
        } else if(_device_.isAircondition) {
            [self registerImage:[UIImage imageNamed:@"icon_aircondition_on.png"] forStatus:[NSNumber numberWithInteger:ON].stringValue];
            [self registerImage:[UIImage imageNamed:@"icon_aircondition_off.png"] forStatus:[NSNumber numberWithInteger:OFF].stringValue];
        } else if(_device_.isSocket) {
            [self registerImage:[UIImage imageNamed:@"icon_device_on.png"] forStatus:[NSNumber numberWithInteger:ON].stringValue];
            [self registerImage:[UIImage imageNamed:@"icon_device_off.png"] forStatus:[NSNumber numberWithInteger:OFF].stringValue];
        } else if(_device_.isCamera) {
            [self registerImage:[UIImage imageNamed:@"icon_camera_on.png"] forStatus:[NSNumber numberWithInteger:ON].stringValue];
            [self registerImage:[UIImage imageNamed:@"icon_camera_off.png"] forStatus:[NSNumber numberWithInteger:OFF].stringValue];
        } else if(_device_.isWarsignal) {
            [self registerImage:[UIImage imageNamed:@"icon_security_on.png"] forStatus:[NSNumber numberWithInteger:ON].stringValue];
            [self registerImage:[UIImage imageNamed:@"icon_security_off.png"] forStatus:[NSNumber numberWithInteger:OFF].stringValue];
        } else if(_device_.isBackgroundMusic) {
            [self registerImage:[UIImage imageNamed:@"background_music_on.png"] forStatus:[NSNumber numberWithInteger:ON].stringValue];
            [self registerImage:[UIImage imageNamed:@"background_music_off.png"] forStatus:[NSNumber numberWithInteger:OFF].stringValue];
        } else if(_device_.isDVD) {
            
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
    
    if(!(_device_.isTV || _device_.isAircondition || _device_.isSTB)) {
        if(![DeviceUtils checkDeviceIsAvailable:_device_]) return;
    }
    
    // Check btn click is too often
    double now = [NSDate date].timeIntervalSince1970 * 1000;
    if(lastClickedTime != -1) {
        if(now - lastClickedTime <= TWO_TIMES_CLICK_INTERVAL) {
            lastClickedTime = now;
            return;
        }
    }
    lastClickedTime = now;

    if(_device_.isLightOrInlight || _device_.isSocket || _device_.isWarsignal) {
        DeviceCommandUpdateDevice *updateDeviceCommand = (DeviceCommandUpdateDevice *)[CommandFactory commandForType:CommandTypeUpdateDevice];
        updateDeviceCommand.masterDeviceCode = self.device.zone.unit.identifier;
        [updateDeviceCommand addCommandString:[self.device commandStringForStatus: self.device.status == 0 ? 1 : 0]];
        [[SMShared current].deliveryService executeDeviceCommand:updateDeviceCommand
         ];
    } else if(_device_.isCurtainOrSccurtain) {
        NSString *status = [NSString emptyString];
        if(_device_.status == OPEN) {
            status = @"open";
        } else if(_device_.status == CLOSE) {
            status = @"close";
        } else if(_device_.status == STOP) {
            status = @"stop";
        }
        NSArray *items = [NSArray arrayWithObjects:
         [[SelectionItem alloc] initWithIdentifier:@"open" andTitle:NSLocalizedString(@"curtain_start", @"")],
         [[SelectionItem alloc] initWithIdentifier:@"close" andTitle:NSLocalizedString(@"curtain_close", @"")],
         [[SelectionItem alloc] initWithIdentifier:@"stop" andTitle:NSLocalizedString(@"curtain_stop", @"")], nil];
        [SelectionView showWithItems:items selectedIdentifier:nil source:@"curtain" delegate:self];
    } else if(_device_.isTV || _device_.isSTB) {
        TVViewController *tvViewController = [[TVViewController alloc] initWithDevice:_device_];
        tvViewController.title = _device_.name;
        [self.ownerController presentViewController:tvViewController animated:YES completion:nil];
    } else if(_device_.isAircondition) {
        AirConditionViewController *airConditionViewController = [[AirConditionViewController alloc] initWithDevice:_device_];
        airConditionViewController.title = _device_.name;
        [self.ownerController presentViewController:airConditionViewController animated:YES completion:nil];
    } else if(_device_.isCamera) {
        CameraViewController *cameraViewController = [[CameraViewController alloc] init];
        cameraViewController.title = _device_.name;
        cameraViewController.cameraDevice = _device_;
        [self.ownerController presentViewController:cameraViewController animated:YES completion:nil];
    } else if(_device_.isBackgroundMusic) {
        BackgroundMusicViewController *backgroundMusicViewController = [[BackgroundMusicViewController alloc] initWithDevice:_device_];
        backgroundMusicViewController.title = _device_.name;
        [self.ownerController presentModalViewController:backgroundMusicViewController animated:YES];
    }
}

- (void)selectionViewNotifyItemSelected:(id)item from:(NSString *)source {
    if([@"curtain" isEqualToString:source]) {
        if([item isKindOfClass:[SelectionItem class]]) {
            SelectionItem *it = item;
            NSUInteger status = -1;
            if([@"open" isEqualToString:it.identifier]) {
                status = OPEN;
            } else if([@"close" isEqualToString:it.identifier]) {
                status = CLOSE;
            } else if([@"stop" isEqualToString:it.identifier]) {
                status = STOP;
            }
            
            if(status == -1) return;
            
            DeviceCommandUpdateDevice *updateDeviceCommand = (DeviceCommandUpdateDevice *)[CommandFactory commandForType:CommandTypeUpdateDevice];
            updateDeviceCommand.masterDeviceCode = self.device.zone.unit.identifier;
            [updateDeviceCommand addCommandString:[self.device commandStringForStatus:status]];
            [[SMShared current].deliveryService executeDeviceCommand:updateDeviceCommand
             ];
        }
    }
}

@end
