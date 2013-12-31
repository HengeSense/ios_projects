//
//  NotificationsView.m
//  SmartHome
//
//  Created by Zhao yang on 12/3/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NotificationsView.h"
#import "NotificationsFileManager.h"
#import "ViewsPool.h"
#import "PortalView.h"
#import "XXEventSubscriptionPublisher.h"
#import "XXEventNameFilter.h"
#import "EventNameContants.h"

@implementation NotificationsView {
    UITableView *tblNotifications;
    NSMutableArray *messageArr;
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
    XXEventSubscription *subscription = [[XXEventSubscription alloc] initWithSubscriber:self eventFilter:[[XXEventNameFilter alloc] initWithSupportedEventName:EventNotificationsFileUpdated]];
    subscription.notifyMustInMainThread = YES;
    [[XXEventSubscriptionPublisher defaultPublisher] subscribeFor:subscription];
}

- (void)loadNotifications {
    messageArr = [NSMutableArray arrayWithArray:[[NotificationsFileManager fileManager] readFromDisk]];
    if (messageArr && messageArr.count > 0) {
        for (SMNotification *notification in messageArr) {
            notification.hasRead = YES;
        }
    }
    [self sort:messageArr ascending:NO];
    [[NotificationsFileManager fileManager] update:messageArr deleteList:nil];
    [tblNotifications reloadData];
    
    PortalView *portalView = (PortalView *)[[ViewsPool sharedPool] viewWithIdentifier:@"portalView"];
    if(portalView != nil && [portalView respondsToSelector:@selector(smNotificationsWasUpdated)]) {
        [portalView updateNotifications];
    }
}

- (void)viewBecomeActive {
    [super viewBecomeActive];
    [self loadNotifications];
}

- (void)sort:(NSMutableArray *)notis ascending:(BOOL)ascending {
    if (notis == nil || notis.count == 0) return;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"createTime" ascending:ascending];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    [notis sortUsingDescriptors:sortDescriptors];
}

- (void)xxEventPublisherNotifyWithEvent:(XXEvent *)event {
    [self updateNotifications];
}

- (NSString *)xxEventSubscriberIdentifier {
    return @"notificationsViewSubscriber";
}

#pragma mark -
#pragma mark Get notifications handler

- (void)updateNotifications {
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
    SMNotification *notificaion = [messageArr objectAtIndex:indexPath.row];
    NotificationDetailsViewController *notificationDetailsViewController = [[NotificationDetailsViewController alloc] initWithNotification:notificaion];
    notificationDetailsViewController.delegate = self;
    [self.ownerController.navigationController pushViewController:notificationDetailsViewController animated:YES];
}

#pragma mark -
#pragma mark SM Notification Delegate

- (void)smNotificationsWasUpdated {
    messageArr = [NSMutableArray arrayWithArray:[[NotificationsFileManager fileManager] readFromDisk]];
    [self sort:messageArr ascending:NO];
    [tblNotifications reloadData];
}

#pragma mark -
#pragma mark Destory

- (void)destory {
    [[XXEventSubscriptionPublisher defaultPublisher] unSubscribeForSubscriber:self];
}

@end
