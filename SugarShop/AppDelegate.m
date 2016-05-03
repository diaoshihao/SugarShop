//
//  AppDelegate.m
//  SugarShop
//
//  Created by mac on 16/4/14.
//  Copyright © 2016年 diaoshihao. All rights reserved.
//

#import "AppDelegate.h"
#import "SHTools.h"
#import "SHTabBarController.h"
#import <MMDrawerController.h>
#import "SHMenuTableViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    SHTabBarController *tabBarController = [[SHTabBarController alloc] init];
    
    SHMenuTableViewController *menuTableViewController = [[SHMenuTableViewController alloc] init];
    
    MMDrawerController *drawerController = [[MMDrawerController alloc] initWithCenterViewController:tabBarController leftDrawerViewController:menuTableViewController];
    drawerController.maximumLeftDrawerWidth = [UIScreen mainScreen].bounds.size.width * 2 / 3;
    [drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
    [drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
    
    self.window.rootViewController = drawerController;
    
    return YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    [SHTools afPOST:kSHLOGOUT parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"login"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

@end
