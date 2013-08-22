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
#define LABEL_MARGIN_TOP 20
#define RADIO_CENTER 10
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
    self.topbar.titleLabel.text = [NSString stringWithFormat:@"%@%@",@"客厅",NSLocalizedString(@"air.condition.setting",@"")];
    CGFloat topbarHeight = self.topbar.frame.size.height;
    UIView *checkBoard = [[UIView alloc] initWithFrame:CGRectMake(3, topbarHeight, self.view.frame.size.width-6, (self.view.frame.size.height-topbarHeight)/4)];
    checkBoard.backgroundColor = [UIColor whiteColor];
    
    if(makeHot ==nil){
        makeHot = [RadioButton buttonWithPoint:CGPointMake(RADIO_MARGIN, RADIO_MARGIN)];
        [makeHot addTarget:self action:@selector(radioTouchInside:) forControlEvents:UIControlEventTouchUpInside];
        makeHot.selected = YES;
    }
    UILabel *hotLabel = [[UILabel alloc] initWithFrame:CGRectMake(makeHot.frame.origin.x-RADIO_CENTER, LABEL_MARGIN_TOP, 40, 20)];
    hotLabel.text = NSLocalizedString(@"make.hot", @"");
    hotLabel.textColor = [UIColor blackColor];
    hotLabel.textAlignment = UITextAlignmentCenter;
    hotLabel.backgroundColor = [UIColor clearColor];
    [checkBoard addSubview:hotLabel];
    
    
    if(makeCool==nil){
        makeCool = [RadioButton buttonWithPoint:CGPointMake(makeHot.frame.origin.x+makeHot.frame.size.width+RADIO_MARGIN, RADIO_MARGIN)];
        [makeCool addTarget:self action:@selector(radioTouchInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    UILabel *coolLabel = [[UILabel alloc] initWithFrame:CGRectMake(makeCool.frame.origin.x-RADIO_CENTER, LABEL_MARGIN_TOP, 40, 20)];
    coolLabel.text = NSLocalizedString(@"make.cool", @"");
    coolLabel.textColor = [UIColor blackColor];
    coolLabel.textAlignment = UITextAlignmentCenter;
    coolLabel.backgroundColor = [UIColor clearColor];
    [checkBoard addSubview:coolLabel];
    
    
    if(close == nil){
        close = [RadioButton buttonWithPoint:CGPointMake(makeCool.frame.origin.x+makeCool.frame.size.width+RADIO_MARGIN, RADIO_MARGIN)];
        [close addTarget:self action:@selector(radioTouchInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    UILabel *closeLabel = [[UILabel alloc] initWithFrame:CGRectMake(close.frame.origin.x-RADIO_CENTER, LABEL_MARGIN_TOP, 40, 20)];
    closeLabel.text = NSLocalizedString(@"close", @"");
    closeLabel.textColor = [UIColor blackColor];
    closeLabel.textAlignment = UITextAlignmentCenter;
    closeLabel.backgroundColor = [UIColor clearColor];
    [checkBoard addSubview:closeLabel];
    
    [checkBoard addSubview:makeHot];
    [checkBoard addSubview:makeCool];
    [checkBoard addSubview:close];
    
    
    
    
    [self.view addSubview:checkBoard];
    
    
    
}
-(void) radioTouchInside:(UIButton *) radio{
    makeHot.selected =NO;
    makeCool.selected = NO;
    close.selected = NO;
    radio.selected =!radio.selected;
    
}
@end
