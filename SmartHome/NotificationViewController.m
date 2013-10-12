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

- (id)initFrom:(MainView *)where{
    self = [super init];
    if (self) {
        if (messageArr == nil) {
            messageArr = [NSMutableArray arrayWithArray:[[[NotificationsFileManager alloc] init] readFromDisk]];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark initializations

- (void)initDefaults {
    [super initDefaults];
    if (messageArr&&messageArr.count>0) {
        for (SMNotification *notification in messageArr) {
            notification.hasRead = YES;
        }
        
    }
    
    if (modifyArr == nil) {
        modifyArr =[NSMutableArray arrayWithArray:messageArr];
    }
    if (deleteArr == nil) {
        deleteArr = [NSMutableArray new];
    }
    [self saveNotificationsToDisk];
    [modifyArr removeAllObjects];
    [self sort:messageArr ascending:NO];
}

- (void)initUI {
    [super initUI];
    if(messageTable == nil) {
        messageTable = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbar.frame.size.height, self.view.frame.size.width,self.view.frame.size.height-self.topbar.frame.size.height) style:UITableViewStylePlain];
        messageTable.dataSource = self;
        messageTable.delegate = self;
        messageTable.backgroundColor = [UIColor clearColor];
        messageTable.separatorStyle= UITableViewCellSelectionStyleNone;
        [self.view addSubview:messageTable];
    }
    self.topbar.titleLabel.text = NSLocalizedString(@"notification_manager.title", @"");
    [self.topbar.leftButton addTarget:self action:@selector(updateMainView) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark -
#pragma mark services

- (void)updateMainView {
    if(mainView) {
        [mainView notifyViewUpdate];
    }
}

- (void)didAgreeOrRefuse:(NSString *)operation {
    if (operation == nil) return;
    SMNotification *curMessage = [messageArr objectAtIndex:curIndexPath.row];
    curMessage.text = [curMessage.text stringByAppendingString:NSLocalizedString(operation, @"")];
    curMessage.hasProcess = YES;
    [modifyArr addObject:curMessage];
    [messageTable reloadData];
    [self saveNotificationsToDisk];
}

- (void)didWhenDeleted {
    [deleteArr addObject:[messageArr objectAtIndex:curIndexPath.row]];
    [messageArr removeObjectAtIndex:curIndexPath.row];
    [messageTable reloadData];
    [self saveNotificationsToDisk];
    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"delete_success", @"") forType:AlertViewTypeSuccess];
    [[AlertView currentAlertView] delayDismissAlertView];
}

- (void)saveNotificationsToDisk {
    NotificationsFileManager *fileManager = [[NotificationsFileManager alloc] init];
    [fileManager update:modifyArr deleteList:deleteArr];
}
- (void)sort:(NSArray *) arr ascending:(BOOL) ascending{
    if (!arr||arr.count == 0) {
        return;
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"creatTime" ascending:ascending];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [arr sortedArrayUsingDescriptors:sortDescriptors];
}
#pragma mark -
#pragma mark table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return messageArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell *messageCell = nil;
    SMNotification *notification = [messageArr objectAtIndex:indexPath.row];
    static NSString *messageIdentifier = @"messageCellIdentifier";
    messageCell = [tableView dequeueReusableCellWithIdentifier:messageIdentifier];
    if (messageCell == nil) {
        messageCell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:messageIdentifier];
        messageCell.backgroundColor = [UIColor clearColor];
    }
    [messageCell loadWithMessage:notification];

    return messageCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return  MESSAGE_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    curIndexPath = indexPath;
    SMNotification *notificaion = [messageArr objectAtIndex:indexPath.row];
    NotificationHandlerViewController *handlerViewController = [[NotificationHandlerViewController alloc] initWithMessage:notificaion];
    handlerViewController.cfNotificationDelegate = self;
    handlerViewController.deleteNotificationDelegate =self;
    [self.navigationController pushViewController:handlerViewController animated:YES];
}

@end
