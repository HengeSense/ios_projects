//
//  CameraViewController.m
//  SmartHome
//
//  Created by hadoop user account on 21/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "CameraViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CameraLoadingView.h"
#import "CameraService.h"
#import "VideoConverter.h"
#import "UIColor+ExtentionForHexString.h"
#import "SystemAudio.h"

#define TWO_TIMES_CLICK_INTERVAL 500
#define RECORDING_BUFFER_LIST_LENGTH 9

@interface CameraViewController ()

@end

@implementation CameraViewController{
    UIImageView *imgCameraShots;
    UIView *backgroundView;
    BOOL firstImageHasBeenSet;
    DirectionButton *btnDirection;
    CameraSocket *socket;
    CameraService *cameraService;
    double lastedClickTime;
    UIButton *btnCatchScreen;
    
    BOOL cameraIsRunning;
    
    /*  for screen shots */
    BOOL isCapture;
    
    /*  for recording    */
    BOOL isRecoding;
    dispatch_queue_t writtenQueue;
    NSMutableArray *recordingList;
}

@synthesize cameraDevice;

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

#pragma mark -
#pragma mark Initializations

- (void)initDefaults {
    cameraIsRunning = NO;
    isRecoding = NO;
    isCapture = NO;
}

- (void)initUI {
    [super initUI];
    
    if(backgroundView == nil) {
        backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topbar.bounds.size.height + 5, 310, 480 - 64 - 10)];
        backgroundView.center = CGPointMake(self.view.center.x, backgroundView.center.y);
        backgroundView.backgroundColor = [UIColor colorWithHexString:@"#1a1a1f"];
        backgroundView.layer.cornerRadius = 10;
        [self.view addSubview:backgroundView];
    }
    
    if (btnCatchScreen == nil) {
        btnCatchScreen = [[UIButton alloc] initWithFrame:CGRectMake(266, backgroundView.frame.origin.y+15, 44, 44)];
        [btnCatchScreen setBackgroundImage:[UIImage imageNamed:@"btn_catch_screen.png"] forState:UIControlStateNormal];
        [btnCatchScreen addTarget:self action:@selector(catchScreen) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btnCatchScreen];
    }
    
    if(imgCameraShots == nil) {
        imgCameraShots = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 288, 216)];
        imgCameraShots.center = CGPointMake(backgroundView.bounds.size.width / 2, imgCameraShots.center.y);
        imgCameraShots.backgroundColor = [UIColor blackColor];
        [backgroundView addSubview:imgCameraShots];
        
        CameraLoadingView *loadingView = [CameraLoadingView viewWithPoint:CGPointMake(54, 83)];
        loadingView.tag = 9999;
        [imgCameraShots addSubview:loadingView];
    }
    
    if(btnDirection == nil) {
        btnDirection = [DirectionButton cameraDirectionButtonWithPoint:CGPointMake(90, imgCameraShots.frame.origin.y + imgCameraShots.bounds.size.height + 20)];
        btnDirection.delegate = self;
        [backgroundView addSubview:btnDirection];
    }
    
    [[SMShared current].memory subscribeHandler:[DeviceCommandGetCameraServerHandler class] for:self];
    [self startMonitorCamera];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dismiss {
    [[SMShared current].memory unSubscribeHandler:[DeviceCommandGetCameraServerHandler class] for:self];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self stopMonitorCamera];
    });
    [super dismiss];
}

#pragma mark -
#pragma mark Open && Stop Camera

- (void)startMonitorCamera {
    if(self.cameraDevice == nil) return;
    DeviceCommandGetCameraServer *cmd = (DeviceCommandGetCameraServer *)[CommandFactory commandForType:CommandTypeGetCameraServer];
    cmd.masterDeviceCode = self.cameraDevice.zone.unit.identifier;
    cmd.cameraId = self.cameraDevice.identifier;
    [[SMShared current].deliveryService executeDeviceCommand:cmd];
}

