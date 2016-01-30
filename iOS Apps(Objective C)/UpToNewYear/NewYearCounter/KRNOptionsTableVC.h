//
//  KRNOptionsTableVCTableViewController.h
//  UpToNewYear
//
//  Created by Drapaylo Yulian on 25.11.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRNNotifications.h"


#import "KRNReminders.h"
#import "KRNShareEmail.h"
#import "KRNShareVkontakte.h"
#import "KRNShareTwitter.h"
#import "KRNShareSMS.h"


#import "AppDelegate.h"
#import <VK-ios-sdk/VKSdk.h>


#import "KRHHelpViewController.h"


 





@interface KRNOptionsTableVC : UITableViewController<KRNShareVkontakteProtocol>

- (IBAction)backButtonAction:(id)sender;
- (IBAction)notificationsSwitchAction:(id)sender;
- (IBAction)remindersSwitchAction:(id)sender;

@property (weak, nonatomic) IBOutlet UISwitch *notificationSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *remindersSwitch;

- (IBAction)helpButton:(id)sender;


@end
