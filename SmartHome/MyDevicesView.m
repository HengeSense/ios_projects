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
        tblUnits = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbar.bounds.size.height + 5, SM_CELL_WIDTH / 2, self.frame.size.height - self.topbar.bounds.size.height - 5) style:UITableViewStylePlain];
        tblUnits.center = CGPointMake(self.center.x, tblUnits.center.y);
        tblUnits.separatorStyle = UITableViewCellSeparatorStyleNone;
        tblUnits.delegate = self;
        tblUnits.dataSource = self;
        tblUnits.backgroundColor = [UIColor clearColor];
        [self addSubview:tblUnits];
    }
    
    if (btnAdd == nil) {
        btnAdd = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width-33/2-10, 0, 33/2, 33/2)];
        [btnAdd setBackgroundImage:[UIImage imageNamed:@"btn_add.png"] forState:UIControlStateNormal];
        btnAdd.center = CGPointMake(btnAdd.center.x, self.topbar.center.y+10);
        [btnAdd addTarget:self action:@selector(btnAddPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.topbar addSubview:btnAdd];
    }
}
#pragma mark-
#pragma mark btn action

-(void) btnAddPressed:(UIButton *) sender{
    UnitsBindingViewController *unitsBindingViewController = [[UnitsBindingViewController alloc] initWithType:TopBarTypeDone];
    [self.ownerController presentViewController:unitsBindingViewController animated:YES completion:nil];
}

#pragma mark -
#pragma mark view service

- (void)notifyViewUpdate {
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
    } else if(indexPath.row == unitsIdentifierCollection.count - 1) {
        cellIdentifier = bottomCellIdentifier;
    } else {
        cellIdentifier = centerCellIdentifier;
    }
    
    SMCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[SMCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 2, 150, 40)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.tag = 999;
        [cell addSubview:titleLabel];
        
        UILabel *detailLabel = [[UILabel alloc] initWithFrame:CGRectMake([UIDevice systemVersionIsMoreThanOrEuqal7] ? 140 : 150, 2, 150, 40)];
        detailLabel.textAlignment = NSTextAlignmentRight;
        detailLabel.textColor = [UIColor darkGrayColor];
        detailLabel.backgroundColor = [UIColor clearColor];
        detailLabel.font = [UIFont systemFontOfSize:16.f];
        detailLabel.tag = 888;
        [cell addSubview:detailLabel];
    }
   
    UILabel *titleLabel = (UILabel *)[cell viewWithTag:999];
    UILabel *detailLabel = (UILabel *)[cell viewWithTag:888];
    
    Unit *unit = [[SMShared current].memory findUnitByIdentifier:[unitsIdentifierCollection objectAtIndex:indexPath.row]];

    if(unit != nil) {
        titleLabel.text = unit.name;
        detailLabel.text = [NSString stringWithFormat:@"%@   ", unit.status];
    }

    if(unitsIdentifierCollection.count == 1) {
        cell.isSingle = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UnitDetailsViewController *unitDetailsViewController = [[UnitDetailsViewController alloc] init];
    unitDetailsViewController.unitIdentifier = [unitsIdentifierCollection objectAtIndex:indexPath.row];
    [self.ownerController.navigationController pushViewController:unitDetailsViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
