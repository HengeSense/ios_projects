//
//  AirConditionViewController.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "AirConditionViewController.h"
#import "RadioButton.h"
#import <QuartzCore/QuartzCore.h>

#define RADIO_MARGIN 60
#define LABEL_MARGIN_TOP 20
#define RADIO_CENTER 10
#define CELL_HEIGHT 30

@interface AirConditionViewController ()

@end

@implementation AirConditionViewController{
    UIButton *closeBtn;
    UITableView *temperatureTable;
    NSIndexPath *curIndex;
    
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
    
    if (temperatureTable == nil) {
        temperatureTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbar.frame.size.height+40+30, self.view.frame.size.width,10*CELL_HEIGHT+47/2) style:UITableViewStylePlain];
        temperatureTable.dataSource = self;
        temperatureTable.delegate = self;
        temperatureTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        temperatureTable.backgroundColor = [UIColor clearColor];
        temperatureTable.showsVerticalScrollIndicator = NO;
        temperatureTable.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:temperatureTable];
    }
    if (closeBtn == nil) {
        closeBtn =[[UIButton alloc] initWithFrame:CGRectMake(0, temperatureTable.frame.origin.y-78/2, 75/2, 78/2)];
        closeBtn.center = CGPointMake(self.view.center.x, closeBtn.center.y);
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"btn_rc_power.png"] forState:UIControlStateNormal];
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"btn_rc_power.png"] forState:UIControlStateHighlighted];
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"btn_rc_power.png"] forState:UIControlStateSelected];
        [closeBtn addTarget:self action:@selector(closeBtnPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:closeBtn];
    }
}
-(void) closeBtnPressed{
    return;
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *temperatureCell = nil;
    static NSString *cellIdentifier = @"temperatureCellIdentifier";
    temperatureCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (temperatureCell == nil) {
        temperatureCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    NSString *type;
    if (indexPath.section == 0) {
        type = NSLocalizedString(@"hot", @"");
        temperatureCell.textLabel.text = [NSString stringWithFormat:@"%@     %i℃",type,indexPath.row+21];
    }else{
        type = NSLocalizedString(@"cold", @"");
        temperatureCell.textLabel.text = [NSString stringWithFormat:@"%@     %i℃",type,indexPath.row+21];
    }
    temperatureCell.textLabel.font = [UIFont systemFontOfSize:14];
    temperatureCell.textLabel.textColor = [UIColor colorWithHexString:@"696970"];
    temperatureCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return  temperatureCell;
}
-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIImageView *header = nil;
    if (section == 0) {
        header =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_hot.png"]];
    }else{
        header =[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg_cold.png"]];
    }
    header.frame = CGRectMake(0, 0, 640/2, 47/2);
    return header;

}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    curIndex = indexPath;
    UITableViewCell *curCell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        curCell.backgroundColor = [UIColor colorWithHexString:@"aa5923"];
    }else{
        curCell.backgroundColor = [UIColor colorWithHexString:@"2a6b97"];
    }
    curCell.textLabel.textColor = [UIColor whiteColor];
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(selectDelay) userInfo:nil repeats:NO];
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  CELL_HEIGHT;
}
-(void) selectDelay{
    UITableViewCell *curCell = [temperatureTable cellForRowAtIndexPath:curIndex];
    curCell.textLabel.textColor = [UIColor colorWithHexString:@"696970"];
    curCell.backgroundColor = [UIColor clearColor];
}
@end
