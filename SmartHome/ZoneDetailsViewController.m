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

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)initDefaults {
    [super initDefaults];
}

- (void)initUI {
    [super initUI];
    
    if (tblDevice == nil) {
        tblDevice =[[UITableView alloc] initWithFrame:CGRectMake(0, self.topbar.frame.size.height + 5, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height - self.topbar.frame.size.height - 5) style:UITableViewStylePlain];
        tblDevice.center = CGPointMake(self.view.center.x, tblDevice.center.y);
        tblDevice.backgroundColor = [UIColor clearColor];
        tblDevice.dataSource = self;
        tblDevice.delegate = self;
        [self.view addSubview:tblDevice];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [zone devices].count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";

    UITableViewCell *deviceCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (deviceCell == nil) {
        deviceCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        deviceCell.backgroundColor = [UIColor whiteColor];
        deviceCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        deviceCell.backgroundView = [[UIView alloc] initWithFrame:deviceCell.bounds];
        deviceCell.selectedBackgroundView = [[UIView alloc] initWithFrame:deviceCell.bounds];
        
        deviceCell.backgroundView.backgroundColor = [UIColor whiteColor];
        deviceCell.selectedBackgroundView.backgroundColor = [UIColor lightGrayColor];
        
        if(![UIDevice systemVersionIsMoreThanOrEuqal7]) {
            deviceCell.textLabel.font = [UIFont systemFontOfSize:16.f];
            deviceCell.detailTextLabel.textColor = [UIColor lightGrayColor];
        }
    }
    Device *device = [[zone devices] objectAtIndex:indexPath.row];
    
    deviceCell.textLabel.text = device.name;
    if (device.status == 1) {
        deviceCell.detailTextLabel.text = NSLocalizedString(@"status_closed", @"");
    }else {
        deviceCell.detailTextLabel.text = NSLocalizedString(@"status_opened", @"");
    }
    return deviceCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DeviceDetailViewController *deviceDetailViewController = [[DeviceDetailViewController alloc] init];
    Device *device = [[zone devices] objectAtIndex:indexPath.row];
    deviceDetailViewController.device = device;
    [self.navigationController pushViewController:deviceDetailViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
