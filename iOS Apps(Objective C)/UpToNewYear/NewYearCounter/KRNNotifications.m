//
//  KRNNotifications.m
//  UpToNewYear
//
//  Created by Drapaylo Yulian on 25.11.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//

#import "KRNNotifications.h"

NSString* const KRNNotificationsErrorDomain = @"KRNNotificationsErrorDomain";

static NSInteger const KRNNotificationsErrorAccessIsDenied = 0; // нотификации полностью запрещены пользователем

id<KRNNotificationsErrorHandlingProtocol> _delegate;


@implementation KRNNotifications

+(void) addNotificationsWithErrorHadlingDelegate:(id<KRNNotificationsErrorHandlingProtocol>)delegate;
{
    if ([UIApplication sharedApplication].scheduledLocalNotifications.count !=0)
    {
        // на всякий случай, проверим не установлены ли уже нотификации. Если да, то выйдем из функции.
        [self removeNotifications]; // сбросим установленные нотификации
    }
    
    // присваиваем делегата
    _delegate = delegate;
    
    // устанавливаем настройки
    UIUserNotificationType types =  UIUserNotificationTypeAlert | UIUserNotificationTypeSound;
    
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(types) categories:nil];
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    

    // добавляем нотификацию
}




+(void) addNotificationsEngine
{
    UILocalNotification *localNotif = [[UILocalNotification alloc] init];
    
    localNotif.fireDate = [NSDate dateWithTimeInterval:120 sinceDate:[NSDate date]]; // через две минуты после текущей даты
    localNotif.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotif.applicationIconBadgeNumber = 1;
    localNotif.soundName = UILocalNotificationDefaultSoundName;
    
    
    localNotif.alertTitle = @"TimeToNewYear";
    localNotif.alertBody = @"Check time up to New Year!!";
    
    
    
    localNotif.repeatInterval = kCFCalendarUnitDay;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
    
    [_delegate succeedInAddingLocalNotification];
    _delegate = nil;
    
}

+(void) removeNotifications // удалить уведомления
{
    [[UIApplication sharedApplication] cancelAllLocalNotifications];

}

+(void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings  // аналог делегатного метода, который будет передавать с UIApplication
{
    if (notificationSettings.types == 0)
    {
        if ([_delegate respondsToSelector:@selector(errorAddingLocalNotification:)])
        {
            NSError *error = [NSError errorWithDomain:KRNNotificationsErrorDomain code:KRNNotificationsErrorAccessIsDenied userInfo:@{NSLocalizedDescriptionKey : @"Error adding local notification.", NSLocalizedFailureReasonErrorKey: @"Access is denied by user.", NSLocalizedRecoverySuggestionErrorKey: @"You can allow access in Settings->UpToNewYear->Notifications."}];
            [_delegate errorAddingLocalNotification:error];
            _delegate = nil;
            
        }
        
        
    }
    else
        [self addNotificationsEngine];
    
}

@end
