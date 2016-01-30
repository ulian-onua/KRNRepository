//
//  KRNReminders.m
//  UpToNewYear
//
//  Created by Drapaylo Yulian on 11.01.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//


#import "KRNReminders.h"


enum KRNTypeOfReminderAction {KRNAddReminder, KRNRemoveReminder};

typedef enum KRNTypeOfReminderAction KRNTypeOfReminderAction;


///Reminders Error Domain

NSString* const KRNRemindersErrorDomain = @"KRNRemindersErrorDomain";


// Notification Value

NSString* const KRNRemindersSavedNotification = @"KRNRemindersSavedNotification";



NSString* reminderIdentifier = nil;



@implementation KRNReminders


+(void) addReminderWithErrorBlock: (void (^)(NSError *error)) errorBlock
{
    [self performRemindersActionWithErrorBlock:errorBlock AndTypeOfRemindersAction:KRNAddReminder];
    
}

+(void) removeReminderWithErrorBlock: (void (^)(NSError *error)) errorBlock
{
    [self performRemindersActionWithErrorBlock:errorBlock AndTypeOfRemindersAction:KRNRemoveReminder];
    
}


+(void) performRemindersActionWithErrorBlock: (nullable void (^)(NSError *error)) errorBlock AndTypeOfRemindersAction:(KRNTypeOfReminderAction) typeReminderAction
{
    __block NSError *errorForBlock = nil;
    
    EKEventStore *evStore = [[EKEventStore alloc] init];
    
    
    
    if ([EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder] == EKAuthorizationStatusAuthorized) 
    {
        if (typeReminderAction == KRNAddReminder)
            errorForBlock = [self addReminderEngineWithEventStore:evStore];
        else // KRNRemoveReminder
            errorForBlock = [self removeReminderEngineWithEventStore:evStore];
        
    }
    
    else if ([EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder] == EKAuthorizationStatusNotDetermined)
    
    {
    [evStore requestAccessToEntityType:EKEntityTypeReminder completion:^(BOOL granted, NSError * _Nullable error)
        {
        
        if (granted)
        {
            if (typeReminderAction == KRNAddReminder)
                errorForBlock = [self addReminderEngineWithEventStore:evStore];
            else // KRNRemoveReminder
                errorForBlock = [self removeReminderEngineWithEventStore:evStore];
                
                if (errorBlock != nil)
                    errorBlock(errorForBlock);
        }
        if (!granted)
        {
            NSLog(@"Access is not granted");
           errorForBlock = [NSError errorWithDomain:KRNRemindersErrorDomain code: KRNRemindersErrorAccessNotGranted userInfo:nil];
            errorBlock(errorForBlock);
        }
            
        if (error)
        {
            // добавить вывод UIAlertController'а о невозможности добавления
        NSLog(@"Error request access: %@", error.localizedDescription);
            errorForBlock = [error copy];
        }
       
    }];
    }
    else if ([EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder] == EKAuthorizationStatusDenied)
    {
     //
        errorForBlock = [NSError errorWithDomain:KRNRemindersErrorDomain code:KRNRemindersErrorAuthorizationStatusDenied userInfo:nil];
    }
    else if ([EKEventStore authorizationStatusForEntityType:EKEntityTypeReminder] == EKAuthorizationStatusRestricted)
    {
       errorForBlock = [NSError errorWithDomain:KRNRemindersErrorDomain code:KRNRemindersErrorAuthorizationStatusRestricted userInfo:nil];
    }
    
 
        if (errorBlock != nil)
                errorBlock(errorForBlock);

}

+(NSError*) addReminderEngineWithEventStore:(EKEventStore*)evStore
{
    EKReminder* timeToNewYearReminder = [EKReminder reminderWithEventStore:evStore];
    timeToNewYearReminder.calendar = [evStore defaultCalendarForNewReminders]; // получаем дефолтный календарь
    timeToNewYearReminder.title = @"Check time up to New Year!!";
    timeToNewYearReminder.notes = @"Check time up to New Year by launching UpToNewYear app";
    
    timeToNewYearReminder.completionDate = [NSDate dateWithTimeIntervalSinceNow:30];
    timeToNewYearReminder.completed = NO;
    timeToNewYearReminder.priority = 1;
    
    
    // создаем и добавляем alarm
    EKAlarm* alarm = [EKAlarm alarmWithRelativeOffset:10];
    
    [timeToNewYearReminder addAlarm:alarm];
    
    
    unsigned unitFlags= NSCalendarUnitYear|NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour |NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitTimeZone;
    
    NSDateComponents *dailyComponents=[[NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian] components:unitFlags fromDate:[NSDate dateWithTimeIntervalSinceNow:10]];
    
    [timeToNewYearReminder setDueDateComponents:dailyComponents];
    
    
    // создаем и добавляем правило повторения
    
    EKRecurrenceRule *recRule = [[EKRecurrenceRule alloc]initRecurrenceWithFrequency:EKRecurrenceFrequencyDaily interval:1 end:nil];
    
    [timeToNewYearReminder addRecurrenceRule:recRule];
    
    //добавляем напоминание в Event Store
    
    NSError* error;
    
    [evStore saveReminder:timeToNewYearReminder commit:YES error:&error];
    if (error)
    {
        NSLog(@"Error adding reminder: %@", error.localizedDescription);
        return error;
    }
    
    reminderIdentifier = [NSString stringWithString:timeToNewYearReminder.calendarItemIdentifier];
    
    [[NSUserDefaults standardUserDefaults] setObject:reminderIdentifier forKey:KRNRemindersSavedNotification];
    return nil;

}

+(NSError*) removeReminderEngineWithEventStore:(EKEventStore*)evStore
{
   
    reminderIdentifier =
    [[NSUserDefaults standardUserDefaults] objectForKey:KRNRemindersSavedNotification];
    
    NSError* error = nil;
 
    if (reminderIdentifier != nil)
    {

        
    
    EKReminder *removedReminder = (EKReminder*) [evStore calendarItemWithIdentifier:reminderIdentifier];
    
    if (removedReminder == nil) // напоминание на найдено в базе (возможно, оно было ранее удалено пользователем)
    {
        error = [NSError errorWithDomain:KRNRemindersErrorDomain code:KRNRemindersErrorReminderWasntFoundInEventStore userInfo:@{NSLocalizedDescriptionKey : @"Can't retrieve UpToNewYear reminder from Reminders", NSLocalizedFailureReasonErrorKey : @"Possibly it was deleted manually from Reminders."}];
        return error;
        
    }
   
    [evStore removeReminder:removedReminder commit:YES error:&error];
    if (error)
    {
        NSLog(@"Error removing reminder: %@", error.localizedDescription);
        return error;
    }
        reminderIdentifier = nil;
    
    }
    
    return error;
    
}

@end
