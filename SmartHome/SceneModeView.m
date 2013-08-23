//
//  SceneModeView.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "SceneModeView.h"

#define CELL_HEIGHT 93
#define CELL_WIDTH  624

@implementation SceneModeView{
    UITableView *tblSceneMode;
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
    if(tblSceneMode == nil) {
        tblSceneMode = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbar.bounds.size.height + 5, CELL_WIDTH / 2, self.frame.size.height - self.topbar.bounds.size.height - 5) style:UITableViewStylePlain];
        tblSceneMode.center = CGPointMake(self.center.x, tblSceneMode.center.y);
        tblSceneMode.separatorStyle = UITableViewCellSeparatorStyleNone;
        tblSceneMode.delegate = self;
        tblSceneMode.dataSource = self;
        tblSceneMode.backgroundColor = [UIColor clearColor];
        [self addSubview:tblSceneMode];
    }
}

#pragma mark -
#pragma mark table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 14;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT / 2;
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
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.bounds];
        
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH / 2, CELL_HEIGHT / 2)];
        UIImageView *selectedBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CELL_WIDTH / 2, CELL_HEIGHT / 2)];
        
        backgroundImageView.image = [UIImage imageNamed: [self imageNameForIdentifier:cellIdentifier isSelected:NO] ];
        selectedBackgroundImageView.image = [UIImage imageNamed:[self imageNameForIdentifier:cellIdentifier isSelected:YES]];
        
        [cell.backgroundView addSubview:backgroundImageView];
        [cell.selectedBackgroundView addSubview:selectedBackgroundImageView];
        
        if(indexPath.row != 13) {
            UIImageView *imgSperatorLineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CELL_HEIGHT / 2 - 1, CELL_WIDTH / 2, 1)];
            imgSperatorLineView.image = [UIImage imageNamed:@"line_cell_seperator_main.png"];
            [cell addSubview:imgSperatorLineView];
        }
    }
    
    return cell;
}

- (NSString *)imageNameForIdentifier:(NSString *)identifier isSelected:(BOOL)selected {
    if(identifier == nil) return nil;
    if([@"topCellIdentifier" isEqualToString:identifier]) {
        return [NSString stringWithFormat:@"%@%@.png", @"bg_cell_top", selected ? @"_selected" : @""];
    } else if([@"cellIdentifier" isEqualToString:identifier]) {
        return [NSString stringWithFormat:@"%@%@.png", @"bg_cell_center", selected ? @"_selected" : @""];
    } else if([@"bottomCellIdentifier" isEqualToString:identifier]) {
        return [NSString stringWithFormat:@"%@%@.png", @"bg_cell_footer", selected ? @"_selected" : @""];
    } else {
        return nil;
    }
}

@end
