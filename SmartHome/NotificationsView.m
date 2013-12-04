//
//  NotificationsView.m
//  SmartHome
//
//  Created by Zhao yang on 12/3/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NotificationsView.h"
#import "NotificationsFileManager.h"

@implementation NotificationsView {
    UITableView *tblNotifications;
    NSMutableArray *messageArr;
    NSMutableArray *modifyArr;
    NSMutableArray *deleteArr;
    NSIndexPath    *curIndexPath;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)initDefaults {
    [super initDefaults];
}

- (void)initUI {
    [super initUI];
    if(tblNotifications == nil) {
        tblNotifications = [[UITableView alloc] initWithFrame:CGRectMake(0, self.topbar.frame.size.height + 5, self.frame.size.width, self.frame.size.height - self.topbar.frame.size.height - 5) style:UITableViewStylePlain];
        tblNotifications.dataSource = self;
        tblNotifications.delegate = self;
        tblNotifications.backgroundColor = [UIColor clearColor];
        tblNotifications.separatorStyle= UITableViewCellSelectionStyleNone;
        [self addSubview:tblNotifications];
    }
    self.topbar.titleLabel.text = NSLocalizedString(@"notification_manager.title", @"");
}

- (void)setUp {
    [[SMShared current].memory subscribeHandler:[DeviceCommandGetNotificationsHandler class] for:self];
}

- (void)loadNotifications {
    messageArr = [NSMutableArray arrayWithArray:[[NotificationsFileManager fileManager] readFromDisk]];
    
    if (messageArr && messageArr.count > 0) {
        for (SMNotification *notification in messageArr) {
            notification.hasRead = YES;
        }
    }
    [[NotificationsFileManager fileManager] update:messageArr deleteList:nil];
    
    [self sort:messageArr ascending:NO];
    
    if (modifyArr == nil) {
        modifyArr =[NSMutableArray array];
    }
    
    if (deleteArr == nil) {
        deleteArr = [NSMutableArray array];
    }
    
    [tblNotifications reloadData];
}

- (void)notifyViewUpdate {
    [super notifyViewUpdate];
    [self loadNotifications];
}

- (void)didAgreeOrRefuse:(NSString *)operation {
    if (operation == nil) return;
    SMNotification *curMessage = [messageArr objectAtIndex:curIndexPath.row];
    curMessage.text = [curMessage.text stringByAppendingString:NSLocalizedString(operation, @"")];
    curMessage.hasProcess = YES;
    [modifyArr addObject:curMessage];
    [tblNotifications reloadData];
    [self saveNotificationsToDisk];
}

- (void)didWhenDeleted {
    [deleteArr addObject:[messageArr objectAtIndex:curIndexPath.row]];
    [messageArr removeObjectAtIndex:curIndexPath.row];
    [tblNotifications reloadData];
    [self saveNotificationsToDisk];
    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"delete_success", @"") forType:AlertViewTypeSuccess];
    [[AlertView currentAlertView] delayDismissAlertView];
}

- (void)saveNotificationsToDisk {
    [[NotificationsFileManager fileManager] update:modifyArr deleteList:deleteArr];
}

- (void)sort:(NSMutableArray *) arr ascending:(BOOL) ascending{
    if (!arr||arr.count == 0) {
        return;
    }
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:ascending];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [arr sortUsingDescriptors:sortDescriptors];
}

#pragma mark -
#pragma mark Get notifications handler

- (void)notifyUpdateNotifications {
    if(self.isActive) {
        [self loadNotifications];
    }
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
    return MESSAGE_CELL_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    curIndexPath = indexPath;
    SMNotification *notificaion = [messageArr objectAtIndex:indexPath.row];
    NotificationHandlerViewController *handlerViewController = [[NotificationHandlerViewController alloc] initWithMessage:notificaion];
    handlerViewController.cfNotificationDelegate = self;
    handlerViewController.deleteNotificationDelegate =self;
    [self.ownerController.navigationController pushViewController:handlerViewController animated:YES];
}

#pragma mark -
#pragma mark Destory

- (void)destory {
    [[SMShared current].memory unSubscribeHandler:[DeviceCommandGetNotificationsHandler class] for:self];
}

@end
