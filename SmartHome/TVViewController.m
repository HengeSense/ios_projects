//
//  TVViewController.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "TVViewController.h"
#define CELL_HEIGHT 40
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
-(void) initUI{
    [super initUI];
    tvTable.dataSource = self;
    tvTable.delegate = self;
    
    self.topbar.titleLabel.text = @"客厅电视机设置";
    
    
}
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
        tvSwitch = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        
    }else{
        tvCell.textLabel.text = [NSString stringWithFormat:@"cctv-%i",indexPath.row];
    }
    return tvCell;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 2*CELL_HEIGHT;
    }
    return CELL_HEIGHT;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
