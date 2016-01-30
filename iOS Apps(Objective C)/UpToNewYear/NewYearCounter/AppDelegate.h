//
//  AppDelegate.h
//  NewYearCounter
//
//  Created by Drapaylo Yulian on 08.11.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//

#import <VK-ios-sdk/VKSdk.h>


#import <UIKit/UIKit.h>

#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>

#import "KRNNotifications.h"




extern NSString* const KRNNotificationsOn;
extern NSString* const KRNRemindersOn;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong) VKSdk *vkSdk;


@end

