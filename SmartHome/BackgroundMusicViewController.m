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
    SMButton *btnInputSource;
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
        btnPower.userObject = [NSNumber numberWithInteger:201];
        [self.view addSubview:btnPower];
    }
    
    if (btnInputSource == nil) {
        btnInputSource = [[SMButton alloc] initWithFrame:CGRectMake(115, 18+TOPBAR_HEIGHT, 146/2, 62/2)];
        [btnInputSource setBackgroundImage:[UIImage imageNamed:@"btn_rc.png"] forState:UIControlStateNormal];
        [btnInputSource setBackgroundImage:[UIImage imageNamed:@"btn_rc_selected.png"] forState:UIControlStateHighlighted];
        btnInputSource.userObject = [NSNumber numberWithInteger:222];
        btnInputSource.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [btnInputSource setTitleEdgeInsets:UIEdgeInsetsMake(-1, 0, 0, 0)];
        [btnInputSource setTitle:NSLocalizedString(@"input.source", @"") forState:UIControlStateNormal];
        [btnInputSource setTitleColor:[UIColor colorWithHexString:@"b8642d"] forState:UIControlStateNormal];
        [btnInputSource addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btnInputSource];

    }
    
    if (btnMute == nil) {
        btnMute = [[SMButton alloc] initWithFrame:CGRectMake(215, 18+TOPBAR_HEIGHT, 146/2, 62/2)];
        [btnMute setBackgroundImage:[UIImage imageNamed:@"btn_rc.png"] forState:UIControlStateNormal];
        [btnMute setBackgroundImage:[UIImage imageNamed:@"btn_rc_selected.png"] forState:UIControlStateHighlighted];
        btnMute.userObject = [NSNumber numberWithInteger:233];
        btnMute.titleLabel.font = [UIFont systemFontOfSize:15.f];
        [btnMute setTitleColor:[UIColor colorWithHexString:@"b8642d"] forState:UIControlStateNormal];
        [btnMute setTitle:NSLocalizedString(@"mute", @"") forState:UIControlStateNormal];
        [btnMute setTitleEdgeInsets:UIEdgeInsetsMake(-1, 0, 0, 0)];
        [btnMute addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btnMute];

    }
    
    if(btnDigitalGroups == nil) {
        btnDigitalGroups = [NSMutableArray array];
        for(int i=0; i<6; i++) {
            int row = i/3;
            int column = i%3;
            CGFloat x = 20+column*(73+25);
            CGFloat y = 80+row*(31+40);
            SMButton *btnDigital = [[SMButton alloc] initWithFrame:CGRectMake(x, y+TOPBAR_HEIGHT, 146/2, 62/2)];
            btnDigital.titleLabel.font = [UIFont systemFontOfSize:15.f];
            [btnDigital setTitleColor:[UIColor colorWithHexString:@"b8642d"] forState:UIControlStateNormal];
            [btnDigital setTitle:[NSString stringWithFormat:@"%@%d", NSLocalizedString(@"custom", @""),(i+1)] forState:UIControlStateNormal];
            btnDigital.userObject = [NSNumber numberWithInteger:227+i];
            if (i == 3) {
                btnDigital.userObject = [NSNumber numberWithInteger:231];
            }else if (i == 4){
                btnDigital.userObject = [NSNumber numberWithInteger:232];
            }else if (i == 5){
                btnDigital.userObject = [NSNumber numberWithInteger:236];
            }
            [btnDigital setBackgroundImage:[UIImage imageNamed:@"btn_rc.png"] forState:UIControlStateNormal];
            [btnDigital setBackgroundImage:[UIImage imageNamed:@"btn_rc_selected.png"] forState:UIControlStateHighlighted];
            [btnDigital addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btnDigital];
            [btnDigitalGroups addObject:btnDigital];
        }
    }
    
    
    if(btnDirection == nil) {
        btnDirection = [DirectionButton bgMusicDirectionButtonWithPoint:CGPointMake(100, 190+TOPBAR_HEIGHT)];
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
    [self btnPressed:[NSNumber numberWithInteger:217]];
}

- (void)rightButtonClicked {
    [self btnPressed:[NSNumber numberWithInteger:216]];
}

- (void)topButtonClicked {
    [self btnPressed:[NSNumber numberWithInteger:215]];
}

- (void)bottomButtonClicked {
    [self btnPressed:[NSNumber numberWithInteger:218]];
}

- (void)centerButtonClicked {
    [self btnPressed:[NSNumber numberWithInteger:213]];
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
