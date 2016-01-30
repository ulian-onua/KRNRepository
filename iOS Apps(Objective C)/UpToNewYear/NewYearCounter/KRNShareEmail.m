//
//  KRNShareEmail.m
//  UpToNewYear
//
//  Created by Drapaylo Yulian on 11.01.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import "KRNShareEmail.h"


@interface KRNShareEmail()<MFMailComposeViewControllerDelegate>


@property (weak) UIViewController* rootViewController;


@end


@implementation KRNShareEmail

+(void) sendEmailTo:(NSString *)to withSubject:(NSString *)subject withBody:(NSString *)body
{
    
    
    NSString* letterBody;
    KRNTimeToNewYear* timeToNewYear = [[KRNTimeToNewYear alloc]initWithDelegate:nil];
    
    letterBody = [timeToNewYear getFormattedEnglishStringWithTimeToNewYear];
 
    
    
    
    
    NSString *mailString = [NSString stringWithFormat:@"mailto:?to=%@&subject=%@&body=%@",
                            [to stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]],
                            [subject stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]],
                            [letterBody stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]]
                            ];
    
    
    [letterBody stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mailString]];
}

-(void) shareEmailFromViewController:(UIViewController*)viewController
{
    _rootViewController = viewController;
    
    MFMailComposeViewController *mailController = [[MFMailComposeViewController alloc]init];
    
    KRNTimeToNewYear* timeToNewYear = [[KRNTimeToNewYear alloc]initWithDelegate:nil];
   
    [mailController setMailComposeDelegate:self];
    [mailController setSubject:@"Time To New Year Left"];
 //   [mailController setToRecipients:@[@"mailto:"]];
    [mailController setMessageBody:[timeToNewYear getFormattedEnglishStringWithTimeToNewYear] isHTML:NO];
    
    [_rootViewController presentViewController:mailController animated:YES completion:nil];
}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    [_rootViewController dismissViewControllerAnimated:YES completion:nil];

}



@end
