//
//  AppDelegate.m
//  iTunesSearch
//
//  Created by s_akiba on 12/10/25.
//  Copyright (c) 2012年 s_akiba. All rights reserved.
//

#import "AppDelegate.h"
#import "TabBarController.h"
#import "LoginViewController.h"
#import "Reachability.h"

void uncaughtExceptionHander(NSException *exception) {
    DEBUGLOG(@"CRASH: %@", exception);
    DEBUGLOG(@"Stack Trace: %@", [exception callStackSymbols]);
}

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(reachabilityChanged:) name: kReachabilityChangedNotification object: nil];
	
    internetReach = [Reachability reachabilityForInternetConnection];
	[internetReach startNotifier];
	[self updateInterfaceWithReachability: internetReach];
    
    NSSetUncaughtExceptionHandler(&uncaughtExceptionHander);
    
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    [GAI sharedInstance].dispatchInterval = 10;
    [GAI sharedInstance].debug = YES;
    id<GAITracker> tracker = [[GAI sharedInstance] trackerWithTrackingId:@"UA-27668686-17"];
    [tracker trackView:@"appDelegate"];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if ([defaults objectForKey:@"FBAccessTokenKey"]
        && [defaults objectForKey:@"FBExpirationDateKey"] && [defaults stringForKey:@"user_id"]) {
        TabBarController *controller = [[TabBarController alloc] init];
        self.window.rootViewController = controller;
    } else {
        LoginViewController *loginViewController = [[LoginViewController alloc] init];
        self.window.rootViewController = loginViewController;
    }

    [self.window makeKeyAndVisible];
    return YES;
}

- (void) reachabilityChanged: (NSNotification* )note
{
	Reachability* curReach = [note object];
	NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
	[self updateInterfaceWithReachability: curReach];
}

- (void) showAlert: (Reachability*) curReach {
    NetworkStatus netStatus = [curReach currentReachabilityStatus];
    BOOL connectionRequired= [curReach currentReachabilityStatus];
    BOOL wifi = NO;
    NSString* statusString;
    switch (netStatus)
    {
        case NotReachable:
        {
            connectionRequired= NO;
            break;
        }
        case ReachableViaWiFi:
        {
            wifi = YES;
            break;
        }
    }

    if ((connectionRequired)==NO) {
        statusString= @"通信状況のよい場所で\nご利用ください。";
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"ネットワークエラー"
                                                            message:statusString
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                                  otherButtonTitles:@"OK", nil];
        [alertView show];
    }
}

- (void) updateInterfaceWithReachability: (Reachability*) curReach
{
    NetworkStatus status = [curReach currentReachabilityStatus];
    DEBUGLOG(@"status:%u", status);
    
	if(curReach == internetReach)
	{
        [self showAlert:curReach];
	}
	if(curReach == wifiReach)
	{
        [self showAlert:curReach];
	}
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    FUNC();
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    
    DEBUGLOG(@"application:%@, url:%@", application, url);
    LoginViewController *loginViewController = [[LoginViewController alloc] init];
    _window.rootViewController = loginViewController;
    [_window makeKeyAndVisible];
    
    return [[loginViewController facebook] handleOpenURL:url];
/*
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    WaitingViewController *waitingView = [[WaitingViewController alloc] init];
    // ここで、WaitingViewControllerを呼ぶから、そこでログイン後のメソッドを記述する。
    _window.rootViewController = waitingView;
    
    [_window makeKeyAndVisible];
    [defaults setObject:@"key" forKey:@"loginflag"];
*/
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    FUNC();
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    FUNC();
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    FUNC();
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    FUNC();
}

@end