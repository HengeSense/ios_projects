//
//  CameraAdjustViewController.m
//  SmartHome
//
//  Created by hadoop user account on 21/08/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "CameraAdjustViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+ExtentionForHexString.h"
#import "DeviceFinder.h"


#import "ExtranetClientSocket.h"
#import "CommunicationMessage.h"
#import "SMShared.h"
#import "JsonUtils.h"
#import "DeviceCommandUpdateUnits.h"
#import "NSDictionary+NSNullUtility.h"

@interface CameraAdjustViewController ()

@end

@implementation CameraAdjustViewController{
    UIImageView *imgCameraShots;
    UIView *backgroundView;
    DirectionButton *btnDirection;
    
    
    
    ExtranetClientSocket *ff;
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

-(void) initUI{
    [super initUI];
    self.topbar.titleLabel.text = NSLocalizedString(@"camera_adjust", @"");
    
    if(backgroundView == nil) {
        backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, self.topbar.bounds.size.height + 5, 310, self.view.bounds.size.height - self.topbar.bounds.size.height - 30)];
        backgroundView.center = CGPointMake(self.view.center.x, backgroundView.center.y);
        backgroundView.backgroundColor = [UIColor colorWithHexString:@"#1a1a1f"];
        backgroundView.layer.cornerRadius = 10;
        [self.view addSubview:backgroundView];
    }
    
    if(imgCameraShots == nil) {
        imgCameraShots = [[UIImageView alloc] initWithFrame:CGRectMake(0, 15, 280, 200)];
        imgCameraShots.center = CGPointMake(backgroundView.bounds.size.width / 2, imgCameraShots.center.y);
        imgCameraShots.image = [UIImage imageNamed:@"test.png"];
        [backgroundView addSubview:imgCameraShots];
    }
    
    if(btnDirection == nil) {
        btnDirection = [DirectionButton directionButtonWithPoint:CGPointMake(90, imgCameraShots.frame.origin.y + imgCameraShots.bounds.size.height + 20)];
        btnDirection.delegate = self;
        [backgroundView addSubview:btnDirection];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)btnDownPressed:(id)sender {
    
}


- (void)clientSocketMessageDiscard:(NSData *)discardMessage {
    NSLog(@"discard");
}

- (void)clientSocketMessageReadError {
    NSLog(@"error");
}

- (void)clientSocketWithReceivedMessage:(NSString *)messages {
    
    NSLog(messages);
    
NSDictionary *ddd=    [JsonUtils createDictionaryFromJson: [messages dataUsingEncoding:NSUTF8StringEncoding]];
    if(ddd != nil) {

           DeviceCommandUpdateUnits *ccc= [[DeviceCommandUpdateUnits alloc] initWithDictionary:ddd];
        NSLog(@"units count %d", ccc.units.count);
        
        
Unit *u =        [ccc.units objectAtIndex:0];
Zone *zone=        [u.zones objectForKey:@"zone1"];
        NSLog(        @"%d", zone.accessories.count);
        
Device *dd =        [zone.accessories objectForKey:@"child1"];
        NSLog(@"%@", dd.name);
        
        
//        NSLog(@"device count %d",         zone.accessories.count);

        
        
        
        
    }
    
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
    ff = [[ExtranetClientSocket alloc] initWithIPAddress:@"172.16.8.16" andPort:6969];
    ff.messageHandlerDelegate = self;
    [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(testj) userInfo:nil repeats:NO];
    [ff connect];
    }

- (void)testj {
    NSLog(@"go %@", [SMShared current].settings.account);
    CommunicationMessage *ms =   [[CommunicationMessage alloc] init];
    ms.deviceCommand = [[DeviceCommand alloc] init];
    ms.deviceCommand.deviceCode = [SMShared current].settings.account;
    ms.deviceCommand.commandName = @"FindZKListCommand";
    ms.deviceCommand.commandTime = [[NSDate alloc] init];
    ms.deviceCommand.masterDeviceCode = @"fieldunit";
    NSData *ddd =  [ms generateData];
    [ff writeData:ddd];
}

- (void)topButtonClicked {
    NSLog(@"topClicked");
}

- (void)bottomButtonClicked {
    NSLog(@"bottomClicked");
}

@end
