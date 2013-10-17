//
//  AppDelegate.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "LoginViewController.h"
#import "SMDateFormatter.h"
#import "UnitsBindingViewController.h"
#import "ViewsPool.h"
#import "NavigationView.h"
#import "WelcomeViewController.h"

@implementation AppDelegate

@synthesize accountService;
@synthesize settings;
@synthesize deviceCommandDeliveryService;
@synthesize memory;
@synthesize rootViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    if(launchOptions) {
        [self handleNotifications:[launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey]];
    }
    
    // initial global settings file
    self.settings = [[GlobalSettings alloc] init];
    
    // determine first view controller
    UINavigationController *navigationController =
        [[UINavigationController alloc] initWithRootViewController:self.rootViewController];
    [navigationController setNavigationBarHidden:YES];
    navigationController.delegate = ((LoginViewController *)self.rootViewController);
    
    BOOL hasLogin = ![[NSString emptyString] isEqualToString:self.settings.secretKey];

    if(hasLogin) {
        // start service 
        [self.deviceCommandDeliveryService startService];
        
        if([SMShared current].memory.units.count > 0) {
            [rootViewController.navigationController pushViewController:
             [[MainViewController alloc] init] animated:NO];
        } else {
            [rootViewController.navigationController pushViewController:
             [[UnitsBindingViewController alloc] init] animated:NO];
        }
        
        // register for remote notifications
        [self registerForRemoteNotifications];
    }

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    if (self.settings.isFirstTimeOpenApp) {
        self.settings.isFirstTimeOpenApp = NO;
        [self.settings saveSettings];
        [self.rootViewController.navigationController pushViewController:[[WelcomeViewController alloc] init] animated: NO];
    }
    
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
    
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    if(![NSString isBlank:self.settings.secretKey]
       && ![NSString isBlank:self.settings.deviceCode]) {
        [self.deviceCommandDeliveryService startService];
        [self.deviceCommandDeliveryService startRefreshCurrentUnit];
    }
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
    NSString *token = [[[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    [SMShared current].settings.deviceToken = token;
    [[SMShared current].settings saveSettings];
    DeviceCommandUpdateDeviceToken *updateDeviceTokenCommand = (DeviceCommandUpdateDeviceToken *)[CommandFactory commandForType:CommandTypeUpdateDeviceToken];
    updateDeviceTokenCommand.iosToken = token;
    [[SMShared current].deliveryService queueCommand:updateDeviceTokenCommand];
#ifdef DEBUG
    NSLog(@"[APP DELEGATE] Device Token is %@", token);
#endif
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
#ifdef DEBUG
    NSLog(@"[APP DELEGATE] Get device token failed.");
#endif
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if(application.applicationState != UIApplicationStateActive) {
        [self handleNotifications:userInfo];
    }
}

#pragma mark -
#pragma mark services

- (void)registerForRemoteNotifications {
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge];
}

- (void)handleNotifications:(NSDictionary *)userInfo {
#ifdef DEBUG
    NSLog(@"[APP DELEGATE] Received remote push notifications:\r\n %@", (userInfo == nil) ? [NSString emptyString] : userInfo);
#endif
    
    if(userInfo) {
        NSString *notificationId = [userInfo objectForKey:@"mid"];
        if(![NSString isBlank:notificationId]) {
#ifdef DEBUG
            NSLog(@"[APP DELEGATE] Notification ID %@", notificationId);
#endif
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
        
        NavigationView *mainView = (NavigationView *)[[ViewsPool sharedPool] viewWithIdentifier:@"mainView"];
        if(mainView != nil) {
            UIViewController *mainViewController = mainView.ownerController;
            [self performSelectorOnMainThread:@selector(popupToRootViewController:) withObject:mainViewController waitUntilDone:YES];
        }
        
        [[ViewsPool sharedPool] clear];
        [[SMShared current].settings clearAuth];
        [[SMShared current].memory clear];
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
#ifdef DEBUG
        NSLog(@"[APP DELEGATE] Logout Successfully.");
#endif
    }
}

- (void)popupToRootViewController:(UIViewController *)viewController {
    if(viewController != nil) {
        [viewController.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