- (void)stopMonitorCamera {
    cameraIsRunning = NO;
    
    if(socket != nil && [socket isConnectted]) {
        [socket closeGraceful];
    }
    
    if(cameraService != nil && [cameraService isPlaying]) {
        [cameraService dontNotifyMe];
        [cameraService close];
        cameraService = nil;
    }
}

#pragma mark -
#pragma mark Device command get camera server delegate

- (void)receivedCameraServer:(DeviceCommandReceivedCameraServer *)command {
    if(self.cameraDevice == nil) return;
    if(![self.cameraDevice.identifier isEqualToString:command.cameraId]) return;
    
    if(command.commmandNetworkMode == CommandNetworkModeInternal) {
        if(cameraService != nil && [cameraService isPlaying]) {
            [cameraService close];
            cameraService.delegate = nil;
            cameraService = nil;
        }
        NSString *cameraUrl = [NSString stringWithFormat:@"http://%@:%d/snapshot.cgi?user=%@&pwd=%@", self.cameraDevice.ip, self.cameraDevice.port, self.cameraDevice.user, self.cameraDevice.pwd];
        cameraService = [[CameraService alloc] initWithUrl:cameraUrl];
        cameraService.delegate = self;
        [cameraService open];
    } else {
        NSArray *addressSet = [command.server componentsSeparatedByString:@":"];
        if(addressSet != nil && addressSet.count == 2) {
            NSString *address = [addressSet objectAtIndex:0];
            NSString *port = [addressSet objectAtIndex:1];
            if(socket != nil && [socket isConnectted]) {
                [socket close];
            }
            socket = [[CameraSocket alloc] initWithIPAddress:address andPort:port.integerValue];
            socket.delegate = self;
            socket.key = command.conStr;
            if(socket != nil) {
                [self performSelectorInBackground:@selector(openCameraSocketInBackground) withObject:nil];
            }
        }
    }
}

- (void)openCameraSocketInBackground {
    [socket connect];
}

#pragma mark -
#pragma mark Camera socket delegate

/* Called by main thread */
- (void)notifyNewImageWasReceived:(UIImage *)image {
    if(!firstImageHasBeenSet) {
        CameraLoadingView * loadingView = (CameraLoadingView *)[imgCameraShots viewWithTag:9999];
        if(loadingView != nil) {
            [loadingView hide];
        }
    }
    imgCameraShots.image = image;
    
//    if(isRecoding) {
//        [self recodingWithImage:image];
//    }
}

- (void)notifyCameraConnectted {
    firstImageHasBeenSet = NO;
    cameraIsRunning = YES;
}

- (void)notifyCameraWasDisconnectted {
    imgCameraShots.image = nil;
    firstImageHasBeenSet = NO;
    CameraLoadingView * loadingView = (CameraLoadingView *)[imgCameraShots viewWithTag:9999];
    if(loadingView != nil) {
        [loadingView showError];
    }
#ifdef DEBUG
    NSLog(@"[CAMERA] Closed.");
#endif
}

#pragma mark -
#pragma mark Screen shots

- (void)catchScreen {
    if(isCapture) return;
    
    if(cameraIsRunning) {
        if(imgCameraShots != nil && imgCameraShots.image != nil) {
            isCapture = YES;
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                UIImageWriteToSavedPhotosAlbum(imgCameraShots.image, nil, nil, nil);
                [SystemAudio photoShutter];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [[AlertView currentAlertView] setMessage:NSLocalizedString(@"catch_screen_success", @"") forType:AlertViewTypeSuccess];
                    [[AlertView currentAlertView] alertAutoDisappear:YES lockView:nil];
                    isCapture = NO;
                });
            });
        }
    } else {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"camera_is_not_running", @"") forType:AlertViewTypeSuccess];
        [[AlertView currentAlertView] alertAutoDisappear:YES lockView:nil];
        return;
    }
}

