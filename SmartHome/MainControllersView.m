//
//  DevicesView.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "MainControllersView.h"

@implementation MainControllersView{
    UITableView *mainTableView;
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
//    [self ];
//    self.backgroundColor = [UIColor lightGrayColor];
//    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 25)];
//    lbl.text = @"主控列表页面";
//    lbl.center = CGPointMake(160, 240);
//    [self addSubview:lbl];
    mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.frame.size.width, self.frame.size.height-44) style:UITableViewStylePlain];
    [self addSubview:mainTableView];
    mainTableView.dataSource = self;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:mainTableView]) {
        return 5;
    }
    return 3;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    if([tableView isEqual:mainTableView]){
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mycells"];
        }
        cell.textLabel.text = [NSString stringWithFormat:@"主控%ld",(long)indexPath.row];
        
    }
    return cell;
}
@end
