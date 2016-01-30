//
//  KRNOptionsTableVCTableViewController.m
//  UpToNewYear
//
//  Created by Drapaylo Yulian on 25.11.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//

#import "KRNOptionsTableVC.h"

@interface KRNOptionsTableVC ()<VKSdkUIDelegate, KRNNotificationsErrorHandlingProtocol>

{
    dispatch_queue_t _tempQueue;
}

@property KRNShareVkontakte* shareVK;

@property (strong, nonatomic) KRNShareEmail *shareEmail;
@property (strong, nonatomic) KRNShareSMS *shareSms;



@end

@implementation KRNOptionsTableVC

#pragma mark - Table View Controller Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // инициализация переключателей с NSDefaults
    NSNumber *tempNum = [[NSUserDefaults standardUserDefaults] objectForKey:KRNNotificationsOn];
    
    
    _notificationSwitch.on = [tempNum boolValue];
    
    tempNum = [[NSUserDefaults standardUserDefaults] objectForKey:KRNRemindersOn];
    
    _remindersSwitch.on = [tempNum boolValue];
    
    
    _shareVK = [[KRNShareVkontakte alloc]init];
    
    _shareVK.delegate = self;
    _shareVK.vkSdk.uiDelegate = self;
    
    _shareEmail = [KRNShareEmail new];
    _shareSms = [KRNShareSMS new];
    
    
    
      _tempQueue = dispatch_queue_create("com.DrapayloYulian.tempQueue", DISPATCH_QUEUE_CONCURRENT);
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {
        
        if (indexPath.row == 0)
        {
            
            
            [_shareSms shareSMSFromViewController:self];
            
        }
        
        else if (indexPath.row == 1)
        {
            [KRNShareTwitter shareOnTwitterFromViewController:self]; // расшарить в твиттере
        }
        
        else if (indexPath.row == 2) // в контакте
        {
            [_shareVK authorizeInVK]; // расшарить в контакте
        }
        
        else if (indexPath.row == 3) // send Email
        {
            [_shareEmail shareEmailFromViewController:self];
        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}





#pragma mark - Actions Methods

- (IBAction)backButtonAction:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)notificationsSwitchAction:(id)sender
{
    
    UISwitch *tempSwitch = (UISwitch *) sender;
    
    if ([tempSwitch isOn]) // если свитч был включен
        [KRNNotifications addNotificationsWithErrorHadlingDelegate:self]; // добавим нотификации
    else
        
    {
        [KRNNotifications removeNotifications]; // удалить нотификации
    
    // сохраняем User Defaults
        [self saveInUserDefaultsKey:KRNNotificationsOn BoolValue:NO WithQueue:_tempQueue];
    
    }
    
    
    
}




- (IBAction)remindersSwitchAction:(id)sender
{
    UISwitch *tempSwitch = (UISwitch*) sender;
    
    if ([tempSwitch isOn])
        [KRNReminders addReminderWithErrorBlock:^(NSError *error)
    {
        [self performRemindersErrorBlock:error WithSwitch:tempSwitch andChangeSwitchOption:YES];
        
        }];
        else
            
        [KRNReminders removeReminderWithErrorBlock:^(NSError *error) {
            
            [self performRemindersErrorBlock:error WithSwitch:tempSwitch andChangeSwitchOption:NO];
        }];
    
    

}


-(void) errorAddingLocalNotification:(NSError*) error
{
    [self showAlertControllerWithNSError:error];
    _notificationSwitch.on = NO;
    
}

-(void) succeedInAddingLocalNotification // локальная нофикация успешно добавлена
{
    // сохраняем User Defaults, используя отдельный поток
    
    NSLog(@"dispatchFuncCalled");
    
    
    [self saveInUserDefaultsKey:KRNNotificationsOn BoolValue:YES WithQueue:_tempQueue];
    

}


#pragma mark - VK UIDelegateMethods


