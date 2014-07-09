//
//  AppDelegate.m
//  owned-TaperJouer
//
//  Created by Huy on 7/4/14.
//  Copyright (c) 2014 huy. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "HistoryViewController.h"
#import "ViewModel.h"

@interface AppDelegate ()

@property (nonatomic, strong) ViewModel *viewModel;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    ViewModel *viewModel = [[ViewModel alloc] init];
    self.viewModel = viewModel;
    
    MainViewController *mainVC = [[MainViewController alloc] initWithViewModel:(ViewModel *)viewModel];
    HistoryViewController *historyVC = [[HistoryViewController alloc] initWithViewModel:(ViewModel *)viewModel];
    
    UINavigationController *mainNVC = [[UINavigationController alloc] initWithRootViewController:mainVC];
    UINavigationController *historyNVC = [[UINavigationController alloc] initWithRootViewController:historyVC];
    
    [mainVC setHistoryVC:historyVC];
    
    if (IS_IPAD) {
        UISplitViewController *splitVC = [[UISplitViewController alloc] init];
        
        [splitVC setViewControllers:@[historyNVC, mainNVC]];
        [splitVC setDelegate:mainVC];
        
        [_window setRootViewController:splitVC];
        
    } else {
        // We still use NavigationControllers for iPhone even though we don't need the navigation bars
        // because they automatically keep things from showing under the statusbar in iOS 7.
        // (Alternatively, could have embedded the TableViewController in another view and used auto-layout
        // with topLayoutGuide, but that's even more complicated for the HistoryViewController)
        
        mainNVC.navigationBarHidden = YES;
        historyNVC.navigationBarHidden = YES;
        
        UITabBarController *tabVC = [[UITabBarController alloc] init];
        [tabVC setViewControllers:@[mainNVC, historyNVC]];
        
        [_window setRootViewController:tabVC];
    }
    
    [_window makeKeyAndVisible];
    
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

@end
