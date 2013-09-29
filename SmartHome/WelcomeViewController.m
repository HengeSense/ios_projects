//
//  WelcomeViewController.m
//  SmartHome
//
//  Created by hadoop user account on 25/09/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "WelcomeViewController.h"
#import "WelcomeImageView.h"
#import "LoginViewController.h"
@interface WelcomeViewController ()

@end

@implementation WelcomeViewController{
    NSMutableArray *imgViewArr;
    NSArray *imgNameArr;
    UISwipeGestureRecognizer *swipeGesture;
    NSInteger curImgViewIndex;
    
    UIScrollView *scrollWelcomeImg;
    UIButton *btnStart;
    UIImageView *imgShadow;
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
    [super initDefaults];
    if (imgNameArr == nil || imgNameArr.count==0) {
        imgNameArr = [[NSArray alloc] initWithObjects:@"welcome01.png",@"welcome02.png",@"welcome03.png",@"welcome04.png",@"welcome05.png",@"welcome06.jpg", nil];
    }
    if (imgViewArr == nil) {
        imgViewArr = [NSMutableArray new];
    }
}
-(void) initUI{
    [super initUI];
    if (imgViewArr == nil||imgViewArr.count == 0) {
        for (NSString *imgName in imgNameArr) {
            UIImageView *welcomeImageView =[WelcomeImageView imageViewWithImageName:imgName];
            welcomeImageView.center = self.view.center;
            [imgViewArr addObject:welcomeImageView];
        }
    }
    if (imgViewArr&&imgViewArr.count>0) {
        [self.view addSubview:[imgViewArr objectAtIndex:0]];
    }
    if (scrollWelcomeImg == nil) {
        scrollWelcomeImg = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, IMG_WIDTH, IMG_HEIGHT)];
        scrollWelcomeImg.center = self.view.center;
        scrollWelcomeImg.pagingEnabled = YES;
        scrollWelcomeImg.showsHorizontalScrollIndicator = NO;
        scrollWelcomeImg.contentSize = CGSizeMake(IMG_WIDTH*imgViewArr.count, IMG_HEIGHT);
        for (int i=0;i<imgViewArr.count;++i) {
            UIImageView *imgView = [imgViewArr objectAtIndex:i];
            imgView.frame = CGRectMake(i*IMG_WIDTH, 0, IMG_WIDTH, IMG_HEIGHT);
            [scrollWelcomeImg addSubview:imgView];
        }
        [self.view addSubview:scrollWelcomeImg];
        
        UIImageView *last = [imgViewArr lastObject];
        last.userInteractionEnabled = YES;
        if (btnStart == nil) {
            btnStart = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-100, 150/2, 52/2)];
            btnStart.center = CGPointMake(self.view.center.x, btnStart.center.y);
            [btnStart setBackgroundImage:[UIImage imageNamed:@"btn_start.png"] forState:UIControlStateNormal];
            [btnStart addTarget:self action:@selector(btnStartPressed:) forControlEvents:UIControlEventTouchUpInside];
            [last addSubview:btnStart];
        }
        if (imgShadow == nil) {
            imgShadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_start_shadow.png"]];
            imgShadow.frame = CGRectMake(btnStart.frame.origin.x, btnStart.frame.size.height+btnStart.frame.origin.y, 150/2, 52/2);
            [last addSubview:imgShadow];

        }
        

    }
}
-(void) btnStartPressed:(UIButton *) sender{
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
