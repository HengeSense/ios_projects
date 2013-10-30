//
//  AboutUsViewController.m
//  SmartHome
//
//  Created by hadoop user account on 29/10/2013.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@end

@implementation AboutUsViewController{
    UIScrollView *txtScrollView;
    UITextView *txtAboutUs;
    UIWebView *webViewAboutUs;
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
- (void)initDefaults{
    [super initDefaults];
}
- (void)initUI{
    [super initUI];
    
    if (txtScrollView == nil) {
        txtScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.topbar.frame.size.height, self.view.bounds.size.width, self.view.bounds.size.height-self.topbar.frame.size.height)];
        txtScrollView.bouncesZoom = NO;
        txtScrollView.delaysContentTouches = NO;
        [self.view addSubview:txtScrollView];
    }
    
    if (txtAboutUs == nil) {
        txtAboutUs = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, 320, 1055)];
        txtScrollView.contentSize = CGSizeMake(320, 1055);
        NSDictionary *infoDict = [NSBundle mainBundle].infoDictionary;
        NSString *currentVersion = [infoDict noNilStringForKey:@"CFBundleShortVersionString"];
        txtAboutUs.text =[NSString stringWithFormat:NSLocalizedString(@"about_us_text", @""),currentVersion];
        txtAboutUs.editable = NO;
        txtAboutUs.font = [UIFont systemFontOfSize:16];
        [txtScrollView addSubview:txtAboutUs];
    }
//    if (webViewAboutUs == nil) {
//        webViewAboutUs = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 1055)];
//        NSString *htmlString =
//        [webViewAboutUs loadHTMLString:htmlString baseURL:nil];
//        txtScrollView.contentSize = CGSizeMake(320, 1055);
//        [txtScrollView addSubview:webViewAboutUs];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)webViewDidStartLoad:(UIWebView *)webView{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}
@end
