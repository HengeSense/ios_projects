//
//  PlayCameraPicViewController.m
//  SmartHome
//
//  Created by Zhao yang on 9/16/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "PlayCameraPicViewController.h"
#import "CameraPicPath.h"
#import "LongButton.h"


#define THREAD_COUNT 3

@interface PlayCameraPicViewController ()

@end

@implementation PlayCameraPicViewController {
    UIImageView *playView;
    ImageProvider *provider;
}

@synthesize data;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initDefaults {
    provider = [[ImageProvider alloc] init];
    provider.delegate = self;
}

- (void)initUI {
    [super initUI];
    
    if(playView == nil) {
        playView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.topbar.bounds.size.height, 320, 240)];
        playView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:playView];
    }
        
    if(data.cameraPicPaths != nil) {
        for (int i = 0; i<3; ++i) {
            UIButton *btnPlayCamera = [LongButton buttonWithPoint:CGPointMake(5, self.topbar.bounds.size.height + i * 54 + 212)];
            [self.view addSubview:btnPlayCamera];
        }
    }
    
//    [provider startDownloader];
}


#pragma mark -

- (void)imageProviderNotifyAvailable:(NSArray *)imgList provider:(id)provider {
    UIImage *img = [imgList objectAtIndex:0];
    playView.image = img;
}


@end
