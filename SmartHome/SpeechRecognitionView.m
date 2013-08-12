//
//  SpeechRecognitionView.m
//  SmartHome
//
//  Created by Zhao yang on 8/7/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "SpeechRecognitionView.h"
#import "MainView.h"

#define WELCOME_VIEW_TAG        3333
#define CELL_CONTENT_VIEW_TAG   5555

@implementation SpeechRecognitionView {
    UIView *containerView;
    UIView *welcomeView;
    
    
    UITableView *tblSpeech;
    NSMutableArray *messages;
}

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
    
    //add some test messages
    SpeechViewTextMessage *msg1 = [[SpeechViewTextMessage alloc] init];
    msg1.messageOwner = MESSAGE_OWNER_THEIRS;
    msg1.textMessage = @"这是测试消息一二三四五六七八a";
    
    SpeechViewTextMessage *msg11 = [[SpeechViewTextMessage alloc] init];
    msg11.messageOwner = MESSAGE_OWNER_MINE;
    msg11.textMessage = @"你好,给大爷我跳个舞~";
    
    SpeechViewTextMessage *msg2 = [[SpeechViewTextMessage alloc] init];
    msg2.messageOwner = MESSAGE_OWNER_THEIRS;
    msg2.textMessage = @"你好,空调已经打开,即将进入爆炸模式,请离开你的房间,你的空调将于2分钟发生核爆  请速度离开.";
    
    SpeechViewTextMessage *msg12 = [[SpeechViewTextMessage alloc] init];
    msg12.messageOwner = MESSAGE_OWNER_MINE;
    msg12.textMessage = @"春眠不觉晓,处处闻啼鸟,夜来风雨声,花落知多少.";
    
    SpeechViewTextMessage *msg3 = [[SpeechViewTextMessage alloc] init];
    msg3.messageOwner = MESSAGE_OWNER_THEIRS;
    msg3.textMessage = @"空调已经发生核爆,已造成1000W人口死亡,根据检测  您已经死亡,手机已进入幽灵模式, test test test, 情景模式中选择设备列表  情景模式温度时间设置  情景模式语音标签  扫主控二维码货手动输入二维码  撒是滴哦房间噢is的就是的哦if奖哦 测试失败~!  死了....  ok wifi 挂!";
    
    [self addMessage:msg1];
    [self addMessage:msg11];
    [self addMessage:msg2];
    [self addMessage:msg12];
    [self addMessage:msg3];
}

- (void)initUI {
    self.alpha = 1.f;
    self.backgroundColor = [UIColor blackColor];
    
    if(tblSpeech == nil) {
        
        tblSpeech = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
        tblSpeech.backgroundColor = [UIColor clearColor];
//        tblSpeech.backgroundView = [[UIView alloc] initWithFrame:tblSpeech.frame];
//        tblSpeech.backgroundView.backgroundColor = [UIColor clearColor];
        tblSpeech.separatorStyle = UITableViewCellSeparatorStyleNone;
        tblSpeech.delegate = self;
        tblSpeech.dataSource = self;
        
        [self addSubview:tblSpeech];
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
        
        //need in a button
        [self addSubview:welcomeView];
    }

    UIButton *btnCloseSelf = [[UIButton alloc] initWithFrame:CGRectMake(320-60, 320, 60, 25)];
    btnCloseSelf.backgroundColor = [UIColor redColor];
    [btnCloseSelf setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCloseSelf setTitle:@"close" forState:UIControlStateNormal];
    [btnCloseSelf addTarget:containerView action:@selector(hideSpeechView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnCloseSelf];
    
    
    // add a test button
    
    UIButton *btnTest = [[UIButton alloc] initWithFrame:CGRectMake(0, 320, 60, 25)];
    btnTest.backgroundColor = [UIColor blueColor];
    [btnTest setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnTest setTitle:@"test" forState:UIControlStateNormal];
    [btnTest addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnTest];
}

- (void)test {
    SpeechViewTextMessage *msg12 = [[SpeechViewTextMessage alloc] init];
    msg12.messageOwner = MESSAGE_OWNER_MINE;
    msg12.textMessage = @"速度关机";
    [self addMessage:msg12];
}

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

#pragma mark -
#pragma mark events

- (void)addMessage:(SpeechViewMessage *)message {
    if(message == nil) return;
    [messages addObject:message];
    [tblSpeech beginUpdates];
    NSIndexPath *newMessageIndexPath = [NSIndexPath indexPathForRow:(messages.count - 1) inSection:0];
    [tblSpeech insertRowsAtIndexPaths:[NSArray arrayWithObject:newMessageIndexPath] withRowAnimation:UITableViewRowAnimationBottom];
    [tblSpeech endUpdates];
    [tblSpeech scrollToRowAtIndexPath:newMessageIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
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
    SpeechViewMessage *message = [messages objectAtIndex:indexPath.row];
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
    SpeechViewMessage *message = [messages objectAtIndex:indexPath.row];
    if(message != nil) {
        messageView = [message viewWithMessage];
        if(messageView != nil) {
            messageView.tag = CELL_CONTENT_VIEW_TAG;
            [cell addSubview:messageView];
        }
    }
    return cell;
}

@end
