//
//  KRNShareTwitter.m
//  UpToNewYear
//
//  Created by Drapaylo Yulian on 16.01.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import "KRNShareTwitter.h"

@implementation KRNShareTwitter

+(BOOL) shareOnTwitterFromViewController:(UIViewController*)viewController
{
    
    KRNTimeToNewYear* timeToNewYear = [[KRNTimeToNewYear alloc]initWithDelegate:nil];
    
    
    
    TWTRComposer *composer = [[TWTRComposer alloc] init];
    
    [composer setText:[timeToNewYear getFormattedEnglishStringWithTimeToNewYear]];
    
    
    
    [composer showFromViewController:viewController completion:^(TWTRComposerResult result) {
        if (result == TWTRComposerResultCancelled) {
            NSLog(@"Tweet composition cancelled");
        }
        else
        {

            NSLog(@"Sending Tweet!");
        }
    }];

    
    return YES;
}


@end
