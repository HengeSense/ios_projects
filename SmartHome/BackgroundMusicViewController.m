//
//  BackgroundMusicViewController.m
//  SmartHome
//
//  Created by hadoop user account on 25/11/2013.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "BackgroundMusicViewController.h"
#import "DeviceUtils.h"
#define TWO_TIMES_CLICK_INTERVAL 500
#define TOPBAR_HEIGHT self.topbar.bounds.size.height

@interface BackgroundMusicViewController ()

@end

@implementation BackgroundMusicViewController{
    SMButton *btnPower;
    DirectionButton *btnDirection;
    NSMutableArray *btnDigitalGroups;
    double lastedClickTime;
    
    SMButton *btnMute;
    SMButton *btnInput;
}
@synthesize device;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithDevice:(Device *)device_{
    self = [super init];
    if (self) {
        device = device_;
    }
    return self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initDefaults];
    [self initUI];
}
- (void)initDefaults{
    [super initDefaults];
    lastedClickTime = -1;
}
- (void)initUI{
    [super initUI];
    if(btnPower == nil) {
        btnPower = [[SMButton alloc] initWithFrame:CGRectMake(20, 15+TOPBAR_HEIGHT, 75/2, 78/2)];
        [btnPower setBackgroundImage:[UIImage imageNamed:@"btn_rc_power.png"] forState:UIControlStateNormal];
        [btnPower setBackgroundImage:[UIImage imageNamed:@"power_selected.png"] forState:UIControlStateHighlighted];
        [btnPower addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        btnPower.userObject = [NSNumber numberWithInteger:(self.device.isTV?1:89)];
        [self.view addSubview:btnPower];
    }
    
    if (btnInput == nil) {
        btnInput = [[SMButton alloc] initWithFrame:CGRectMake(124, 18+TOPBAR_HEIGHT, 146/2, 62/2)];
        [btnInput setBackgroundImage:[UIImage imageNamed:@"btn_rc.png"] forState:UIControlStateNormal];
        [btnInput setBackgroundImage:[UIImage imageNamed:@"btn_rc_selected.png"] forState:UIControlStateHighlighted];
        btnInput.userObject = [NSNumber numberWithInteger:(self.device.isTV?20:112)];
        btnInput.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [btnInput setTitleEdgeInsets:UIEdgeInsetsMake(-1, 0, 0, 0)];
        [btnInput setTitle:NSLocalizedString(@"volume_reduce", @"") forState:UIControlStateNormal];
        [btnInput setTitleColor:[UIColor colorWithHexString:@"b8642d"] forState:UIControlStateNormal];
        [btnInput addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btnInput];

    }
    
    if (btnMute == nil) {
        btnMute = [[SMButton alloc] initWithFrame:CGRectMake(256, 15+TOPBAR_HEIGHT, 75/2, 78/2)];
        [btnMute setBackgroundImage:[UIImage imageNamed:@"btn_rc_power.png"] forState:UIControlStateNormal];
        [btnMute setBackgroundImage:[UIImage imageNamed:@"power_selected.png"] forState:UIControlStateHighlighted];
        btnMute.userObject = [NSNumber numberWithInteger:(self.device.isTV?20:112)];
        btnMute.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [btnMute setTitleEdgeInsets:UIEdgeInsetsMake(-1, 0, 0, 0)];
        [btnMute addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btnMute];

    }
    
    if(btnDigitalGroups == nil) {
        btnDigitalGroups = [NSMutableArray array];
        for(int i=0; i<10; i++) {
            CGFloat x = i<5 ? ((75/2) * i + i*23 + 20) : ((75/2) * (i-5) + (i-5)*23 + 20);
            CGFloat y = i<5 ? 80 : 135;
            SMButton *btnDigital = [[SMButton alloc] initWithFrame:CGRectMake(x, y+TOPBAR_HEIGHT, 75/2, 78/2)];
            [btnDigital setTitleColor:[UIColor colorWithHexString:@"b8642d"] forState:UIControlStateNormal];
            [btnDigital setTitle:[NSString stringWithFormat:@"%d", i>=9 ? 0 : (i+1)] forState:UIControlStateNormal];
            btnDigital.userObject = [NSNumber numberWithInteger:(self.device.isTV?i+2:i+90)];
            [btnDigital setBackgroundImage:[UIImage imageNamed:@"btn_rc_number.png"] forState:UIControlStateNormal];
            [btnDigital setBackgroundImage:[UIImage imageNamed:@"btn_rc_number_selected.png"] forState:UIControlStateHighlighted];
            [btnDigital addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btnDigital];
            [btnDigitalGroups addObject:btnDigital];
        }
    }
    
    
    if(btnDirection == nil) {
        btnDirection = [DirectionButton tvDirectionButtonWithPoint:CGPointMake(100, 190+TOPBAR_HEIGHT)];
        btnDirection.center = CGPointMake(self.view.bounds.size.width/2, btnDirection.center.y);
        btnDirection.delegate = self;
        [self.view addSubview:btnDirection];
    }

    
}

- (void)btnPressed:(id)sender {
    // Check btn click is too often
    double now = [NSDate date].timeIntervalSince1970 * 1000;
    if(lastedClickTime != -1) {
        if(now - lastedClickTime <= TWO_TIMES_CLICK_INTERVAL) {
            lastedClickTime = now;
            return;
        }
    }
    lastedClickTime = now;
    
    if(sender != nil) {
        NSNumber *number = nil;
        if([sender isKindOfClass:[SMButton class]]) {
            SMButton *btnSM = ((SMButton *)sender);
            number = btnSM.userObject;
        } else if([sender isKindOfClass:[NSNumber class]]) {
            number = sender;
        }
        if(number != nil) {
            [self controlTvWithSingal:number.integerValue];
        }
    }
}

#pragma mark -
#pragma mark direction button delegate

- (void)leftButtonClicked {
    [self btnPressed:[NSNumber numberWithInteger:16]];
}

- (void)rightButtonClicked {
    [self btnPressed:[NSNumber numberWithInteger:17]];
}

- (void)topButtonClicked {
    [self btnPressed:[NSNumber numberWithInteger:14]];
}

- (void)bottomButtonClicked {
    [self btnPressed:[NSNumber numberWithInteger:15]];
}

- (void)centerButtonClicked {
    [self btnPressed:[NSNumber numberWithInteger:18]];
}

- (void)controlTvWithSingal:(NSInteger)singal {
    if([DeviceUtils checkDeviceIsAvailable:self.device]) {
        DeviceCommandUpdateDevice *updateDevice = (DeviceCommandUpdateDevice *)[CommandFactory commandForType:CommandTypeUpdateDevice];
        updateDevice.masterDeviceCode = self.device.zone.unit.identifier;
        [updateDevice addCommandString:[self.device commandStringForRemote:singal]];
        [[SMShared current].deliveryService executeDeviceCommand:updateDevice];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
