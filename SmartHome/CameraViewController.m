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
#import "UIColor+ExtentionForHexString.h"


@interface CameraViewController ()

@end

@implementation CameraViewController{
    UIImageView *imgCameraShots;
    UIView *backgroundView;
    BOOL firstImageHasBeenSet;
    DirectionButton *btnDirection;
    CameraSocket *socket;
    CameraService *cameraService;
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

- (void)initUI {
    [super initUI];
    
    if(backgroundView == nil) {
        backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topbar.bounds.size.height + 5, 310, 480 - 64 - 10)];
        backgroundView.center = CGPointMake(self.view.center.x, backgroundView.center.y);
        backgroundView.backgroundColor = [UIColor colorWithHexString:@"#1a1a1f"];
        backgroundView.layer.cornerRadius = 10;
        [self.view addSubview:backgroundView];
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
#pragma mark service

- (void)startMonitorCamera {
    if(self.cameraDevice == nil) return;
    DeviceCommandGetCameraServer *cmd = (DeviceCommandGetCameraServer *)[CommandFactory commandForType:CommandTypeGetCameraServer];
    cmd.masterDeviceCode = self.cameraDevice.zone.unit.identifier;
    cmd.cameraId = self.cameraDevice.identifier;
    [[SMShared current].deliveryService executeDeviceCommand:cmd];
}

- (void)stopMonitorCamera {
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
#pragma mark device command get camera server delegate

- (void)receivedCameraServer:(DeviceCommandReceivedCameraServer *)command {
    if(self.cameraDevice == nil) return;
    if(![self.cameraDevice.identifier isEqualToString:command.cameraId]) return;
    
    if(command.commmandNetworkMode == CommandNetworkModeInternal) {
        if(cameraService != nil && [cameraService isPlaying]) {
            [cameraService close];
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
#pragma mark camera socket delegate

- (void)notifyNewImageWasReceived:(UIImage *)image {
    if(!firstImageHasBeenSet) {
        CameraLoadingView * loadingView = (CameraLoadingView *)[imgCameraShots viewWithTag:9999];
        if(loadingView != nil) {
            [loadingView hide];
        }
    }
    imgCameraShots.image = image;
}

- (void)notifyCameraConnectted {
    firstImageHasBeenSet = NO;
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
#pragma mark direction button delegate

- (void)leftButtonClicked {
    [self adjustCamera:@"2"];
}

- (void)rightButtonClicked {
    [self adjustCamera:@"3"];
}

- (void)centerButtonClicked {
}

- (void)topButtonClicked {
    [self adjustCamera:@"0"];
}

- (void)bottomButtonClicked {
    [self adjustCamera:@"1"];
}

- (void)adjustCamera:(NSString *)direction {
    if(self.cameraDevice == nil) return;
    DeviceCommandUpdateDevice *updateDeviceCommand = (DeviceCommandUpdateDevice *)[CommandFactory commandForType:CommandTypeUpdateDevice];
    updateDeviceCommand.masterDeviceCode = self.cameraDevice.zone.unit.identifier;
    [updateDeviceCommand addCommandString:[self.cameraDevice commandStringForCamera:direction]];
    [[SMShared current].deliveryService executeDeviceCommand:updateDeviceCommand
     ];
}

@end
