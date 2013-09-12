//
//  UnitDetailsViewController.m
//  SmartHome
//
//  Created by hadoop user account on 13/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "UnitDetailsViewController.h"
#import "SMCell.h"
#import "UIColor+ExtentionForHexString.h"
#import "SMDateFormatter.h"

@interface UnitDetailsViewController ()

@end

@implementation UnitDetailsViewController{
    UITableView *tblUnit;
}

@synthesize unit;

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
    
    self.topbar.titleLabel.text = NSLocalizedString(@"unit_detail", @"");
    
    if(tblUnit == nil) {
        tblUnit = [[UITableView alloc] initWithFrame:CGRectMake(-5, self.topbar.bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - self.topbar.bounds.size.height) style:UITableViewStyleGrouped];
        tblUnit.backgroundColor = [UIColor clearColor];
        tblUnit.backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
        tblUnit.delegate = self;
        tblUnit.dataSource = self;
        tblUnit.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:tblUnit];
    }
}

#pragma mark -
#pragma mark table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(section == 0) return 5;
    return (unit == nil ? 0 : (unit.zones == nil ? 0 : unit.zones.count));
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SM_CELL_WIDTH / 2, 40)];
    view.backgroundColor = [UIColor clearColor];
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(12, 9, 200, 30)];
    lblTitle.textColor = [UIColor colorWithHexString:@"b8642d"];
    lblTitle.font = [UIFont boldSystemFontOfSize:19.f];
    lblTitle.backgroundColor = [UIColor clearColor];
    [view addSubview:lblTitle];
    if(section == 0) {
        lblTitle.text = NSLocalizedString(@"unit_info", @"");
    } else {
        lblTitle.text = NSLocalizedString(@"zone_info", @"");
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *topCellIdentifier = @"topCellIdentifier";
    static NSString *centerCellIdentifier = @"cellIdentifier";
    static NSString *bottomCellIdentifier = @"bottomCellIdentifier";
    
    NSString *cellIdentifier;
    
    if(indexPath.section == 0) {
        cellIdentifier = @"staticCellIdentifer";
    } else {
        if(indexPath.row == 0) {
            cellIdentifier = topCellIdentifier;
        } else if(indexPath.row == unit.zones.count - 1) {
            cellIdentifier = bottomCellIdentifier;
        } else {
            cellIdentifier = centerCellIdentifier;
        }
    }
   
    SMCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[SMCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 2, 120, 40)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.tag = 999;
        [cell addSubview:titleLabel];
        
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 2, 150, 40)];
        detailLabel.textAlignment = NSTextAlignmentRight;
        detailLabel.textColor = [UIColor darkGrayColor];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.font = [UIFont systemFontOfSize:16.f];
        detailLabel.tag = 888;
        [cell addSubview:detailLabel];
    }
    
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:999];
    UILabel *detailLabel = (UILabel *)[cell viewWithTag:888];
    
    if(indexPath.section == 0) {
        if(indexPath.row == 0) {
            titleLabel.text = NSLocalizedString(@"unit_name", @"");
            detailLabel.text = unit == nil ? [NSString emptyString] : [NSString stringWithFormat:@"%@   ", unit.name];
            cell.isTop = YES;
        } else if(indexPath.row == 1) {
            titleLabel.text = NSLocalizedString(@"unit_address", @"");
            detailLabel.text = unit == nil ? [NSString emptyString] : unit.localIP;
            cell.accessoryViewVisible = YES;
            cell.isCenter = YES;
        } else if(indexPath.row == 2) {
            titleLabel.text = NSLocalizedString(@"unit_state", @"");
            detailLabel.text = unit == nil ? [NSString emptyString] : unit.status;
            cell.accessoryViewVisible = YES;
            cell.isCenter = YES;
        } else if(indexPath.row == 3) {
            titleLabel.text = NSLocalizedString(@"unit_devices_count", @"");
            detailLabel.text = unit == nil ? [NSString emptyString] : [NSString stringWithFormat:@"%d", unit.devices.count];
            cell.accessoryViewVisible = YES;
            cell.isCenter = YES;
        } else if(indexPath.row == 4) {
            cell.accessoryViewVisible = YES;
            detailLabel.text = unit == nil ? [NSString emptyString] : [SMDateFormatter dateToString:unit.updateTime format:@"MM-dd HH:mm"];
            titleLabel.text = NSLocalizedString(@"unit_lastupdate_time", @"");
            cell.isBottom = YES;
        }
    } else if(indexPath.section == 1) {
        Zone *zone = [unit.zones objectAtIndex:indexPath.row];
        titleLabel.text = zone.name;
        
        if(unit.zones.count == 1) {
            cell.isSingle = YES;
        }
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
