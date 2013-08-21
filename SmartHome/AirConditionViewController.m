//
//  AirConditionViewController.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "AirConditionViewController.h"

#define BOX_MARGIN_LEFT 60
#define BOX_MARGIN_TOP 20
@interface AirConditionViewController ()

@end

@implementation AirConditionViewController{
    QCheckBox *makeHotBox;
    QCheckBox *makeCoolBox;
    QCheckBox *closeBox;
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
    UIView *checkBoard = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, (self.view.frame.size.height-44)/4)];
    checkBoard.backgroundColor = [UIColor whiteColor];
    
    makeHotBox = [[QCheckBox alloc] initWithDelegate:self];
    makeHotBox.frame = CGRectMake(BOX_MARGIN_LEFT, BOX_MARGIN_TOP, 80,40);
    [makeHotBox setTitle:NSLocalizedString(@"make.hot", @"") forState:UIControlStateNormal];
    [makeHotBox setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [makeHotBox setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [makeHotBox setBackgroundImage:[UIImage imageNamed:@"cbx_checked.png"] forState:UIControlStateSelected];
    [makeHotBox setBackgroundImage:[UIImage imageNamed:@"cbx_unchecked.png"] forState:UIControlStateNormal];
    [makeHotBox setTransform:CGAffineTransformMakeRotation(-M_PI/2)];
    [checkBoard addSubview:makeHotBox];
    
    
    
    [self.view addSubview:checkBoard];
    
    
    
}
@end
