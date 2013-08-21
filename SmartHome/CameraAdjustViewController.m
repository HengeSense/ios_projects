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

@implementation CameraAdjustViewController
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
    directionButton = [DirectionButton directionButtonWithPoint:CGPointMake(90, self.view.frame.size.height-90-141)];
    directionButton.delegate = self;
    [self.view addSubview:directionButton];
    
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
