//
//  DevicesViewController.m
//  SmartHome
//
//  Created by hadoop user account on 13/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DevicesViewController.h"

@interface DevicesViewController ()

@end

@implementation DevicesViewController{
    UITableView *devicesTableView;
}
@synthesize curCell;
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

- (void)initUI{
    [super initUI];
    devicesTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height-44) style:UITableViewStylePlain];
    devicesTableView.dataSource = self;
    devicesTableView.delegate = self;
    [self.view addSubview:devicesTableView];
    if (curCell!=nil) {
        UILabel *lable = self.curCell.textLabel;
        NSLog(@"%@",lable.text);
        self.topbar.titleLabel.text = @"主控详情";
        
    }
    
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.row == 0) {
        
        cell.textLabel.text = curCell.textLabel.text;
        cell.accessoryType = UITableViewCellAccessoryNone;
        
        UIButton *devicesButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        devicesButton.frame = CGRectMake(40, 0, 100, 40);
        [devicesButton setTitle:@"设备数 9" forState:UIControlStateNormal];
        UIView *accessoryView = [[UIView alloc] initWithFrame:CGRectMake(40, 0, 300, 40)];
        [accessoryView addSubview:devicesButton];
        
        UIButton *renameButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        renameButton.frame = CGRectMake(160, 0, 100, 40);
        [renameButton setTitle:NSLocalizedString(@"rename", @"") forState:UIControlStateNormal];
        [renameButton addTarget:self action:@selector(rename) forControlEvents:UIControlEventTouchUpInside];

        [accessoryView addSubview:renameButton];
        
        [cell.contentView addSubview:accessoryView];
    }else{
        
        UIButton *deviceButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        deviceButton.frame = CGRectMake(0, 0, 40, 40);
        [deviceButton setTitle:@"?" forState:UIControlStateNormal];
        [deviceButton addTarget:self action:@selector(setDevice) forControlEvents:UIControlEventTouchUpInside];
        cell.accessoryView = deviceButton;
       
    }

   
    
    return cell;
}
-(void) rename{
    NSLog(@"rename");
}
-(void) setDevice{
    NSLog(@"setDevice");
}
@end
