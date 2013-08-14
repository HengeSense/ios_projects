//
//  ConversationView.m
//  SmartHome
//
//  Created by Zhao yang on 8/7/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "ConversationView.h"
#import "MainView.h"

#define WELCOME_VIEW_TAG        3333
#define CELL_CONTENT_VIEW_TAG   5555

@implementation ConversationView {
    UIView *containerView;
    UIView *welcomeView;
    UITableView *tblMessages;
    NSMutableArray *messages;
}

@synthesize messageCount;

#pragma mark -
#pragma mark initializations

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andContainerView:(UIView *)cv {
    self = [self initWithFrame:frame];
    if(self) {
        containerView = cv;
        [self initDefaults];
        [self initUI];
    }
    return self;
}

- (void)initDefaults {
    if(messages == nil) {
        messages = [NSMutableArray array];
    } else {
        [messages removeAllObjects];
    }
}

- (void)initUI {
    self.alpha = 1.f;
    self.backgroundColor = [UIColor blackColor];
    
    if(tblMessages == nil) {
        tblMessages = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
        tblMessages.backgroundColor = [UIColor clearColor];
        tblMessages.separatorStyle = UITableViewCellSeparatorStyleNone;
        tblMessages.delegate = self;
        tblMessages.dataSource = self;
        
        [self addSubview:tblMessages];
    }
    
    if(welcomeView == nil) {
        //还需要一个遮罩层 实现动画
        welcomeView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, 320, 70)];
        welcomeView.tag = WELCOME_VIEW_TAG;
        welcomeView.backgroundColor = [UIColor clearColor];
        
        UILabel *lblWelcomeTitle1 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        lblWelcomeTitle1.text = NSLocalizedString(@"welcome.message.line1", @"");
        lblWelcomeTitle1.font = [UIFont boldSystemFontOfSize:25.f];
        lblWelcomeTitle1.textColor = [UIColor whiteColor];
        lblWelcomeTitle1.backgroundColor = [UIColor clearColor];
        [lblWelcomeTitle1 sizeToFit];
        
        UILabel *lblWelcomeTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        lblWelcomeTitle2.text = NSLocalizedString(@"welcome.message.line2", @"");
        lblWelcomeTitle2.font = [UIFont boldSystemFontOfSize:25.f];
        lblWelcomeTitle2.textColor = [UIColor whiteColor];
        lblWelcomeTitle2.backgroundColor = [UIColor clearColor];
        [lblWelcomeTitle2 sizeToFit];
        
        lblWelcomeTitle1.center = CGPointMake(160, 20);
        lblWelcomeTitle2.center = CGPointMake(160, 50);

        [welcomeView addSubview:lblWelcomeTitle1];
        [welcomeView addSubview:lblWelcomeTitle2];
    }

    UIButton *btnCloseSelf = [[UIButton alloc] initWithFrame:CGRectMake(320-60, 320, 60, 25)];
    btnCloseSelf.backgroundColor = [UIColor redColor];
    [btnCloseSelf setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCloseSelf setTitle:@"close" forState:UIControlStateNormal];
    [btnCloseSelf addTarget:containerView action:@selector(hideSpeechView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnCloseSelf];
}

#pragma mark -
#pragma mark public methods

- (void)showWelcomeMessage {
    UIView *view = [self viewWithTag:WELCOME_VIEW_TAG];
    if(view == nil) {
        [self addSubview:welcomeView];
    }
    [UIView animateWithDuration:0.3f
                     animations:^{
                         welcomeView.frame = CGRectMake(0, 0, 320, 70);
                     }
                     completion:^(BOOL finished){
                     }];
}

- (void)hideWelcomeMessage {
    UIView *view = [self viewWithTag:WELCOME_VIEW_TAG];
    if(view != nil) {
        [view removeFromSuperview];
        welcomeView.frame = CGRectMake(0, 200, 320, 70);
    }
}

- (void)addMessage:(ConversationMessage *)message {
    if(message == nil) return;
    if(messages.count == 0) [self hideWelcomeMessage];
    [messages addObject:message];
    [tblMessages beginUpdates];
    NSIndexPath *newMessageIndexPath = [NSIndexPath indexPathForRow:(messages.count - 1) inSection:0];
    [tblMessages insertRowsAtIndexPaths:[NSArray arrayWithObject:newMessageIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
    [tblMessages endUpdates];
    [tblMessages scrollToRowAtIndexPath:newMessageIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

- (void)clearMessages {
    if(messages == nil || messages.count == 0) return;
    [messages removeAllObjects];
    [tblMessages reloadData];
}

#pragma mark -
#pragma mark table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(messages == nil) return 0;
    return messages.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ConversationMessage *message = [messages objectAtIndex:indexPath.row];
    if(message != nil) {
        UIView *messageView = [message viewWithMessage];
        if(messageView != nil) {
            return messageView.frame.size.height + 15;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifer = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UIView *messageView = [cell viewWithTag:CELL_CONTENT_VIEW_TAG];
    if(messageView != nil) {
        [messageView removeFromSuperview];
    }
    ConversationMessage *message = [messages objectAtIndex:indexPath.row];
    if(message != nil) {
        messageView = [message viewWithMessage];
        if(messageView != nil) {
            messageView.tag = CELL_CONTENT_VIEW_TAG;
            [cell addSubview:messageView];
        }
    }
    return cell;
}

#pragma mark -
#pragma mark getter and setters

- (NSUInteger)messageCount {
    if(messages == nil) return 0;
    return messages.count;
}

@end