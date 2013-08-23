//
//  MyDevicesView.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "MyDevicesView.h"
#import "DevicesViewController.h"
#import "TVViewController.h"
#import "AirConditionViewController.h"

@implementation MyDevicesView {
    UITableView *tblUnits;
    NSMutableArray *deviceNames;
    NSMutableArray *deviceSettingControllers;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initUI];
    }
    return self;
}

- (void)initDefaults {
    [super initDefaults];
}

- (void)initUI {
    [super initUI];
    deviceNames = [[NSMutableArray alloc] initWithObjects:@"电视机",@"空调", nil];
    deviceSettingControllers = [[NSMutableArray alloc] initWithObjects:[[TVViewController alloc] init],[AirConditionViewController new], nil];
    
    
    if(tblUnits == nil) {
        tblUnits = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbar.bounds.size.height, self.frame.size.width, self.frame.size.height-self.topbar.bounds.size.height) style:UITableViewStylePlain];
        tblUnits.backgroundColor = [UIColor clearColor];
        tblUnits.dataSource = self;
        tblUnits.delegate = self;
        [self addSubview:tblUnits];
    }
}

#pragma mark -
#pragma mark table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return deviceNames.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifierUnits = @"unitscell";
    
    UITableViewCell *unitsCell = nil;
    unitsCell = [tableView dequeueReusableCellWithIdentifier:indentifierUnits];
    if (unitsCell == nil) {
        unitsCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifierUnits];
    }
    unitsCell.textLabel.text = [deviceNames objectAtIndex:indexPath.row];
    unitsCell.textLabel.textColor = [UIColor whiteColor];
    return unitsCell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.ownerController.navigationController pushViewController:[deviceSettingControllers objectAtIndex:indexPath.row]  animated:YES];
}
@end
