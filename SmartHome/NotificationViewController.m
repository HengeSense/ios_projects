//
//  NotificationViewController.m
//  SmartHome
//
//  Created by Zhao yang on 8/14/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NotificationViewController.h"

@interface NotificationViewController ()

@end

@implementation NotificationViewController{
    UITableView *messageTable;
    NSArray *messageArr;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}
-(void)initDefaults{
    [super initDefaults];
}
-(void)initUI{
    [super initUI];
    if (messageArr == nil) {
        SMNotification *s1 = [SMNotification new];
        s1.text = @"dsdsadadedda dsad sddddddd dsda dsd adsd asdefsdf fgfg dfE D SDAFF";
        s1.type = @"MS";
        SMNotification *s2 = [SMNotification new];
        s2.text = @"dsdsadadedda dsad sddddddd dsda dsd adsd asdefsdf fgfg dfE D SDAFF";
        s2.type = @"CF";
        SMNotification *s3 = [SMNotification new];
        s3.text = @"dsdsadadedda dsad sddddddd dsda dsd adsd asdefsdf fgfg dfE D SDAFF";
        s3.type = @"AL";
        
        messageArr = [[NSArray alloc] initWithObjects:s1,s2,s3, nil];
    }
    
    if (messageTable == nil) {
        messageTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
        messageTable.dataSource = self;
        messageTable.delegate = self;
        messageTable.backgroundColor = [UIColor clearColor];
        messageTable.separatorColor = [UIColor blackColor];
        [self.view addSubview:messageTable];
    }
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return messageArr.count;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *messageCell = nil;
    static NSString *messageIdentifier = @"messageCellIdentifier";
    messageCell = [tableView dequeueReusableCellWithIdentifier:messageIdentifier];
    if (messageCell == nil) {
        messageCell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:messageIdentifier ofMessage:[messageArr objectAtIndex:indexPath.row]];
    }
    return messageCell;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  MESSAGE_CELL_HEIGHT;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