#pragma mark -
#pragma mark Screen recording

- (void)recodingWithImage:(UIImage *)image {
    
    if(image == nil) {
        // we think recoding is end when the image is nil
    }
    
    if(recordingList.count == RECORDING_BUFFER_LIST_LENGTH) {
        NSLog(@"Full...");
        NSMutableArray *images = recordingList;
//        dispatch_async(writtenQueue, ^{
            for(int i=0; i<recordingList.count; i++) {
                @try {
                    NSLog(@"jjjjjjjjjj");
                    
                    UIImage *image = [images objectAtIndex:i];
                    
                    //[NSFileManager defaultManager] createFileAtPath:@"" contents:image attributes:<#(NSDictionary *)#>
                    
                    [UIImageJPEGRepresentation(image, 1) writeToFile:[VIDEO_DIRECTORY stringByAppendingString:[NSString stringWithFormat:@"%d.jpg", i]] atomically:YES];
                    NSLog(@"save");
                }
                @catch (NSException *exception) {
                    NSLog(@"the is %@", exception.description);
                }
                @finally {
                }
            }
//        });
        
        recordingList = [NSMutableArray arrayWithCapacity:RECORDING_BUFFER_LIST_LENGTH];
    } else {
        [recordingList addObject:image];
        NSLog(@"add");
    }
}

#pragma mark -
#pragma mark Direction button delegate

- (void)leftButtonClicked {
    [self adjustCamera:@"2"];
}

- (void)rightButtonClicked {
    [self adjustCamera:@"3"];
}

/*  this function is developing, will open soon   */

- (void)centerButtonClicked {
    // Start or stop recording
    
    return;
    
    if(!cameraIsRunning) {
        [[AlertView currentAlertView] setMessage:NSLocalizedString(@"camera_is_not_running", @"") forType:AlertViewTypeSuccess];
        [[AlertView currentAlertView] alertAutoDisappear:YES lockView:nil];
        return;
    }
    
    if((socket != nil && [socket isConnectted]) || (cameraService != nil && cameraService.isPlaying)) {
        // Camera is playing ...
        
        if(isRecoding) {
            // is recording now , so need to stop recording
            
            
            
        } else {
            // is not recording now, so need to start recording
            
            writtenQueue = dispatch_queue_create("com.hentre.videos", DISPATCH_QUEUE_SERIAL);
            
            recordingList = [NSMutableArray arrayWithCapacity:RECORDING_BUFFER_LIST_LENGTH];
            
            isRecoding = YES;
            
            NSLog(@"is recording");
        }
    } else {
        // Camera is not playing ...
    }
}

- (void)topButtonClicked {
    [self adjustCamera:@"0"];
}

- (void)bottomButtonClicked {
    [self adjustCamera:@"1"];
}

- (void)adjustCamera:(NSString *)direction {
    if(self.cameraDevice == nil) return;
    
    // Check btn click is too often
    double now = [NSDate date].timeIntervalSince1970 * 1000;
    if(lastedClickTime != -1) {
        if(now - lastedClickTime <= TWO_TIMES_CLICK_INTERVAL) {
            [[AlertView currentAlertView] setMessage:NSLocalizedString(@"btn_press_often", @"") forType:AlertViewTypeFailed];
            [[AlertView currentAlertView] alertAutoDisappear:YES lockView:nil];
            lastedClickTime = now;
            return;
        }
    }
    lastedClickTime = now;
    
    DeviceCommandUpdateDevice *updateDeviceCommand = (DeviceCommandUpdateDevice *)[CommandFactory commandForType:CommandTypeUpdateDevice];
    updateDeviceCommand.masterDeviceCode = self.cameraDevice.zone.unit.identifier;
    [updateDeviceCommand addCommandString:[self.cameraDevice commandStringForCamera:direction]];
    [[SMShared current].deliveryService executeDeviceCommand:updateDeviceCommand
     ];
}

@end
