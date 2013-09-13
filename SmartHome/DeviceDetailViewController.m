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

-(void) initDefaults{
    [super initDefaults];
    if (fieldsNames == nil) {
        fieldsNames = [[NSArray alloc] initWithObjects:NSLocalizedString(@"device.name",@""),NSLocalizedString(@"device.category", @""),NSLocalizedString(@"device.ip", @""),NSLocalizedString(@"device.port", @""),NSLocalizedString(@"device.nwkAddr", @""),NSLocalizedString(@"device.status", @""), nil];
    }
    if (fieldsValues == nil && device) {
        NSString *status = device.status?NSLocalizedString(@"closed", @""):NSLocalizedString(@"opened", @"");
        fieldsValues = [[NSArray alloc] initWithObjects:device.name,NSLocalizedString(device.category, @""),    device.ip,[NSString stringWithFormat:@"%i",device.port],device.nwkAddr,status, nil];
    }
}

-(void) initUI{
    [super initUI];
    if(device)
        self.topbar.titleLabel.text = device.name;
    if (tblDetail ==nil) {
        tblDetail = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbar.frame.size.height,SM_CELL_WIDTH/2, self.view.frame.size.height-self.topbar.frame.size.height) style:UITableViewStylePlain];
        tblDetail.center = CGPointMake(self.view.center.x, tblDetail.center.y);
        tblDetail.separatorStyle = UITableViewCellSeparatorStyleNone;
        tblDetail.backgroundColor = [UIColor clearColor];
        tblDetail.dataSource = self;
        tblDetail.delegate = self;
        [self.view addSubview:tblDetail];
    }
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return fieldsNames.count;
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *cellDetailIndentifier;
    if (indexPath.row == 0) {
        cellDetailIndentifier = @"topCellIdentifier";
    }else if (indexPath.row == fieldsNames.count-1){
        cellDetailIndentifier = @"bottomCellIdentifier";
    }else{
        cellDetailIndentifier = @"cellIdentifier";
    }
    SMCell *cellDetail = [tableView dequeueReusableCellWithIdentifier:cellDetailIndentifier];
    if (cellDetail == nil) {
        cellDetail = [[SMCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellDetailIndentifier];
        UILabel *lblValue = [[UILabel alloc] initWithFrame:CGRectMake(SM_CELL_WIDTH/2-120, 0, 100, SM_CELL_HEIGHT/2)];
        lblValue.textAlignment = UITextAlignmentRight;
        lblValue.backgroundColor = [UIColor clearColor];
        lblValue.font = [UIFont systemFontOfSize:16];
        lblValue.textColor = [UIColor lightGrayColor];
        lblValue.tag = 1000;
        [cellDetail addSubview:lblValue];
    }
    UILabel *lblValue = (UILabel *)[cellDetail viewWithTag:1000];
    if (fieldsValues&&fieldsValues.count == fieldsNames.count) {
        lblValue.text = [fieldsValues objectAtIndex:indexPath.row];
    }
    cellDetail.textLabel.text = [fieldsNames objectAtIndex:indexPath.row];
    cellDetail.accessoryViewVisible = YES;
    return cellDetail;
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
