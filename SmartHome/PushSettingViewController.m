//
//  PushSettingViewController.m
//  SmartHome
//
//  Created by hadoop user account on 12/09/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "PushSettingViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AudioToolbox/AudioToolbox.h>

#define ITEM_HEIGHT 50

@interface PushSettingViewController ()

@end

@implementation PushSettingViewController{
    UIView *systemSettingView;
    UILabel *lblSystemSetting;
    UIView  *voiceAndShakeView;
    UISwitch *voiceSwitch;
    UISwitch *shakeSwitch;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
    
- (void)initDefaults {
    [super initDefaults];
}
    
- (void)initUI {
    [super initUI];
    
    self.topbar.titleLabel.text = NSLocalizedString(@"push_settings.title", @"");
    CGFloat topBarHeight = self.topbar.frame.size.height;
    UIFont *fontName = [UIFont systemFontOfSize:18];
    
    if(systemSettingView == nil) {
        systemSettingView = [[UIView alloc] initWithFrame:CGRectMake(0, topBarHeight+15, 300, ITEM_HEIGHT)];
        systemSettingView.center = CGPointMake(self.view.center.x, systemSettingView.center.y);
        systemSettingView.layer.cornerRadius = 10;
        systemSettingView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:systemSettingView];
        
        UILabel *lblSysSettingTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 200, ITEM_HEIGHT)];
        lblSysSettingTitle.backgroundColor = [UIColor clearColor];
        lblSysSettingTitle.font = fontName;
        lblSysSettingTitle.text = NSLocalizedString(@"receive_new_notification", @"");
        [systemSettingView addSubview:lblSysSettingTitle];
    }
    
    if(lblSystemSetting == nil) {
        lblSystemSetting = [[UILabel alloc] initWithFrame:CGRectMake(240,0,50,ITEM_HEIGHT)];
        lblSystemSetting.backgroundColor = [UIColor clearColor];
        lblSystemSetting.font = [UIFont systemFontOfSize:16];
        lblSystemSetting.textColor = [UIColor lightGrayColor];
        NSLog(@"%i",[[UIApplication sharedApplication] enabledRemoteNotificationTypes]);
        lblSystemSetting.text = [[UIApplication sharedApplication] enabledRemoteNotificationTypes]?NSLocalizedString(@"status_opened", @""):NSLocalizedString(@"status_closed", @"");
        [systemSettingView addSubview:lblSystemSetting];
    }
    
    UILabel *lblHelp1 = [[UILabel alloc] initWithFrame:CGRectMake(0, topBarHeight+10+ITEM_HEIGHT, 300, 100)];
    lblHelp1.center = CGPointMake(self.view.center.x, lblHelp1.center.y);
    lblHelp1.backgroundColor = [UIColor clearColor];
    lblHelp1.textColor = [UIColor lightTextColor];
    lblHelp1.font = [UIFont systemFontOfSize:14];
    lblHelp1.lineBreakMode = NSLineBreakByWordWrapping;
    lblHelp1.numberOfLines = 0;
    lblHelp1.text = NSLocalizedString(@"push.help1", @"");
    [lblHelp1 sizeThatFits:lblHelp1.frame.size];
    [self.view addSubview:lblHelp1];
    
    if(voiceAndShakeView == nil){
        voiceAndShakeView = [[UIView alloc] initWithFrame:CGRectMake(0,lblHelp1.frame.origin.y+lblHelp1.frame.size.height - 5, 300, 2*ITEM_HEIGHT+1)];
        voiceAndShakeView.center = CGPointMake(self.view.center.x, voiceAndShakeView.center.y);
        voiceAndShakeView.layer.cornerRadius = 10;
        voiceAndShakeView.backgroundColor = [UIColor whiteColor];
        
        [self.view addSubview:voiceAndShakeView];
        UILabel *lblVoice = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 100, ITEM_HEIGHT)];
        lblVoice.backgroundColor = [UIColor clearColor];
        lblVoice.font = fontName;
        lblVoice.text = NSLocalizedString(@"voice", @"");
        [voiceAndShakeView addSubview:lblVoice];
        
        UILabel *lblShake = [[UILabel alloc] initWithFrame:CGRectMake(10, ITEM_HEIGHT, 100, ITEM_HEIGHT)];
        lblShake.backgroundColor = [UIColor clearColor];
        lblShake.font = fontName;
        lblShake.text = NSLocalizedString(@"shake", @"");
        [voiceAndShakeView addSubview:lblShake];

        UIView *seperatorLine = [[UIView alloc] initWithFrame:CGRectMake(0, ITEM_HEIGHT-1, 300, 1)];
        seperatorLine.backgroundColor = [UIColor grayColor];
        [voiceAndShakeView addSubview:seperatorLine];
        
    }
    
    UILabel *lblHelp2 = [[UILabel alloc] initWithFrame:CGRectMake(0, voiceAndShakeView.frame.size.height+voiceAndShakeView.frame.origin.y, 300, 50)];
    lblHelp2.center = CGPointMake(self.view.center.x, lblHelp2.center.y);
    lblHelp2.backgroundColor = [UIColor clearColor];
    lblHelp2.textColor = [UIColor lightTextColor];
    lblHelp2.font = [UIFont systemFontOfSize:14];
    lblHelp2.lineBreakMode = NSLineBreakByWordWrapping;
    lblHelp2.numberOfLines = 0;
    lblHelp2.text = NSLocalizedString(@"push.help2", @"");
    [lblHelp2 sizeThatFits:lblHelp2.frame.size];
    [self.view addSubview:lblHelp2];

    if (voiceSwitch == nil) {
        voiceSwitch = [[UISwitch alloc] initWithFrame:CGRectMake([UIDevice systemVersionIsMoreThanOrEuqal7] ? 240 : 210, 12, 100, 40)];
        [voiceSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        [voiceAndShakeView addSubview:voiceSwitch];
    }
    
    if(shakeSwitch == nil){
        shakeSwitch = [[UISwitch alloc] initWithFrame:CGRectMake([UIDevice systemVersionIsMoreThanOrEuqal7] ? 240 : 210, ITEM_HEIGHT+12, 100, 40)];
        [shakeSwitch addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        [voiceAndShakeView addSubview:shakeSwitch];
    }
}
    
- (void)switchChanged:(UISwitch *)sender {
    if ([sender isEqual:voiceSwitch]) {
        NSLog(@"voice");
        AudioServicesPlaySystemSound(1007);
    } else if([sender isEqual:shakeSwitch]) {
        NSLog(@"shake");
        AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    }
}
    
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
