//
//  AppDelegate.m
//  SmartHome
//
//  Created by Zhao yang on 8/5/13.
//  Copyright (c) 2013 hentre. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "UnitsBindingViewController.h"
#import "LoginViewController.h"

@implementation AppDelegate

@synthesize accountService;
@synthesize settings;
@synthesize rootViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{   
    // initial global settings file
    self.settings = [[GlobalSettings alloc] init];
    
    UINavigationController *navigationController =
        [[UINavigationController alloc] initWithRootViewController:self.rootViewController];
    [navigationController setNavigationBarHidden:YES];
    navigationController.delegate = rootViewController;

    BOOL hasLogin = ![@"" isEqualToString:self.settings.secretKey];
    
    if(hasLogin) {
        if(self.settings.anyUnitsBinding) {
            [rootViewController.navigationController pushViewController:
             [[MainViewController alloc] init] animated:NO];
        } else {
            [rootViewController.navigationController pushViewController:
             [[UnitsBindingViewController alloc] init] animated:NO];
        }
    } else {
        [rootViewController.navigationController pushViewController:
         [[LoginViewController alloc] init] animated:NO];
    }

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
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
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"token");
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"fail token");
}

#pragma mark -
#pragma mark services

- (void)registerForRemoteNotifications {
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeBadge];
}


#pragma mark -
#pragma getter and setters

- (AccountService *)accountService {
    if(accountService == nil) {
        accountService = [[AccountService alloc] init];
    }
    return accountService;
}

- (RootViewController *)rootViewController {
    if(rootViewController == nil) {
        rootViewController = [[RootViewController alloc] init];
    }
    return rootViewController;
}

@end