-(void) performVKShareDialog:(VKShareDialogController*) dialogController
{
    
    [dialogController setCompletionHandler:^(VKShareDialogController *dialogContr, VKShareDialogControllerResult result) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    
    [self presentViewController:dialogController animated:YES completion:nil]; //6
}


- (void)vkSdkShouldPresentViewController:(UIViewController *)controller
{
    [self presentViewController:controller animated:YES completion:^{

    }];
}

- (void)vkSdkNeedCaptchaEnter:(VKError *)captchaError
{
    NSLog(@"VK SDK Capctcha");
}


#pragma mark - Private help methods


-(void) showAlertControllerWithNSError:(NSError*)error
{
    NSString* alertControllerMessage = (error.localizedRecoverySuggestion == nil) ? error.localizedFailureReason : [NSString stringWithFormat:@"%@ %@", error.localizedFailureReason, error.localizedRecoverySuggestion];
    
    
    [self showAlertControllerWithTitle:error.localizedDescription Message:alertControllerMessage andButtonTitle:@"Close"];
}

-(void) showAlertControllerWithTitle:(NSString*) title Message:(NSString*) message andButtonTitle:(NSString*) buttonTitle  // показать соответствующий аlert controller или alert view с единичной опцией выбора
{
    
    if ([UIAlertController class]) // если класс UIAlertController поддерживается
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController* myAlertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle: UIAlertControllerStyleAlert];
            
            [myAlertController addAction:[UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [myAlertController dismissViewControllerAnimated:YES completion:nil];
            }]];
            
            [self presentViewController:myAlertController animated:YES completion:nil];
            
        });
    }
    
}

-(void) performRemindersErrorBlock:(NSError*) error WithSwitch: (UISwitch*) tempSwitch andChangeSwitchOption:(BOOL)changeSwitchOption
{
    
    if (error == nil) // если ошибок нет, то cохраним результат в User Defaults;
    {
        [self saveInUserDefaultsKey:KRNRemindersOn BoolValue:tempSwitch.on WithQueue:_tempQueue];
    }
    
    else // если ошибки есть
    {
        
        if ([error.domain isEqualToString:KRNRemindersErrorDomain])
        {
            switch (error.code)
            {
                case KRNRemindersErrorAccessNotGranted:
                {
                    [self showAlertControllerWithTitle:@"Error. Access is not granted" Message:@"You didn't grant access to Reminders." andButtonTitle:@"Close"];
                    
                    
                    break;
                }
                    
                case KRNRemindersErrorAuthorizationStatusRestricted:
                {
                    [self showAlertControllerWithTitle:@"Error. Access is restricted." Message:@"Possibly, parental control is on" andButtonTitle:@"Close"];
                    
                    break;
                }
                    
                case KRNRemindersErrorAuthorizationStatusDenied:
                {
                    [self showAlertControllerWithTitle:@"Error. Access is denied." Message:@"Go to Settings->Privacy->Reminders and allow access to this app" andButtonTitle:@"Close"];
                    
                    break;
                }
                case KRNRemindersErrorReminderWasntFoundInEventStore:
                {
                    [self showAlertControllerWithTitle:error.localizedDescription Message:error.localizedFailureReason andButtonTitle:@"Close"];
                    break;
                }
                    
                default:
                    
                    break;
                    
            }
            if (changeSwitchOption == YES)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    tempSwitch.on = (tempSwitch.on == YES) ? NO : YES;
                    
                });
            }
        }
        
        else // если какая-то другая ошабика
        {
            [self showAlertControllerWithTitle:@"Error" Message:error.localizedDescription andButtonTitle:@"Close"];
        }
    }
    
    
}

-(void) saveInUserDefaultsKey:(NSString*)key BoolValue:(BOOL) value WithQueue:(dispatch_queue_t) queue
{
    dispatch_async(queue, ^{
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:value] forKey:key];
    });

}

- (IBAction)helpButton:(id)sender
{
    KRHHelpViewController *viewController = [KRHHelpViewController new];
    
    [self.navigationController pushViewController:viewController animated:YES];

  
    
}
@end
