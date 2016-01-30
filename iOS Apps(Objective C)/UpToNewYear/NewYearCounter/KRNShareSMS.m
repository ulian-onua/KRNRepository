//
//  KRNShareSMS.m
//  UpToNewYear
//
//  Created by Drapaylo Yulian on 16.01.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import "KRNShareSMS.h"

@interface KRNShareSMS()<MFMessageComposeViewControllerDelegate>


@property (weak) UIViewController* rootViewController;


@end

@implementation KRNShareSMS



-(void) shareSMSFromViewController:(UIViewController*)viewController
{


MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    
if([MFMessageComposeViewController canSendText])
{
    _rootViewController = viewController;
    KRNTimeToNewYear* timeToNewYear = [[KRNTimeToNewYear alloc]initWithDelegate:nil];
    
    controller.body = [timeToNewYear getFormattedEnglishStringWithTimeToNewYear];
    //controller.recipients = [NSArray arrayWithObjects:@"1(234)567-8910", nil];
    controller.messageComposeDelegate = self;
    [_rootViewController presentViewController:controller animated:YES completion:nil];
    
}

}


- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    [_rootViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
