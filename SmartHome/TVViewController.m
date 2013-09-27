//
//  TVViewController.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "TVViewController.h"
#import "TVRemoteControlPanel.h"

@interface TVViewController ()

@end

@implementation TVViewController{
    TVRemoteControlPanel *remoteControl;
}

@synthesize device = _device_;

- (id)initWithDevice:(Device *)device {
    self = [super init];
    if(self) {
        _device_ = device;
    }
    return self;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)initUI {
    [super initUI];
    if(remoteControl == nil) {
        remoteControl = [TVRemoteControlPanel pannelWithPoint:CGPointMake(0, self.topbar.bounds.size.height)];
        remoteControl.device = self.device;
        [self.view addSubview:remoteControl];
    }
}

- (void)setDevice:(Device *)device {
    _device_ = device;
    if(remoteControl != nil) {
        remoteControl.device = device;
    }
}

@end
