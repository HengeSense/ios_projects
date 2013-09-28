//
//  ZoneDetailsViewController.m
//  SmartHome
//
//  Created by Zhao yang on 9/12/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ZoneDetailsViewController.h"
#import "DeviceDetailViewController.h"
@interface ZoneDetailsViewController ()

@end

@implementation ZoneDetailsViewController{
    UITableView *tblDevice;
}

@synthesize zone;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}
-(void) initDefaults{
    [super initDefaults];
}
-(void) initUI{
    [super initUI];
    
    if (tblDevice == nil) {
        tblDevice =[[UITableView alloc] initWithFrame:CGRectMake(0, self.topbar.frame.size.height, SM_CELL_WIDTH/2, self.view.frame.size.height-self.topbar.frame.size.height) style:UITableViewStylePlain];
        tblDevice.center = CGPointMake(self.view.center.x, tblDevice.center.y);
        tblDevice.separatorStyle = UITableViewCellSeparatorStyleNone;
        tblDevice.backgroundColor = [UIColor clearColor];
        tblDevice.dataSource = self;
        tblDevice.delegate = self;
        [self.view addSubview:tblDevice];
    }
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [zone devices].count;
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *deviceCellIdentifier;
    if (indexPath.row == 0) {
        deviceCellIdentifier = @"topCellIdentifier";
    }else if (indexPath.row == [zone devices].count-1){
        deviceCellIdentifier = @"bottomCellIdentifier";
    }else{
        deviceCellIdentifier = @"cellIdentifier";
    }

    SMCell *deviceCell = [tableView dequeueReusableCellWithIdentifier:deviceCellIdentifier];
    if (deviceCell == nil) {
        deviceCell = [[SMCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:deviceCellIdentifier];
        UILabel *lblStatus = [[UILabel alloc] initWithFrame:CGRectMake(SM_CELL_WIDTH/2-75, 0, 50, SM_CELL_HEIGHT/2)];
        lblStatus.backgroundColor = [UIColor clearColor];
        lblStatus.font = [UIFont systemFontOfSize:16];
        lblStatus.textColor = [UIColor lightGrayColor];
        lblStatus.tag = 1000;
        [deviceCell addSubview:lblStatus];
    }
    UILabel *lblStatus = (UILabel *)[deviceCell viewWithTag:1000];
    Device *device = [[zone devices] objectAtIndex:indexPath.row];
    deviceCell.textLabel.text = device.name;
    if (device.status == 1) {
        lblStatus.text = NSLocalizedString(@"status_closed", @"");
    }else {
        lblStatus.text = NSLocalizedString(@"status_opened", @"");
    }
    return deviceCell;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DeviceDetailViewController *deviceDetailViewController = [[DeviceDetailViewController alloc] init];
    Device *device = [[zone devices] objectAtIndex:indexPath.row];
    deviceDetailViewController.device = device;
    [self.navigationController pushViewController:deviceDetailViewController animated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
