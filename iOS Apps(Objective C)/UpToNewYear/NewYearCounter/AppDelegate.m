//
//  AppDelegate.m
//  NewYearCounter
//
//  Created by Drapaylo Yulian on 08.11.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//

#import "AppDelegate.h"

NSString* const KRNNotificationsOn = @"KRNNotificationsOn";
NSString* const KRNRemindersOn = @"KRNRemindersOn";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // копируем дефолтные значения UserDefaults
    NSNumber *KRNNotificationValue =
    [[NSUserDefaults standardUserDefaults] objectForKey:KRNNotificationsOn];
    if (KRNNotificationValue== nil) {
        // No value found
       KRNNotificationValue = @NO;
    
        [[NSUserDefaults standardUserDefaults] setObject:KRNNotificationValue forKey:KRNNotificationsOn];
    
    }
    
    NSNumber *KRNRemindersValue = [[NSUserDefaults standardUserDefaults] objectForKey:KRNRemindersOn];
    if (KRNRemindersValue == nil) {
        // No value found
        KRNRemindersValue = @NO;
        [[NSUserDefaults standardUserDefaults] setObject:KRNRemindersValue forKey:KRNRemindersOn];
        
    }
    
 
    // инициализируем VkSdk
    
   _vkSdk = [VKSdk initializeWithAppId:@"5223246"];
    

        // инициализируем FB SDK

 //   [[FBSDKApplicationDelegate sharedInstance] application:application
                         //    didFinishLaunchingWithOptions:launchOptions];
    
    [Fabric with:@[[Twitter class]]];


    return YES;
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
  //  [FBSDKAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


 - (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    NSLog(@"User Notification Settings = %@", notificationSettings);
    [KRNNotifications application:application didRegisterUserNotificationSettings:notificationSettings];
    
}




- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    [VKSdk processOpenURL:url fromApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]];
    return YES;
}




@end
