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
    
    self.topbar.titleLabel.text = NSLocalizedString(@"aircondition_setting.title",@"");
    
    if (temperatureTable == nil) {
        temperatureTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbar.frame.size.height+40+30, self.view.frame.size.width,self.view.frame.size.height-40-30) style:UITableViewStylePlain];
        temperatureTable.dataSource = self;
        temperatureTable.delegate = self;
        temperatureTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        temperatureTable.backgroundColor = [UIColor clearColor];
        temperatureTable.showsVerticalScrollIndicator = NO;
        [self.view addSubview:temperatureTable];
    }
    if (closeBtn == nil) {
        closeBtn =[[UIButton alloc] initWithFrame:CGRectMake(self.view.center.x, temperatureTable.frame.origin.y-10-78/2, 75/2, 78/2)];
//        closeBtn setBackgroundImage:[UIImage imageNamed:@"btn_rc_power.png"] forState:uibuttontype
    }
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
        curCell.textLabel.textColor = [UIColor colorWithHexString:@"ce621b"];
    }else{
        curCell.textLabel.textColor = [UIColor colorWithHexString:@"348138"];
    }
    [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(selectDelay) userInfo:nil repeats:NO];
}
-(void) selectDelay{
    UITableViewCell *curCell = [temperatureTable cellForRowAtIndexPath:curIndex];
    curCell.textLabel.textColor = [UIColor colorWithHexString:@"696970"];
}
@end
