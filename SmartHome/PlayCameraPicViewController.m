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
}

@synthesize cameraPicPaths;

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
    
}

- (void)initUI {
    [super initUI];
    
    if(playView == nil) {
        playView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.topbar.bounds.size.height, 320, 320)];
        playView.backgroundColor = [UIColor redColor];
        [self.view addSubview:playView];
    }
    
    if(cameraPicPaths == nil || cameraPicPaths.count == 0) return;
    for (int i = 0; i<cameraPicPaths.count; ++i) {
        LongButton *btnCheck = [[LongButton alloc] initWithCameraPicPath:[cameraPicPaths objectAtIndex:i]  atPoint:CGPointMake(5, 5+98/2)];
        btnCheck.cameraPicPath = [cameraPicPaths objectAtIndex:i];
//        btnCheck setTitle: forState: 
        [btnCheck addTarget:self action:@selector(btnCheckPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnCheck];
    }
}
-(void) btnCheckPressed:(LongButton *) sender{
    [self startPlayWithCameraPicPath:sender.cameraPicPath];
}
- (void)startPlayWithCameraPicPath:(CameraPicPath *)path {
    if(path == nil) return;
}

@end
