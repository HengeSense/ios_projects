//
//  CameraAdjustViewController.m
//  SmartHome
//
//  Created by hadoop user account on 21/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "CameraAdjustViewController.h"
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
    
    self.topbar.titleLabel.text = NSLocalizedString(@"camera.adjust", @"");
    if(backgroundView == nil) {
        backgroundView = [[UIView alloc] initWithFrame:CGRectMake(3, self.topbar.bounds.size.height + 1, self.view.bounds.size.width - 6, self.view.bounds.size.height - self.topbar.bounds.size.height - 3)];
        backgroundView.backgroundColor = [UIColor colorWithHexString:@"#1a1a1f"];
        [self.view addSubview:backgroundView];
    }
    
    if(imgCameraShots == nil) {
        imgCameraShots = [[UIImageView alloc] initWithFrame:CGRectMake(0, 6, 300, 200)];
        imgCameraShots.center = CGPointMake(backgroundView.center.x - 2, imgCameraShots.center.y);
        imgCameraShots.image = [UIImage imageNamed:@"camera_image.jpg"];
        [backgroundView addSubview:imgCameraShots];
    }
    
    if(btnDirection == nil) {
        btnDirection = [DirectionButton directionButtonWithPoint:CGPointMake(90, self.view.bounds.size.height - self.topbar.bounds.size.height - 150)];
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
