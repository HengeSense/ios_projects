//
//  TVViewController.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "TVViewController.h"
#import <QuartzCore/QuartzCore.h>
#define CELL_HEIGHT 93
#define CELL_WIDTH 624

@interface TVViewController ()

@end

@implementation TVViewController{
    UITableView *tvTable;
    UIButton    *tvSwitch;
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

-(void) initUI{
    [super initUI];
    self.topbar.titleLabel.text = @"客厅电视机设置";
    
    if(tvTable == nil) {
        tvTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbar.bounds.size.height + 5, SM_CELL_WIDTH/2, self.view.frame.size.height - self.topbar.bounds.size.height - 5) style:UITableViewStylePlain];
        tvTable.center = CGPointMake(self.view.center.x, tvTable.center.y);
        tvTable.dataSource = self;
        tvTable.delegate = self;
        tvTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        tvTable.backgroundColor = [UIColor clearColor];
        [self.view addSubview:tvTable];
    }
}

#pragma mark -
#pragma mark table view delegate

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *topCellIdentifier = @"topCellIdentifier";
    static NSString *commonCellIdentifier = @"cellIdentifier";
    static NSString *bottomCellIdentifier = @"bottomCellIdentifier";
    NSString *tvCellIdentifier;
    
    if (indexPath.row == 0) {
        tvCellIdentifier = topCellIdentifier;
    }else if(indexPath.row == 9){
        tvCellIdentifier = bottomCellIdentifier;
    }else{
        tvCellIdentifier = commonCellIdentifier;
    }
    
    UITableViewCell *tvCell = [tableView dequeueReusableCellWithIdentifier:tvCellIdentifier];
    if (tvCell == nil) {
        tvCell = [[SMCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tvCellIdentifier];
    }
    
    if(indexPath.row == 0){
        tvSwitch = [[UIButton alloc] initWithFrame:CGRectMake(10, CELL_HEIGHT/4-5,39/2,44/2)];
        [tvSwitch setBackgroundImage:[UIImage imageNamed:@"btn_switch.png"] forState:UIControlStateNormal];
        UIView *content = [[UIView alloc] initWithFrame:tvCell.contentView.bounds];
        [content addSubview:tvSwitch];
        UILabel *switchLabel = [[UILabel alloc] initWithFrame:CGRectMake(tvSwitch.frame.origin.x+39/2+10, tvSwitch.frame.origin.y, 100, 20)];
        switchLabel.text = NSLocalizedString(@"power.switch", @"");
        switchLabel.font = [UIFont systemFontOfSize:14];
        [content addSubview:switchLabel];
        [tvCell addSubview:content];
    }else{
        tvCell = [[SMCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tvCellIdentifier];
        tvCell.textLabel.text = [NSString stringWithFormat:@"cctv-%i",indexPath.row];
        tvCell.frame = CGRectMake(0, 0, SM_CELL_WIDTH/2, CELL_HEIGHT);
    }

    return tvCell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SM_CELL_HEIGHT / 2;
}

@end
