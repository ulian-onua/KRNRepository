//
//  KRNNotifications.h
//  UpToNewYear
//
//  Created by Drapaylo Yulian on 25.11.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

extern NSString* const KRNNotificationsErrorDomain;

@protocol KRNNotificationsErrorHandlingProtocol;

@interface KRNNotifications : NSObject

+(void) addNotificationsWithErrorHadlingDelegate:(id<KRNNotificationsErrorHandlingProtocol>)delegate; // добавить в приложение уведомления

+(void) removeNotifications; // удалить уведомления


+(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings;  // аналог делегатного метода, который будет передавать с UIApplication


@end


@protocol KRNNotificationsErrorHandlingProtocol <NSObject>

@optional

-(void) errorAddingLocalNotification:(NSError*) error;
-(void) succeedInAddingLocalNotification;

@end