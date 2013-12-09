//
//  NotificationDetailsViewController.m
//  SmartHome
//
//  Created by hadoop user account on 9/09/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "NotificationDetailsViewController.h"
#import "UIColor+ExtentionForHexString.h"
#import "LongButton.h"
#import "SMButton.h"
#import "SMDateFormatter.h"
#import "PlayCameraPicViewController.h"
#import "NotificationsFileManager.h"

@interface NotificationDetailsViewController ()

@end

@implementation NotificationDetailsViewController {

}

@synthesize notification = _notification_;
@synthesize delegate;

- (id)initWithNotification:(SMNotification *)notification {
    self = [super init];
    if (self) {
        _notification_ = notification;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)initDefaults {
}

- (void)initUI {
    [super initUI];
    
    if(self.notification == nil) return;
    
    self.topbar.titleLabel.text = self.notification.typeName;

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.topbar.frame.size.height+5,self.view.frame.size.width-10 , MESSAGE_CELL_HEIGHT)];
    view.backgroundColor = [UIColor clearColor];
    view.center = CGPointMake(self.view.center.x, view.center.y);
    view.backgroundColor = [UIColor colorWithHexString:@"282E3C"];
    view.layer.cornerRadius = 5;

    UIImageView *typeMessage = typeMessage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 50/2, 39/2)];
    if([self.notification.type isEqualToString:@"MS"] || [self.notification.type isEqualToString:@"AT"]) {
        typeMessage.image = [UIImage imageNamed:@"icon_message.png"];
    } else if([self.notification.type isEqualToString:@"CF"]) {
        typeMessage.image = [UIImage imageNamed:@"icon_validation.png"];
    } else if([self.notification.type isEqualToString:@"AL"]) {
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
    textLabel.text = [@"    " stringByAppendingString:self.notification.text];
    textLabel.textColor = [UIColor lightTextColor];
    textLabel.numberOfLines = 0;
    CGSize constraint = CGSizeMake(240, 20000.0f);
    CGSize size = [textLabel.text sizeWithFont:font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    
    textLabel.frame = CGRectMake(40, 5, size.width, size.height<MESSAGE_CELL_HEIGHT?MESSAGE_CELL_HEIGHT:size.height*2);
    textLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:textLabel];
    
    UILabel *lblTime = [[UILabel alloc]initWithFrame:CGRectMake(40, textLabel.frame.size.height+5+2, 240, 15)];
    lblTime.text = [SMDateFormatter dateToString:self.notification.createTime format:@"yyyy-MM-dd HH:mm:ss"];
    lblTime.backgroundColor = [UIColor clearColor];
    lblTime.textColor = [UIColor lightTextColor];
    lblTime.font = [UIFont systemFontOfSize:12];
    [view addSubview:lblTime];
    
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, textLabel.frame.size.height+15+5+8);
    view.tag = CELL_VIEW_TAG;
    [self.view addSubview:view];
    if(self.notification.isWarning && self.notification.data.isCameraData) {
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
    } else if([self.notification.type isEqualToString:@"MS"] || [self.notification.type isEqualToString:@"AT"] || [self.notification.type isEqualToString:@"AL"]) {
        UIButton *deleteButton = [LongButton buttonWithPoint:CGPointMake(5, view.frame.size.height+view.frame.origin.y+5)];
        [deleteButton setTitle: NSLocalizedString(@"delete", @"") forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:deleteButton];
    } else if ([self.notification.type isEqualToString:@"CF"]) {
        SMButton *btnAgree = [[SMButton alloc] initWithFrame:CGRectMake(5, view.frame.size.height+view.frame.origin.y+5, 203/2, 98/2)];
        [btnAgree setBackgroundImage:[UIImage imageNamed:@"button_cf.png"] forState:UIControlStateNormal];
        [btnAgree setTitle: NSLocalizedString(@"agree", @"") forState:UIControlStateNormal];
        btnAgree.identifier = @"btnAgree";
        if(self.notification.hasProcess) btnAgree.enabled = NO;
        [self.view addSubview:btnAgree];
        [btnAgree addTarget:self action:@selector(btnAgreeOrRefusePressed:) forControlEvents:UIControlEventTouchUpInside];
        
        SMButton *btnRefuse = [[SMButton alloc] initWithFrame:CGRectMake(0, 0, 203/2, 98/2)];
        [btnRefuse setBackgroundImage:[UIImage imageNamed:@"button_cf.png"] forState:UIControlStateNormal];
        btnRefuse.identifier = @"btnRefuse";
        btnRefuse.center = CGPointMake(btnAgree.center.x+btnAgree.frame.size.width+5, btnAgree.center.y);
        [btnRefuse setTitle: NSLocalizedString(@"refuse", @"") forState:UIControlStateNormal];
        if(self.notification.hasProcess) btnRefuse.enabled = NO;
        [self.view addSubview:btnRefuse];
        [btnRefuse addTarget:self action:@selector(btnAgreeOrRefusePressed:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *btnDelete = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 203/2, 98/2)];
        [btnDelete setBackgroundImage:[UIImage imageNamed:@"button_cf.png"] forState:UIControlStateNormal];
        btnDelete.center = CGPointMake(btnRefuse.center.x+btnRefuse.frame.size.width+5, btnRefuse.center.y);
        [btnDelete setTitle: NSLocalizedString(@"delete", @"") forState:UIControlStateNormal];
        [btnDelete addTarget:self action:@selector(deleteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnDelete];
    }
}

