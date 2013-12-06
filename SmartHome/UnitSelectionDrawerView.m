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
#import "UIDevice+Extension.h"
#import "ViewsPool.h"
#import "PortalView.h"

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
    
    UIImageView *imgShadow = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 200, 0, 5, self.bounds.size.height)];
    imgShadow.image = [UIImage imageNamed:@"left_shadow"];
    [self addSubview:imgShadow];
    
    tblUnits = [[UITableView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 195, [UIDevice systemVersionIsMoreThanOrEuqal7] ? 20 : 0, 195, self.bounds.size.height) style:UITableViewStylePlain];
    tblUnits.backgroundView = nil;
    tblUnits.backgroundColor = [UIColor clearColor];
    tblUnits.separatorStyle = UITableViewCellSeparatorStyleNone;
    tblUnits.sectionHeaderHeight = 0;
    tblUnits.sectionFooterHeight = 0;
    tblUnits.delegate = self;
    tblUnits.dataSource = self;
    [self addSubview:tblUnits];
}

- (void)setUp {
}

- (void)refresh {
    [units removeAllObjects];
    [units addObjectsFromArray:[SMShared current].memory.units];
    
    // set selection for current unit
    if([SMShared current].memory.currentUnit != nil) {
        NSString *identifier = [SMShared current].memory.currentUnit.identifier;
        int currentUnitIndex = -1;
        for(int i=0; i<units.count; i++) {
            Unit *u = [units objectAtIndex:i];
            if([identifier isEqualToString:u.identifier]) {
                currentUnitIndex = i;
                break;
            }
        }
        [tblUnits reloadData];
        if(currentUnitIndex != -1) {
            [tblUnits selectRowAtIndexPath:[NSIndexPath indexPathForRow:currentUnitIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
        }
    }
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
        cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.backgroundView.backgroundColor = [UIColor colorWithHexString:@"3a3e47"];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"3f434c"];
        cell.textLabel.textColor = [UIColor lightTextColor];
        cell.textLabel.font = [UIFont systemFontOfSize:15.f];
        cell.imageView.image = [UIImage imageNamed:@"unit_little_g"];
    }
    
    Unit *unit = [units objectAtIndex:indexPath.row];
    cell.textLabel.text = unit.name;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 48;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 195, 48)];
    view.backgroundColor = [UIColor colorWithHexString:@"3a3e47"];
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 120, 30)];
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.font = [UIFont systemFontOfSize:16.f];
    lblTitle.text = NSLocalizedString(@"choose_unit", @"");
    lblTitle.textColor = [UIColor lightTextColor];
    [view addSubview:lblTitle];
    
    UIImageView *imgSp = [[UIImageView alloc] initWithFrame:CGRectMake(-10, 46, 195, 2)];
    imgSp.image = [UIImage imageNamed:@"line_right_cell_sp"];
    [view addSubview:imgSp];
    
    return view;
}

#pragma mark -
#pragma mark Table events

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Unit *unit = [units objectAtIndex:indexPath.row];
    
    if([SMShared current].memory.currentUnit != nil && ![unit.identifier isEqualToString:[SMShared current].memory.currentUnit.identifier]) {
        [[SMShared current].memory changeCurrentUnitTo:unit.identifier];
        PortalView *view = (PortalView *)[[ViewsPool sharedPool] viewWithIdentifier:@"portalView"];
        if(view != nil) {
            [view notifyMeCurrentUnitWasChanged];
        }
//        [[SMShared current].deliveryService fireRefreshUnit];
    }
    [self.ownerController showCenterView:YES];
}

@end
