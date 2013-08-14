//
//  SceneModeView.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "SceneModeView.h"

@implementation SceneModeView{
    UITableView *sceneTableView;
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
    
//    self.backgroundColor = [UIColor lightGrayColor];
//    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 25)];
//    lbl.text = @"情景模式页面";
//    lbl.center = CGPointMake(160, 240);
   // [self addSubview:lbl];
    sceneTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.frame.size.width, self.frame.size.height-44) style:UITableViewStylePlain];
    [self addSubview:sceneTableView];
    sceneTableView.dataSource = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
       return 3;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifer";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"睡觉%ld",(long)indexPath.row];
    
    UIButton *deviceCount = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                             
    deviceCount.frame = CGRectMake(0, 0, 150, 25);
                             
                             
    
    [deviceCount setTitle:@"设备数 5" forState:UIControlStateNormal];
    cell.accessoryView = deviceCount;
    return cell;
}

@end
