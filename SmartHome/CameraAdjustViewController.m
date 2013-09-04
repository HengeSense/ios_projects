//
//  CameraAdjustViewController.m
//  SmartHome
//
//  Created by hadoop user account on 21/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "CameraAdjustViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+ExtentionForHexString.h"


@interface CameraAdjustViewController ()

@end

@implementation CameraAdjustViewController{
    UIImageView *imgCameraShots;
    UIView *backgroundView;
    DirectionButton *btnDirection;
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

-(void) initUI{
    [super initUI];
    self.topbar.titleLabel.text = NSLocalizedString(@"camera_adjust", @"");
    
    if(backgroundView == nil) {
        backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topbar.bounds.size.height + 5, 310, self.view.bounds.size.height - self.topbar.bounds.size.height - 30)];
        backgroundView.center = CGPointMake(self.view.center.x, backgroundView.center.y);
        backgroundView.backgroundColor = [UIColor colorWithHexString:@"#1a1a1f"];
        backgroundView.layer.cornerRadius = 10;
        [self.view addSubview:backgroundView];
    }
    
    if(imgCameraShots == nil) {
        imgCameraShots = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 280, 200)];
        imgCameraShots.center = CGPointMake(backgroundView.bounds.size.width / 2, imgCameraShots.center.y);
        imgCameraShots.image = [UIImage imageNamed:@"test.png"];
        [backgroundView addSubview:imgCameraShots];
    }
    
    if(btnDirection == nil) {
        btnDirection = [DirectionButton tvDirectionButtonWithPoint:CGPointMake(90, imgCameraShots.frame.origin.y + imgCameraShots.bounds.size.height + 20)];
        btnDirection.delegate = self;
        [backgroundView addSubview:btnDirection];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnDownPressed:(id)sender {
    
}



#pragma mark -
#pragma mark direction button delegate

- (void)leftButtonClicked {
    NSLog(@"leftClicked");
}

- (void)rightButtonClicked {
    NSLog(@"rightClicked");
}

- (void)centerButtonClicked {
    NSLog(@"centerClicked");
}

- (void)topButtonClicked {
    NSLog(@"topClicked");
}

- (void)bottomButtonClicked {
    NSLog(@"bottomClicked");
}

@end
