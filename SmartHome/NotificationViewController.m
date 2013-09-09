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
   /*
    if (messageArr == nil) {
        Message *m1 = [Message new];
        m1.text = @"hello!";
        m1.messageType = MessageTypeVerify;
        Message *m2 = [Message new];
        m2.text = @"hello!";
        m2.messageType = MessageTypeVerify;
        Message *m3 = [Message new];
        m3.text = @"hello!";
        m3.messageType = MessageTypeVerify;
        Message *m4 = [Message new];
        m4.text = @"hello!";
        m4.messageType = MessageTypeVerify;
        
        messageArr = [[NSArray alloc] initWithObjects:m1,m2,m3,m4, nil];


    }*/
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
        messageCell = [mes]
    }
    return messageCell;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
