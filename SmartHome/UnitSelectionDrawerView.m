//
//  UnitSelectionDrawerView.m
//  SmartHome
//
//  Created by Zhao yang on 12/2/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "UnitSelectionDrawerView.h"
#import "SMShared.h"
#import "UIColor+ExtentionForHexString.h"

@implementation UnitSelectionDrawerView {
    UITableView *tblUnits;
    NSMutableArray *units;
}

@synthesize ownerController;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame owner:(MainViewController *)owner
{
    self = [super initWithFrame:frame];
    if (self) {
        self.ownerController = owner;
        [self initDefaults];
        [self initUI];
        [self setUp];
    }
    return self;
}

- (void)initDefaults {
    units = [NSMutableArray array];
}

- (void)initUI {
    self.backgroundColor = [UIColor colorWithHexString:@"3a3e47"];
    tblUnits = [[UITableView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 180, 0, 180, [UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    tblUnits.backgroundView = nil;
    tblUnits.backgroundColor = [UIColor clearColor];
    tblUnits.separatorStyle = UITableViewCellSeparatorStyleNone;
    tblUnits.delegate = self;
    tblUnits.dataSource = self;
    [self addSubview:tblUnits];
}

- (void)setUp {
    [self subscribeEvents];
    [self notifyUnitsWasUpdate];
}

- (void)subscribeEvents {
    [[SMShared current].memory subscribeHandler:[DeviceCommandGetUnitsHandler class] for:self];
}

- (void)unSubscribeEvents {
    [[SMShared current].memory unSubscribeHandler:[DeviceCommandGetUnitsHandler class] for:self];
}

#pragma mark -
#pragma makk Table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return units.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:13.f];
    }
    
    Unit *unit = [units objectAtIndex:indexPath.row];
    cell.textLabel.text = unit.name;
    return cell;
}

#pragma mark -
#pragma mark Table events

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Unit *unit = [units objectAtIndex:indexPath.row];
    NSLog(unit.name);
    
    [self.ownerController showCenterView:YES];
}

#pragma mark -
#pragma mark Get units handler delegate

- (void)notifyUnitsWasUpdate {
    NSLog(@" dsfojsdoi  update ....");
    [units removeAllObjects];
    [units addObjectsFromArray:[SMShared current].memory.units];
    [tblUnits reloadData];
}

@end
