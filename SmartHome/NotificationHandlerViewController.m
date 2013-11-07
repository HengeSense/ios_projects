//
//  NotificationHandlerViewController.m
//  SmartHome
//
//  Created by hadoop user account on 9/09/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NotificationHandlerViewController.h"
#import "UIColor+ExtentionForHexString.h"
#import "LongButton.h"
#import "SMDateFormatter.h"
#import "PlayCameraPicViewController.h"

@interface NotificationHandlerViewController ()

@end

@implementation NotificationHandlerViewController{
    UIView  *view;
    UIImageView *typeMessage;
    NSDictionary *messageTypeDictionary;
}

@synthesize message;

-(id) initWithMessage:(SMNotification *) smNotification{
    self = [super init];
    if (self) {
        if (self.message == nil) {
            self.message = smNotification;
        }
    }
    return self;
    
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

- (void)initDefaults {
    messageTypeDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"cf", @"btn_done.png"),@"CF",NSLocalizedString(@"ms", @"btn_done.png"),@"MS",NSLocalizedString(@"al", @"btn_done.png"),@"AL",NSLocalizedString(@"at", @"btn_done.png"),@"AT", nil];
}

- (void)initUI {
    [super initUI];
    self.topbar.titleLabel.text = [messageTypeDictionary objectForKey:self.message.type];

    view = [[UIView alloc] initWithFrame:CGRectMake(0, self.topbar.frame.size.height+5,self.view.frame.size.width-10 , MESSAGE_CELL_HEIGHT)];
    view.backgroundColor = [UIColor clearColor];
    view.center = CGPointMake(self.view.center.x, view.center.y);
    view.backgroundColor = [UIColor colorWithHexString:@"282E3C"];
    view.layer.cornerRadius = 5;
    
    if (message !=nil) {
        typeMessage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50/2, 39/2)];
        if ([message.type isEqualToString:@"MS"]||[message.type isEqualToString:@"AT"]) {
            typeMessage.image = [UIImage imageNamed:@"icon_message.png"];
        }else if([message.type isEqualToString:@"CF"]){
            typeMessage.image = [UIImage imageNamed:@"icon_validation.png"];
        }else if([message.type isEqualToString:@"AL"]){
            typeMessage.image = [UIImage imageNamed:@"icon_warning"];
        }
        typeMessage.backgroundColor = [UIColor clearColor];
        typeMessage.tag = TYPE_IMAGE_TAG;
        [view addSubview:typeMessage];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 5, 240,MESSAGE_CELL_HEIGHT)];
        textLabel.tag = TEXT_LABEL_TAG;
        UIFont *font = [UIFont systemFontOfSize:14];
        textLabel.textAlignment = NSTextAlignmentLeft;
        textLabel.font = font;
        textLabel.text = [@"    " stringByAppendingString:message.text];
        textLabel.textColor = [UIColor lightTextColor];
        textLabel.numberOfLines = 0;
        CGSize constraint = CGSizeMake(240, 20000.0f);
        CGSize size = [textLabel.text sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        textLabel.frame = CGRectMake(40, 5, size.width, size.height<MESSAGE_CELL_HEIGHT?MESSAGE_CELL_HEIGHT:size.height*2);
        textLabel.backgroundColor = [UIColor clearColor];
        [view addSubview:textLabel];
        
        UILabel *lblTime = [[UILabel alloc]initWithFrame:CGRectMake(40, textLabel.frame.size.height+5+2, 240, 15)];
        lblTime.text = [SMDateFormatter dateToString:message.createTime format:@"yyyy-MM-dd HH:mm:ss"];
        lblTime.backgroundColor = [UIColor clearColor];
        lblTime.textColor = [UIColor lightTextColor];
        lblTime.font = [UIFont systemFontOfSize:12];
        [view addSubview:lblTime];
        
        view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, textLabel.frame.size.height+15+5+8);
        view.tag = CELL_VIEW_TAG;
        [self.view addSubview:view];
        if(message.isWarning && message.data.isCameraData){
            UIButton *btnCheck = [[UIButton alloc] initWithFrame:CGRectMake(5, view.frame.size.height+view.frame.origin.y+5, 152.5, 98/2)];
            [btnCheck setBackgroundImage:[UIImage imageNamed:@"btn_orange.png"] forState:UIControlStateNormal];
            [btnCheck setTitle:NSLocalizedString(@"view_video", @"") forState:UIControlStateNormal];
            [btnCheck addTarget:self action:@selector(btnCheckPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btnCheck];
            UIButton *deleteButton = [[UIButton alloc] initWithFrame:CGRectMake(10+152.5, btnCheck.frame.origin.y, 152.5, 98/2)];
            [deleteButton setTitle:NSLocalizedString(@"delete", @"") forState:UIControlStateNormal];
            [deleteButton addTarget:self action:@selector(deleteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [deleteButton setBackgroundImage:[UIImage imageNamed:@"btn_orange.png"] forState:UIControlStateNormal];
            [self.view addSubview:deleteButton];
        }else if ([message.type isEqualToString:@"MS"]||[message.type isEqualToString:@"AT"]||[message.type isEqualToString:@"AL"]) {
            UIButton *deleteButton = [LongButton buttonWithPoint:CGPointMake(5, view.frame.size.height+view.frame.origin.y+5)];
            [deleteButton setTitle: NSLocalizedString(@"delete", @"") forState:UIControlStateNormal];
            [deleteButton addTarget:self action:@selector(deleteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:deleteButton];
        }else if ([message.type isEqualToString:@"CF"]){
            UIButton *agreeBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, view.frame.size.height+view.frame.origin.y+5, 203/2, 98/2)];
            [agreeBtn setBackgroundImage:[UIImage imageNamed:@"button_cf.png"] forState:UIControlStateNormal];
            [agreeBtn setTitle: NSLocalizedString(@"agree", @"") forState:UIControlStateNormal];
            if(message.hasProcess) agreeBtn.enabled = NO;
            [self.view addSubview:agreeBtn];
            [agreeBtn addTarget:self action:@selector(agreeBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *refuseBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 203/2, 98/2)];
            [refuseBtn setBackgroundImage:[UIImage imageNamed:@"button_cf.png"] forState:UIControlStateNormal];
            refuseBtn.center = CGPointMake(agreeBtn.center.x+agreeBtn.frame.size.width+5, agreeBtn.center.y);
            [refuseBtn setTitle: NSLocalizedString(@"refuse", @"") forState:UIControlStateNormal];
            if(message.hasProcess) refuseBtn.enabled = NO;
            [self.view addSubview:refuseBtn];
            [refuseBtn addTarget:self action:@selector(refuseBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            
            UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 203/2, 98/2)];
            [deleteBtn setBackgroundImage:[UIImage imageNamed:@"button_cf.png"] forState:UIControlStateNormal];
            deleteBtn.center = CGPointMake(refuseBtn.center.x+refuseBtn.frame.size.width+5, refuseBtn.center.y);
            [deleteBtn setTitle: NSLocalizedString(@"delete", @"") forState:UIControlStateNormal];
            [deleteBtn addTarget:self action:@selector(deleteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:deleteBtn];
        }
    }
}

- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnCheckPressed:(UIButton *)sender {
    PlayCameraPicViewController *playCameraPicViewController = [[PlayCameraPicViewController alloc] init];
    playCameraPicViewController.data = self.message.data;
    [self presentViewController:playCameraPicViewController animated:YES completion:nil];
}

- (void)deleteBtnPressed:(UIButton *)sender {
    if ([self.deleteNotificationDelegate respondsToSelector:@selector(didWhenDeleted)]) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"deleting", @"") forType:AlertViewTypeWaitting];
        [[AlertView currentAlertView] alertAutoDisappear:NO  lockView:self.view];

        [self.deleteNotificationDelegate didWhenDeleted];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)agreeBtnPressed:(UIButton *)sender {
    [self sendBindingResult:YES];
    if ([self.cfNotificationDelegate respondsToSelector:@selector(didAgreeOrRefuse:)]) {
        [self.cfNotificationDelegate didAgreeOrRefuse:[NSString stringWithFormat:@" [%@] ", NSLocalizedString(@"agree", @"")]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refuseBtnPressed:(UIButton *)sender {
    [self sendBindingResult:NO];
    if ([self.cfNotificationDelegate respondsToSelector:@selector(didAgreeOrRefuse:)]) {
        [self.cfNotificationDelegate didAgreeOrRefuse:[NSString stringWithFormat:@" [%@] ", NSLocalizedString(@"refuse", @"")]];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendBindingResult:(BOOL)agree {
    DeviceCommandAuthBinding *authBindingCommand = (DeviceCommandAuthBinding *)[CommandFactory commandForType:CommandTypeAuthBindingUnit];
    authBindingCommand.resultID = agree ? 1 : 2;
    authBindingCommand.masterDeviceCode = message.data.masterDeviceCode;
    authBindingCommand.requestDeviceCode = message.data.requestDeviceCode;
    [[SMShared current].deliveryService executeDeviceCommand:authBindingCommand];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
