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
-(void) initDefaults{
    messageTypeDictionary = [[NSDictionary alloc] initWithObjectsAndKeys:NSLocalizedString(@"cf", @"btn_done.png"),@"CF",NSLocalizedString(@"ms", @"btn_done.png"),@"MS",NSLocalizedString(@"al", @"btn_done.png"),@"AL",NSLocalizedString(@"at", @"btn_done.png"),@"AT", nil];
}
- (void)generateTopbar {
    self.topbar = [TopbarView topBarWithImage:[UIImage imageNamed:@"bg_topbar.png"] shadow:YES];
    
    self.topbar.leftButton = [[UIButton alloc] initWithFrame:CGRectMake(5, 8, 120/2, 59/2)];
    [self.topbar.leftButton setBackgroundImage:[UIImage imageNamed:@"btn_back.jpg"] forState:UIControlStateNormal];
    [self.topbar.leftButton setBackgroundImage:[UIImage imageNamed:@"btn_back.jpg"] forState:UIControlStateSelected];
    [self.topbar.leftButton setTitle:NSLocalizedString(@"back", @"") forState:UIControlStateNormal];
    [self.topbar.leftButton setTitleColor:[UIColor lightTextColor] forState:UIControlStateNormal];
    self.topbar.leftButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.topbar.leftButton addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    [self.topbar addSubview:self.topbar.leftButton];
    
    [self.view addSubview:self.topbar];
    self.topbar.titleLabel.text = [messageTypeDictionary objectForKey:self.message.type];
}


-(void) initUI{
    [super initUI];
    view = [[UIView alloc] initWithFrame:CGRectMake(0, self.topbar.frame.size.height+5,self.view.frame.size.width-10 , MESSAGE_CELL_HEIGHT)];
    view.backgroundColor = [UIColor clearColor];
    view.center = CGPointMake(self.view.center.x, view.center.y);
    view.backgroundColor = [UIColor colorWithHexString:@"1a1a1f"];
    view.layer.cornerRadius = 10;
    
    
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
    UIFont *font = [UIFont systemFontOfSize:12];
    textLabel.font = font;
    textLabel.text = [@"    " stringByAppendingString:message.text];
    textLabel.textColor = [UIColor lightTextColor];
    textLabel.numberOfLines = 0;
    CGSize constraint = CGSizeMake(240, 20000.0f);
    CGSize size = [textLabel.text sizeWithFont:font constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    textLabel.frame = CGRectMake(40, 5, size.width, size.height<MESSAGE_CELL_HEIGHT?MESSAGE_CELL_HEIGHT:size.height*2);
    textLabel.backgroundColor = [UIColor clearColor];
    [view addSubview:textLabel];
    view.frame = CGRectMake(view.frame.origin.x, view.frame.origin.y, view.frame.size.width, textLabel.frame.size.height);
    view.tag = CELL_VIEW_TAG;
    [self.view addSubview:view];

    
    if ([message.type isEqualToString:@"MS"]||[message.type isEqualToString:@"AT"]||[message.type isEqualToString:@"AL"]) {
        UIButton *deleteButton = [LongButton buttonWithPoint:CGPointMake(5, view.frame.size.height+view.frame.origin.y+5)];
        [deleteButton setTitle: NSLocalizedString(@"delete", @"") forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteBtnPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:deleteButton];
    }else if ([message.type isEqualToString:@"CF"]){
        UIButton *agreeBtn = [[UIButton alloc] initWithFrame:CGRectMake(5, view.frame.size.height+view.frame.origin.y+5, 203/2, 98/2)];
        [agreeBtn setBackgroundImage:[UIImage imageNamed:@"button_cf.png"] forState:UIControlStateNormal];
        [agreeBtn setTitle: NSLocalizedString(@"agree", @"") forState:UIControlStateNormal];
        [self.view addSubview:agreeBtn];
        
        UIButton *refuseBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 203/2, 98/2)];
        [refuseBtn setBackgroundImage:[UIImage imageNamed:@"button_cf.png"] forState:UIControlStateNormal];
        refuseBtn.center = CGPointMake(agreeBtn.center.x+agreeBtn.frame.size.width+5, agreeBtn.center.y);
        [refuseBtn setTitle: NSLocalizedString(@"refuse", @"") forState:UIControlStateNormal];
        [self.view addSubview:refuseBtn];
        
        UIButton *deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 203/2, 98/2)];
        [deleteBtn setBackgroundImage:[UIImage imageNamed:@"button_cf.png"] forState:UIControlStateNormal];
        deleteBtn.center = CGPointMake(refuseBtn.center.x+refuseBtn.frame.size.width+5, refuseBtn.center.y);
        [deleteBtn setTitle: NSLocalizedString(@"delete", @"") forState:UIControlStateNormal];
        [self.view addSubview:deleteBtn];

    }
    NSLog(@"%@",NSStringFromCGSize(size));
}
-(void) cancel{
    [self dismissModalViewControllerAnimated:YES];
}
-(void) deleteBtnPressed:(UIButton *) sender{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
