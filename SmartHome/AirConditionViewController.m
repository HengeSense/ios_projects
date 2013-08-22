//
//  AirConditionViewController.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "AirConditionViewController.h"
#import "RadioButton.h"
#define RADIO_MARGIN 60

@interface AirConditionViewController ()

@end

@implementation AirConditionViewController{
    UIButton *makeHot;
    UIButton *makeCool;
    UIButton *close;
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
    // Dispose of any resources that can be recreated.
}
-(void) initUI{
    [super initUI];
    UIView *checkBoard = [[UIView alloc] initWithFrame:CGRectMake(3, 44, self.view.frame.size.width-6, (self.view.frame.size.height-44)/4)];
    checkBoard.backgroundColor = [UIColor whiteColor];
    
    makeHot = [RadioButton buttonWithPoint:CGPointMake(RADIO_MARGIN, RADIO_MARGIN)];
    
//    CALayer
    [checkBoard addSubview:makeHot];
    
    
    
    [self.view addSubview:checkBoard];
    
    
    
}
@end
