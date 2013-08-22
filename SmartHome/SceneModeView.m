//
//  SceneModeView.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "SceneModeView.h"

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
        tblSceneMode = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbar.bounds.size.height, self.frame.size.width, self.frame.size.height-self.topbar.bounds.size.height) style:UITableViewStylePlain];
        tblSceneMode.delegate = self;
        tblSceneMode.dataSource = self;
        tblSceneMode.backgroundColor = [UIColor clearColor];
        [self addSubview:tblSceneMode];
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
