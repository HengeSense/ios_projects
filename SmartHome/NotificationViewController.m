//
//  NotificationViewController.m
//  SmartHome
//
//  Created by Zhao yang on 8/14/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationsFileManager.h"
@interface NotificationViewController ()

@end

@implementation NotificationViewController{
    UITableView *messageTable;
    NSMutableArray *messageArr;
    NSMutableArray *modifyArr;
    NSMutableArray *deleteArr;
    NSIndexPath *curIndexPath;
    MainView *mainView;
}
-(id) initWithNotifications:(NSArray *)notifications from:(MainView *)where{
    self = [super init];
    if (self) {
        if (messageArr == nil&& notifications!=nil) {
            messageArr = [NSMutableArray arrayWithArray: notifications];
        }
        if (mainView == nil) {
            mainView = where;
        }
    }
    return  self;
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
    for (SMNotification *notification in messageArr) {
        notification.hasRead = YES;
    }
    
    if (modifyArr == nil) {
        modifyArr =[NSMutableArray new];
    }
    if (deleteArr == nil) {
        deleteArr = [NSMutableArray new];
    }
}
-(void)initUI{
    [super initUI];
//    if (messageArr == nil) {
//        SMNotification *s1 = [SMNotification new];
//        s1.text = @"dsdsadadedda dsad sddddddd dsda dsd adsd asdefsdf fgfg dfE D SDAFF";
//        s1.type = @"MS";
//        SMNotification *s2 = [SMNotification new];
//        s2.text = @"dsdsadadedda dsad sddddddd dsda dsd adsd asdefsdf fgfg dfE D SDAFF";
//        s2.type = @"CF";
//        SMNotification *s3 = [SMNotification new];
//        s3.text = @"dsdsadadedda dsad sddddddd dsda dsd adsd asdefsdf fgfg dfE D SDAFFeeeeeeeeeeeee                         eeee                                                           eeeeeeeeeeeeeeeeeeeeeeee           eeeee                eeeee    eeeeeeeeeeee                                 eeeeeee            eee  eeeee         eeeee         eeeeee           eeeeeeeeeeeee       2212121121221212121212121212121212121212121121212212121eof";
//        s3.type = @"AL";
//        
//        messageArr = [[NSArray alloc] initWithObjects:s1,s2,s3, nil];
//    }
    
    if (messageTable == nil) {
        messageTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbar.frame.size.height, self.view.frame.size.width,self.view.frame.size.height-self.topbar.frame.size.height) style:UITableViewStylePlain];
        messageTable.dataSource = self;
        messageTable.delegate = self;
        messageTable.backgroundColor = [UIColor clearColor];
        messageTable.separatorStyle= UITableViewCellSelectionStyleNone;
        [self.view addSubview:messageTable];
    }
    self.topbar.titleLabel.text = NSLocalizedString(@"notification.manager", @"");
    [self.topbar.leftButton addTarget:self action:@selector(updateMainView) forControlEvents:UIControlEventTouchUpInside];
}
-(void) updateMainView{
    NSLog(@"updataMianView");
    if (mainView) {
        [mainView notifyViewUpdate];
    }
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return messageArr.count;
}
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageCell *messageCell = nil;
    SMNotification *notification = [messageArr objectAtIndex:indexPath.row];
    static NSString *messageIdentifier = @"messageCellIdentifier";
    messageCell = [tableView dequeueReusableCellWithIdentifier:messageIdentifier];
    if (messageCell == nil) {
        messageCell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:messageIdentifier];
    }
    [messageCell loadWithMessage:notification];

    return messageCell;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  MESSAGE_CELL_HEIGHT;
}
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    curIndexPath = indexPath;
    SMNotification *notificaion = [messageArr objectAtIndex:indexPath.row];
    NotificationHandlerViewController *handlerViewController = [[NotificationHandlerViewController alloc] initWithMessage:notificaion];
    handlerViewController.cfNotificationDelegate = self;
    handlerViewController.deleteNotificationDelegate =self;
    [self.navigationController pushViewController:handlerViewController animated:YES];
}
-(void) didAgreeOrRefuse:(NSString *)operation{
    if (operation == nil) return;
    SMNotification *curMessage = [messageArr objectAtIndex:curIndexPath.row];
    curMessage.text = [curMessage.text stringByAppendingString:NSLocalizedString(operation, @"")];
    curMessage.hasProcess = YES;
    [modifyArr addObject:curMessage];
    [messageTable reloadData];
    
}
-(void) didWhenDeleted{
    [deleteArr addObject:[messageArr objectAtIndex:curIndexPath.row]];
    [messageArr removeObjectAtIndex:curIndexPath.row];
    [messageTable reloadData];
    [self saveNotificationsToDisk];
    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"delete.success", @"") forType:AlertViewTypeSuccess];
    [[AlertView currentAlertView] delayDismissAlertView];
    
}
-(void) saveNotificationsToDisk{
     NotificationsFileManager *fileManager = [[NotificationsFileManager alloc] init];
    [fileManager update:modifyArr deleteList:deleteArr];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
