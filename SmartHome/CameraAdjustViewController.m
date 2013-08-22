//
//  CameraAdjustViewController.m
//  SmartHome
//
//  Created by hadoop user account on 21/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "CameraAdjustViewController.h"

@interface CameraAdjustViewController ()

@end

@implementation CameraAdjustViewController{
    UIImageView *cameraImage;
    UIView *cameraView;
}

@synthesize directionButton;

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
    cameraView = [[UIView alloc] initWithFrame:CGRectMake(3, 47, self.view.bounds.size.width-6, self.view.bounds.size.height-90)];
    cameraView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:cameraView];
    
    cameraImage = [[UIImageView alloc] initWithFrame:CGRectMake(3, 3, cameraView.frame.size.width-6, cameraView.frame.size.height-90-100)];
    cameraImage.image = [UIImage imageNamed:@"camera_image.jpg"];
    [cameraView addSubview:cameraImage];
    
    directionButton = [DirectionButton directionButtonWithPoint:CGPointMake(90,cameraView.frame.size.height-141-30)];
    directionButton.delegate = self;
    [cameraView addSubview:directionButton];
    
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)leftButtonClicked{
    NSLog(@"leftClicked");
}
- (void)rightButtonClicked{
    NSLog(@"rightClicked");
}
- (void)centerButtonClicked{
    NSLog(@"centerClicked");
}
- (void)topButtonClicked{
    NSLog(@"topClicked");
}
- (void)bottomButtonClicked{
    NSLog(@"bottomClicked");
}


@end
