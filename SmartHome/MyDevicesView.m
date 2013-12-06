//
//  MyDevicesView.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "MyDevicesView.h"
#import "UnitDetailsViewController.h"
#import "SMCell.h"
#import "UnitsBindingViewController.h"
#import "UIColor+ExtentionForHexString.h"

@implementation MyDevicesView {
    UITableView *tblUnits;
    NSArray *unitsIdentifierCollection;
    UIButton *btnAdd;
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
        tblUnits = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbar.bounds.size.height + 10, [UIScreen mainScreen].bounds.size.width, self.frame.size.height - self.topbar.bounds.size.height - 10) style:UITableViewStylePlain];
        tblUnits.center = CGPointMake(self.center.x, tblUnits.center.y);
        tblUnits.delegate = self;
        tblUnits.dataSource = self;
        tblUnits.backgroundColor = [UIColor clearColor];
        [self addSubview:tblUnits];
    }
    
    if (btnAdd == nil) {
        btnAdd = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - 44, [UIDevice systemVersionIsMoreThanOrEuqal7] ? 20 : 0, 88/2, 88/2)];
        [btnAdd setBackgroundImage:[UIImage imageNamed:@"btn_add.png"] forState:UIControlStateNormal];
        [btnAdd addTarget:self action:@selector(btnAddPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.topbar addSubview:btnAdd];
    }
    
    [[SMShared current].memory subscribeHandler:[DeviceCommandGetUnitsHandler class] for:self];
}

#pragma mark-
#pragma mark btn action

- (void)btnAddPressed:(UIButton *)sender {
    UnitsBindingViewController *unitsBindingViewController = [[UnitsBindingViewController alloc] initWithType:TopBarTypeDone];
    [self.ownerController presentViewController:unitsBindingViewController animated:YES completion:nil];
}

#pragma mark -
#pragma mark view service

- (void)notifyViewUpdate {
    [super notifyViewUpdate];
    [self refresh];
}

- (void)notifyUnitsWasUpdate {
    [self refresh];
}

- (void)refresh {
    unitsIdentifierCollection = [[SMShared current].memory allUnitsIdentifierAsArray];
    [tblUnits reloadData];
}

#pragma mark -
#pragma mark table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return unitsIdentifierCollection == nil ? 0 : unitsIdentifierCollection.count;
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
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        
        cell.backgroundView.backgroundColor = [UIColor whiteColor];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"e5e5e5"];
        
        if(![UIDevice systemVersionIsMoreThanOrEuqal7]) {
            cell.textLabel.font = [UIFont systemFontOfSize:16.f];
            cell.detailTextLabel.textColor = [UIColor colorWithHexString:@"e5e5e5"];
        }
    }
    
    Unit *unit = [[SMShared current].memory findUnitByIdentifier:[unitsIdentifierCollection objectAtIndex:indexPath.row]];

    if(unit != nil) {
        cell.textLabel.text = unit.name;
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@   ", [NSString isBlank:unit.status] ? NSLocalizedString(@"online", @"") : unit.status];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UnitDetailsViewController *unitDetailsViewController = [[UnitDetailsViewController alloc] init];
    unitDetailsViewController.unitIdentifier = [unitsIdentifierCollection objectAtIndex:indexPath.row];
    [self.ownerController.navigationController pushViewController:unitDetailsViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}

- (void)destory {
    [[SMShared current].memory unSubscribeHandler:[DeviceCommandGetUnitsHandler class] for:self];
#ifdef DEBUG
    NSLog(@"[My Devices View] Destoryed.");
#endif
}

@end
