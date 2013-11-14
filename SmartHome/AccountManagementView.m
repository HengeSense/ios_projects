//
//  AccountManagementView.m
//  SmartHome
//
//  Created by Zhao yang on 11/14/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "AccountManagementView.h"

@implementation AccountManagementView{
    UITableView *tblUnits;
    NSArray *unitsIdentifierCollection;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initUI];
    }
    return self;
}
- (void)initDefaults{
    [super initDefaults];
}
- (void)initUI{
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
    
    [[SMShared current].memory subscribeHandler:[DeviceCommandGetUnitsHandler class] for:self];

    
    
}

#pragma mark
#pragma mark- table delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return unitsIdentifierCollection == nil ? 0 : unitsIdentifierCollection.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SM_CELL_HEIGHT/2;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *topCellIdentifier = @"topCellIdentifier";
    static NSString *centerCellIdentifier = @"cellIdentifier";
    static NSString *bottomCellIdentifier = @"bottomCellIdentifier";
    static NSString *singleCellIdentifier = @"singleCellIdentifier";
    
    NSString *cellIdentifier;
    if(indexPath.row == 0 && unitsIdentifierCollection.count == 1) {
        cellIdentifier = singleCellIdentifier;
    } else if(indexPath.row == 0) {
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
        detailLabel.text = [NSString stringWithFormat:@"%@   ", [NSString isBlank:unit.status] ? NSLocalizedString(@"online", @"") : unit.status];
    }
    
    if(unitsIdentifierCollection.count == 1) {
        cell.isSingle = YES;
    }
    
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    return;
}

#pragma mark
#pragma mark- command delegate

- (void)notifyUnitsWasUpdate {
    [self notifyViewUpdate];
}

- (void)notifyViewUpdate {
    unitsIdentifierCollection = [[SMShared current].memory allUnitsIdentifierAsArray];
    [tblUnits reloadData];
}


- (void)destory {
    [[SMShared current].memory unSubscribeHandler:[DeviceCommandGetUnitsHandler class] for:self];
#ifdef DEBUG
    NSLog(@"[My Devices View] Destoryed.");
#endif
}


@end
