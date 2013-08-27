//
//  MySettingsView.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "MySettingsView.h"
#import "AlertView.h"
#import "SMCell.h"

@implementation MySettingsView {
    UITableView *tblSettings;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)initDefaults {
    [super initDefaults];
}

- (void)initUI {
    [super initUI];
    if(tblSettings == nil) {
        tblSettings = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbar.bounds.size.height + 5, SM_CELL_WIDTH / 2, self.bounds.size.height - self.topbar.bounds.size.height - 5) style:UITableViewStylePlain];
        tblSettings.separatorStyle = UITableViewCellSeparatorStyleNone;
        tblSettings.center = CGPointMake(self.center.x, tblSettings.center.y);
        tblSettings.backgroundColor = [UIColor clearColor];
        tblSettings.dataSource = self;
        tblSettings.delegate = self;
        [self addSubview:tblSettings];
    }
}

#pragma mark -
#pragma mark table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
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
    } else if(indexPath.row == 3) {
        cellIdentifier = bottomCellIdentifier;
    } else {
        cellIdentifier = centerCellIdentifier;
    }
    
    SMCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[SMCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = NSLocalizedString(@"push_settings", @"");
            break;
        case 1:
            cell.textLabel.text = NSLocalizedString(@"account_logout", @"");
            break;
        case 2:
            cell.textLabel.text = NSLocalizedString(@"feed_back", @"");
            break;
        case 3:
            cell.textLabel.text = NSLocalizedString(@"about_us", @"");
            break;
        default:
            break;
    }
    
    return cell;
}

@end
