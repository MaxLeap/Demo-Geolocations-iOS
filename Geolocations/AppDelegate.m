//
//  AppDelegate.m
//  Geolocations
//
//  Created by Héctor Ramos on 7/31/12.
//

#import "AppDelegate.h"
#import "MasterViewController.h"

@implementation AppDelegate


#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // ****************************************************************************
    // Uncommit fill in with your LAS credentials:
    // ****************************************************************************
#warning Please fill in with your LAS credentials
    // [LAS setApplicationId:@"APPLICATION_ID_HERE" clientKey:@"CLIENT_KEY_HERE"];
    
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

@end
