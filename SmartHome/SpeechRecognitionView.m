//
//  SpeechRecognitionView.m
//  SmartHome
//
//  Created by Zhao yang on 8/7/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "SpeechRecognitionView.h"
#import "MainView.h"

#define WELCOME_VIEW_TAG 3333

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
}

- (void)initUI {
    self.alpha = 0.8f;
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
    btnCloseSelf.backgroundColor = [UIColor whiteColor];
    [btnCloseSelf setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnCloseSelf setTitle:@"close" forState:UIControlStateNormal];
    [btnCloseSelf addTarget:containerView action:@selector(hideSpeechView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnCloseSelf];
    
    
    // add a test button
    
    UIButton *btnTest = [[UIButton alloc] initWithFrame:CGRectMake(0, 320, 60, 25)];
    btnTest.backgroundColor = [UIColor blueColor];
    [btnTest setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btnTest setTitle:@"test" forState:UIControlStateNormal];
    [btnTest addTarget:containerView action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnTest];
}

- (void)test {
    
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


#pragma mark -
#pragma mark table view delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifer = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
        cell.textLabel.text = @"";
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    return cell;
}

@end
