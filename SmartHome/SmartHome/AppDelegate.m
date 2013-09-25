//
//  AppDelegate.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "AppDelegate.h"
#import "Reachability.h"
#import "MainViewController.h"
#import "LoginViewController.h"
#import "SMDateFormatter.h"
#import "UnitsBindingViewController.h"
#import "ViewsPool.h"
#import "NavigationView.h"

@implementation AppDelegate

@synthesize accountService;
@synthesize settings;
@synthesize deviceCommandDeliveryService;
@synthesize memory;
@synthesize rootViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self startMonitorNetworks];
    
    // initial global settings file
    self.settings = [[GlobalSettings alloc] init];
    
    // determine first view controller
    UINavigationController *navigationController =
        [[UINavigationController alloc] initWithRootViewController:self.rootViewController];
    [navigationController setNavigationBarHidden:YES];
    navigationController.delegate = ((LoginViewController *)self.rootViewController);

    BOOL hasLogin = ![@"" isEqualToString:self.settings.secretKey];
    
    if(hasLogin) {
        // start service 
        [self.deviceCommandDeliveryService startService];
        
        if(self.settings.anyUnitsBinding) {
            [rootViewController.navigationController pushViewController:
             [[MainViewController alloc] init] animated:NO];
        } else {
            [rootViewController.navigationController pushViewController:
             [[UnitsBindingViewController alloc] init] animated:NO];
        }
    }

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    // register for remote notifications
    [self registerForRemoteNotifications];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self.deviceCommandDeliveryService stopService];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    [self.deviceCommandDeliveryService startService];
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self.deviceCommandDeliveryService stopService];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"device token is %@", [[NSString alloc] initWithData:deviceToken encoding:NSUTF8StringEncoding]);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"get device token failed...");
}

#pragma mark -
#pragma mark services

- (void)registerForRemoteNotifications {
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge];
}

- (void)startMonitorNetworks {
	Reachability* reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
    
	// Here we set up a NSNotification observer. The Reachability that caused the notification
	// is passed in the object parameter
	[[NSNotificationCenter defaultCenter] addObserver:self
        selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    
	[reach startNotifier];
}

- (void)reachabilityChanged:(NSNotification *)notification {
    Reachability *reach = notification.object;
    if(reach == nil) return;
    if(reach.isReachable) {
        if(reach.isReachableViaWiFi) {
            // wifi
            NSLog(@"reach via wifi");
        } else if(reach.isReachableViaWWAN) {
            // wwan
            NSLog(@"reach via wwan");
        }
    } else {
        // not reachable
        if([Reachability reachabilityForLocalWiFi].currentReachabilityStatus != NotReachable) {
            NSLog(@"local wifi");
        } else {
            NSLog(@"can't find any network environment");
        }
    }
}

#pragma mark -
#pragma getter and setters

- (AccountService *)accountService {
    if(accountService == nil) {
        accountService = [[AccountService alloc] init];
    }
    return accountService;
}

- (Memory *)memory {
    if(memory == nil) {
        memory = [[Memory alloc] init];
    }
    return memory;
}

- (DeviceCommandDeliveryService *)deviceCommandDeliveryService {
    if(deviceCommandDeliveryService == nil) {
        deviceCommandDeliveryService = [[DeviceCommandDeliveryService alloc] init];
    }
    return deviceCommandDeliveryService;
}

- (UIViewController *)rootViewController {
    if(rootViewController == nil) {
        rootViewController = [[LoginViewController alloc] init];
    }
    return rootViewController;
}

- (void)logout {
    @synchronized(self) {
        [[SMShared current].deliveryService stopService];
        [[SMShared current].settings clearAuth];
        [[SMShared current].memory clear];
        
        NavigationView *mainView = (NavigationView *)[[ViewsPool sharedPool] viewWithIdentifier:@"mainView"];
        if(mainView != nil) {
            UIViewController *mainViewController = mainView.ownerController;
            [[ViewsPool sharedPool] clear];
            
            [self performSelectorOnMainThread:@selector(popupToRootViewController:) withObject:mainViewController waitUntilDone:YES];
        }
    }
}

- (void)popupToRootViewController:(UIViewController *)viewController {
    if(viewController != nil) {
        [viewController.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
