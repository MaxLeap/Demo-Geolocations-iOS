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
    // LAS initialization
#warning Please fill in with your LAS credentials
    [LAS setApplicationId:@"APPLICATION_ID_HERE" clientKey:@"CLIENT_KEY_HERE"];
    // ****************************************************************************

    LASUser *currentUser = [LASUser currentUser];
    if (currentUser.sessionToken.length == 0) {
        
        LASUser *user = [LASUser user];
        user.username = @"Matt";
        user.password = @"password";
        user.email = @"matt@example.com";
        [LASUserManager signUpInBackground:user block:^(BOOL succeeded, NSError *error) {
            
            if (error) {
                
                [LASUserManager logInWithUsernameInBackground:@"Matt" password:@"password" block:^(LASUser *user, NSError *error) {
                    
                    NSLog(@"logged in user = %@,\n error = %@", user, error);
                    
                }];
            }
        }];
    }
    
    // Override point for customization after application launch.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    // Stop updating locations while in the background.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    MasterViewController *masterViewController = [storyboard instantiateViewControllerWithIdentifier:@"MasterViewController"];
    [masterViewController.locationManager stopUpdatingLocation];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    // Start updating locations when the app returns to the foreground.
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    MasterViewController *masterViewController = [storyboard instantiateViewControllerWithIdentifier:@"MasterViewController"];
    [masterViewController.locationManager startUpdatingLocation];
}

@end
