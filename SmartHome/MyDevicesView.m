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
    if(tblUnits == nil) {
        tblUnits = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbar.bounds.size.height + 5, SM_CELL_WIDTH / 2, self.frame.size.height - self.topbar.bounds.size.height - 5) style:UITableViewStylePlain];
        tblUnits.center = CGPointMake(self.center.x, tblUnits.center.y);
        tblUnits.separatorStyle = UITableViewCellSeparatorStyleNone;
        tblUnits.delegate = self;
        tblUnits.dataSource = self;
        tblUnits.backgroundColor = [UIColor clearColor];
        [self addSubview:tblUnits];
    }
}

#pragma mark -
#pragma mark table view delegate

#pragma mark -
#pragma mark table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return SM_CELL_HEIGHT / 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *topCellIdentifier = @"topCellIdentifier";
    static NSString *centerCellIdentifier = @"cellIdentifier";
    static NSString *bottomCellIdentifier = @"bottomCellIdentifier";
    
    NSString *cellIdentifier;
    
    if(indexPath.row == 0) {
        cellIdentifier = topCellIdentifier;
    } else if(indexPath.row == 13) {
        cellIdentifier = bottomCellIdentifier;
    } else {
        cellIdentifier = centerCellIdentifier;
    }
    
    SMCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[SMCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    return cell;
}

@end
