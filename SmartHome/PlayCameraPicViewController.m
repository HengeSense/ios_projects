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
    BOOL isPlaying;
    IBOutlet UIImageView *playView;
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
    isPlaying = NO;
}

- (void)initUI {
    [super initUI];
    
    if(playView == nil) {
        playView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.topbar.bounds.size.height, 320, 240)];
        playView.backgroundColor = [UIColor blackColor];
        [self.view addSubview:playView];
    }
        
    if(data.cameraPicPaths != nil) {
        for (int i = 0; i<data.cameraPicPaths.count; i++) {
            LongButton *btnPlayCamera = [LongButton buttonWithPoint:CGPointMake(5, self.topbar.bounds.size.height + i * 54 + 212)];
            CameraPicPath *path = [data.cameraPicPaths objectAtIndex:i];
            NSString *url = [NSString stringWithFormat:@"%@%@", data.http, path.path];
            [btnPlayCamera setObject:url forKey:@"url"];
            [btnPlayCamera addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btnPlayCamera];
        }
    }
}

- (void)play:(id<ParameterExtentions>)source {
    if(isPlaying) {
        return;
    }
    if(source != nil) {
        NSString *url = [source objectForKey:@"url"];
        if(![NSString isBlank:url]) {
            isPlaying = YES;
            [self performSelectorInBackground:@selector(startDownloader:) withObject:url];
        }
    }
}

- (void)startDownloader:(NSString *)url {
    [provider startDownloader:url imageIndex:0];
}

#pragma mark -

- (void)imageProviderNotifyAvailable:(NSArray *)imgList provider:(id)provider {
//    for(int i=0; i<imgList.count; i++) {
//        [playView setImage: [imgList objectAtIndex:i]];
////        [playView setNeedsDisplay];
////        [playView setNeedsLayout];
////        [playView setNeedsUpdateConstraints];
//        [NSThread sleepForTimeInterval:2.f];
//        
//        
//        
//        [NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(jjjj) userInfo:nil repeats:YES];
//    }
//    return;
    playView.animationImages = imgList;
    playView.animationRepeatCount = 1;
    playView.animationDuration = 5.f;
    [playView startAnimating];
}

@end
