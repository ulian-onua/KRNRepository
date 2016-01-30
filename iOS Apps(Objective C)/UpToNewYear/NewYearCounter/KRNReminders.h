//
//  KRNReminders.h
//  UpToNewYear
//
//  Created by Drapaylo Yulian on 11.01.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import <Foundation/Foundation.h>
@import EventKit;

extern NSString* const KRNRemindersErrorDomain;

static NSInteger const KRNRemindersErrorAccessNotGranted = 0;
static NSInteger const KRNRemindersErrorAuthorizationStatusRestricted = 1;
static NSInteger const KRNRemindersErrorAuthorizationStatusDenied = 2;
static NSInteger const KRNRemindersErrorReminderWasntFoundInEventStore = 3;





@interface KRNReminders : NSObject

+(void) addReminderWithErrorBlock: (void (^)(NSError *error)) errorBlock;
+(void) removeReminderWithErrorBlock: (void (^)(NSError *error)) errorBlock;

@end
