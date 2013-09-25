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
        imgNameArr = [[NSArray alloc] initWithObjects:@"welcome01.png",@"welcome02.png",@"welcome03.png",@"welcome04.png",@"welcome05.png",@"welcome06.png", nil];
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
        scrollWelcomeImg.delegate = self;
        for (int i=0;i<imgViewArr.count;++i) {
            UIImageView *imgView = [imgViewArr objectAtIndex:i];
            imgView.frame = CGRectMake(i*IMG_WIDTH, 0, IMG_WIDTH, IMG_HEIGHT);
            [scrollWelcomeImg addSubview:imgView];
        }
        [self.view addSubview:scrollWelcomeImg];
    }
}
-(void) scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollWelcomeImg.contentOffset.x>scrollWelcomeImg.contentSize.width-IMG_WIDTH) {
        [self.navigationController pushViewController:[[LoginViewController alloc] init] animated:YES];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