- (void)setUp {
    NSLog(@"jodsjfoisdjfiosdjfoisdjfoi");
    self.notification.hasRead = YES;
    [[NotificationsFileManager fileManager] update:[NSArray arrayWithObject:self.notification] deleteList:nil];
    if(self.delegate != nil && [self.delegate respondsToSelector:@selector(smNotificationsWasUpdated)]) {
        [self.delegate smNotificationsWasUpdated];
    }
}

- (void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnCheckPressed:(UIButton *)sender {
    PlayCameraPicViewController *playCameraPicViewController = [[PlayCameraPicViewController alloc] init];
    playCameraPicViewController.data = self.notification.data;
    [self presentViewController:playCameraPicViewController animated:YES completion:nil];
}

- (void)deleteBtnPressed:(UIButton *)sender {
    [[NotificationsFileManager fileManager] update:nil deleteList:[NSArray arrayWithObject:self.notification]];
    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"delete_success", @"") forType:AlertViewTypeSuccess];
    [[AlertView currentAlertView] alertAutoDisappear:YES lockView:nil];
    if(self.delegate != nil) {
        if([self.delegate respondsToSelector:@selector(smNotificationsWasUpdated)]) {
            [self.delegate smNotificationsWasUpdated];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnAgreeOrRefusePressed:(SMButton *)btn {
    NSString *alertString = [NSString emptyString];
    if([@"btnAgree" isEqualToString:btn.identifier]) {
        self.notification.text = [self.notification.text stringByAppendingString:[NSString stringWithFormat:@" [%@] ", NSLocalizedString(@"agree", @"")]];
        alertString = [NSString stringWithFormat:@"已%@", NSLocalizedString(@"agree", @"")];
        [self sendBindingResult:YES];
    } else if([@"btnRefuse" isEqualToString:btn.identifier]) {
        self.notification.text = [self.notification.text stringByAppendingString:[NSString stringWithFormat:@" [%@] ", NSLocalizedString(@"refuse", @"")]];
        alertString = [NSString stringWithFormat:@"已%@", NSLocalizedString(@"refuse", @"")];
        [self sendBindingResult:NO];
    }
    self.notification.hasProcess = YES;
    [[NotificationsFileManager fileManager] update:[NSArray arrayWithObject:self.notification] deleteList:nil];
    [[AlertView currentAlertView] setMessage:alertString forType:AlertViewTypeSuccess];
    [[AlertView currentAlertView] alertAutoDisappear:YES lockView:nil];
    if(self.delegate != nil) {
        if([self.delegate respondsToSelector:@selector(smNotificationsWasUpdated)]) {
            [self.delegate smNotificationsWasUpdated];
        }
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)sendBindingResult:(BOOL)agree {
    DeviceCommandAuthBinding *authBindingCommand = (DeviceCommandAuthBinding *)[CommandFactory commandForType:CommandTypeAuthBindingUnit];
    authBindingCommand.resultID = agree ? 1 : 2;
    authBindingCommand.masterDeviceCode = self.notification.data.masterDeviceCode;
    authBindingCommand.requestDeviceCode = self.notification.data.requestDeviceCode;
    [[SMShared current].deliveryService executeDeviceCommand:authBindingCommand];
}

@end
