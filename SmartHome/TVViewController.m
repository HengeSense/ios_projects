//
//  TVViewController.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "TVViewController.h"

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
        tvTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbar.bounds.size.height + 5, CELL_WIDTH / 2, self.view.frame.size.height - self.topbar.bounds.size.height - 5) style:UITableViewStylePlain];
        tvTable.dataSource = self;
        tvTable.delegate = self;
        tvTable.backgroundColor = [UIColor whiteColor];
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
    static NSString *tvCellIndendifier = @"tvcell";
    UITableViewCell *tvCell = [tableView dequeueReusableCellWithIdentifier:tvCellIndendifier];
    if (tvCell == nil) {
        tvCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tvCellIndendifier];
    }

    if(indexPath.row == 0){
        tvSwitch = [[UIButton alloc] initWithFrame:CGRectMake(CELL_HEIGHT/2, CELL_HEIGHT/4,39/2,44/2)];
        [tvSwitch setBackgroundImage:[UIImage imageNamed:@"btn_switch.png"] forState:UIControlStateNormal];
        [tvCell.contentView addSubview:tvSwitch];
        tvCell.textLabel.text = NSLocalizedString(@"power.switch", @"");
        
    }else{
        tvCell.textLabel.text = [NSString stringWithFormat:@"cctv-%i",indexPath.row];
    }
    return tvCell;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return CELL_HEIGHT;
    }
    return CELL_HEIGHT/2;
}

@end
