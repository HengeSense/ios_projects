//
//  DeviceDetailViewController.m
//  SmartHome
//
//  Created by Zhao yang on 9/6/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "DeviceDetailViewController.h"

@interface DeviceDetailViewController ()

@end

@implementation DeviceDetailViewController{
    UITableView *tblDetail;
    
    NSArray *fieldsNames;
    NSArray *fieldsValues;
}

@synthesize device;

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

- (void)initDefaults {
    [super initDefaults];
    if(fieldsNames == nil) {
        fieldsNames = [[NSArray alloc] initWithObjects:NSLocalizedString(@"device_name",@""),NSLocalizedString(@"device_category", @""),NSLocalizedString(@"device_ip", @""),NSLocalizedString(@"device_port", @""),NSLocalizedString(@"device_nwkAddr", @""),NSLocalizedString(@"device_status", @""), nil];
    }
    if(fieldsValues == nil && device) {
        NSString *status = device.status ? NSLocalizedString(@"status_closed", @""):NSLocalizedString(@"status_opened", @"");
        fieldsValues = [[NSArray alloc] initWithObjects:device.name,NSLocalizedString(device.category, @""),    device.ip,[NSString stringWithFormat:@"%i",device.port],device.nwkAddr,status, nil];
    }
}

- (void)initUI {
    [super initUI];
    if(device) {
        self.topbar.titleLabel.text = device.name;
    }
    if(tblDetail ==nil) {
        tblDetail = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbar.frame.size.height + 5, [UIScreen mainScreen].bounds.size.width, self.view.frame.size.height - self.topbar.frame.size.height - 5) style:UITableViewStylePlain];
        tblDetail.center = CGPointMake(self.view.center.x, tblDetail.center.y);
        tblDetail.backgroundColor = [UIColor clearColor];
        tblDetail.dataSource = self;
        tblDetail.delegate = self;
        [self.view addSubview:tblDetail];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return fieldsNames.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        
        cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView.backgroundColor = [UIColor lightGrayColor];
        
        if(![UIDevice systemVersionIsMoreThanOrEuqal7]) {
            cell.textLabel.font = [UIFont systemFontOfSize:16.f];
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
        }
    }
    cell.textLabel.text = [fieldsNames objectAtIndex:indexPath.row];
    if (fieldsValues && fieldsValues.count == fieldsNames.count) {
        cell.detailTextLabel.text = [fieldsValues objectAtIndex:indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
