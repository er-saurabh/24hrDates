//
//  AppDelegate.m
//  24hrDates
//
//  Created by Ankit on 05/08/15.
//  Copyright (c) 2015 Ankit. All rights reserved.
//

#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "Branch.h"
#import <CoreLocation/CoreLocation.h>

@interface AppDelegate ()
{
    CLLocationManager *locationManager;
    CLGeocoder *geoCoder;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
//    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:22], NSFontAttributeName, nil]];
//    
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [self loginLocation];
    Branch *branch = [Branch getInstance];
    [branch initSessionWithLaunchOptions:launchOptions andRegisterDeepLinkHandler:^(NSDictionary *params, NSError *error){
        NSLog(@"start param%@",params);
    }];

     return [[FBSDKApplicationDelegate sharedInstance] application:application
                                           didFinishLaunchingWithOptions:launchOptions];
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
    [FBSDKAppEvents activateApp];

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark---FaceBook Implementation

-(BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
   BOOL wasHandled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                   openURL:url
                                         sourceApplication:sourceApplication
                                                annotation:annotation];
    if (!wasHandled)
        [[Branch getInstance] handleDeepLink:url];
    
    return YES;
}
-(void)loginLocation
{
    locationManager=[CLLocationManager new];
    [locationManager startUpdatingLocation];
        if ([[[UIDevice currentDevice] systemVersion] isEqualToString:@"7"])
        {
    NSLog(@"%lld",[[[UIDevice currentDevice] systemVersion] longLongValue]);
      }
        else{
    [locationManager requestAlwaysAuthorization];
    [locationManager requestWhenInUseAuthorization];
        }
    geoCoder=[CLGeocoder new];
    //CLLocation *LocationAtual = [[CLLocation alloc] initWithLatitude:28.5700 longitude:77.3200];
    [geoCoder reverseGeocodeLocation:locationManager.location completionHandler:^(NSArray *plm,NSError *error)
     {
         CLPlacemark *placemk=plm[0];
         if (placemk.locality&&placemk.subLocality) {
             [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@, %@",placemk.locality,placemk.subLocality] forKey:@"login_location"];
         }
         
         else
         {[[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"No Location "] forKey:@"login_location"];
         }
        NSLog(@"%@",[[NSUserDefaults standardUserDefaults]valueForKey:@"login_location"]);
     }];
}
@end
