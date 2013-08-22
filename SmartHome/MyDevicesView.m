//
//  MyDevicesView.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "MyDevicesView.h"
#import "DevicesViewController.h"

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
        tblUnits = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbar.bounds.size.height, self.frame.size.width, self.frame.size.height-self.topbar.bounds.size.height) style:UITableViewStylePlain];
        tblUnits.backgroundColor = [UIColor clearColor];
        tblUnits.dataSource = self;
        tblUnits.delegate = self;
        [self addSubview:tblUnits];
    }
}

#pragma mark -
#pragma mark table view delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

@end
