//
//  CameraViewController.m
//  SmartHome
//
//  Created by hadoop user account on 21/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "CameraViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+ExtentionForHexString.h"


@interface CameraViewController ()

@end

@implementation CameraViewController{
    UIImageView *imgCameraShots;
    UIView *backgroundView;
    DirectionButton *btnDirection;
    CameraSocket *socket;
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

-(void) initUI{
    [super initUI];
    
    if(backgroundView == nil) {
        backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topbar.bounds.size.height + 5, 310, 480 - self.topbar.bounds.size.height - 10)];
        backgroundView.center = CGPointMake(self.view.center.x, backgroundView.center.y);
        backgroundView.backgroundColor = [UIColor colorWithHexString:@"#1a1a1f"];
        backgroundView.layer.cornerRadius = 10;
        [self.view addSubview:backgroundView];
    }
    
    if(imgCameraShots == nil) {
        imgCameraShots = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 288, 216)];
        imgCameraShots.center = CGPointMake(backgroundView.bounds.size.width / 2, imgCameraShots.center.y);
        imgCameraShots.image = [UIImage imageNamed:@"test.png"];
        [backgroundView addSubview:imgCameraShots];
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

- (void)btnDownPressed:(id)sender {
    
}

- (void)dismiss {
    [[SMShared current].memory unSubscribeHandler:[DeviceCommandGetCameraServerHandler class] for:self];
    [self performSelectorInBackground:@selector(stopMonitorCamera) withObject:nil];
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
        [socket close];
    }
}

#pragma mark -
#pragma mark device command get camera server delegate

- (void)receivedCameraServer:(DeviceCommandReceivedCameraServer *)command {
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
        [socket connect];
    }
}

#pragma mark -
#pragma mark camera socket delegate

- (void)notifyNewImageWasReceived:(UIImage *)image {
    imgCameraShots.image = image;
}

- (void)notifyCameraConnectted {
    NSLog(@"camera open");
}

- (void)notifyCameraWasDisconnectted {
    NSLog(@"camera close");
}

#pragma mark -
#pragma mark direction button delegate

- (void)leftButtonClicked {
    NSLog(@"leftClicked");
}

- (void)rightButtonClicked {
    NSLog(@"rightClicked");
}

- (void)centerButtonClicked {
    NSLog(@"centerClicked");
}

- (void)topButtonClicked {
    NSLog(@"topClicked");
}

- (void)bottomButtonClicked {
    NSLog(@"bottomClicked");
}

@end
