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
            LongButton *btnPlayCamera = [LongButton buttonWithPoint:CGPointMake(5, self.topbar.bounds.size.height + i * 54 + 245)];
            CameraPicPath *path = [data.cameraPicPaths objectAtIndex:i];
            NSString *url = [NSString stringWithFormat:@"%@%@", data.http, path.path];
            [btnPlayCamera setParameter:url forKey:@"url"];
            [btnPlayCamera setTitle:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"play", @""), @"Ca"] forState:UIControlStateNormal];
            [btnPlayCamera addTarget:self action:@selector(play:) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btnPlayCamera];
        }
    }
    
    self.topbar.titleLabel.text = NSLocalizedString(@"view_message_video", @"");
}

- (void)play:(id<ParameterExtentions>)source {
    if(isPlaying) {
        return;
    }
    if(source != nil) {
        NSString *url = [source parameterForKey:@"url"];
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

- (void)imageProviderNotifyImageAvailable:(UIImage *)image {
    playView.image = image;
}

- (void)imageProviderNotifyImageStreamWasEnded {
    NSLog(@"Image provider download image error.");
}

- (void)imageProviderNotifyReadingImageError {
    NSLog(@"Image provider reading error.");
}

@end
