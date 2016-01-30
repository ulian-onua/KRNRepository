//
//  KRNShareVkontakte.m
//  UpToNewYear
//
//  Created by Drapaylo Yulian on 15.01.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import "KRNShareVkontakte.h"


@interface KRNShareVkontakte ()



@end


@implementation KRNShareVkontakte



-(id) init
{
    self = [super init];
    
    if (self)
    {
        AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
        _vkSdk = appDelegate.vkSdk;
        
        [_vkSdk registerDelegate:self];
        [VKSdk forceLogout];
        _vkScope = @[@"wall"];
        
        

    }
    
    return self;
}


- (void) authorizeInVK
{
   
    
    
    [VKSdk wakeUpSession:_vkScope completeBlock:^(VKAuthorizationState state, NSError *error)
    {
       
        if (state == VKAuthorizationAuthorized) {
            NSLog(@"VK session authorized");
            [self performShareDialog];
            
        } else
        {
           [VKSdk authorize:_vkScope];
        }
    }];
    
    
    
 //[VKSdk authorize:_vkScope];

    
    
    
//    VKAuthorizationOptionsUnlimitedToken = 1 << 0,
//    VKAuthorizationOptionsDisableSafariController = 1 << 1,
    
    
//    VKShareDialogController * shareDialog = [VKShareDialogController new]; //1
//    shareDialog.text         = @"TEST"; //2
//     [_delegate performVKShareDialog:shareDialog];
  
    
}


- (void)vkSdkAccessAuthorizationFinishedWithResult:(VKAuthorizationResult *)result
{
    NSLog(@"VK Autorization is finished");
    
    if (result.error)
    {
        NSLog(@"Error: %@", result.error.localizedDescription);
    }
    
    else
    {
        [self performShareDialog];        
       
    }
  
    
    

    
}

-(void) performShareDialog
{
      VKShareDialogController * shareDialog = [VKShareDialogController new]; //1
    KRNTimeToNewYear* tempTimeToNewYear = [[KRNTimeToNewYear alloc]initWithDelegate:nil];
    
    shareDialog.text = [tempTimeToNewYear getFormattedEnglishStringWithTimeToNewYear];
    shareDialog.requestedScope = [[VKSdk accessToken] permissions];
    
    NSLog(@"Permissions = %@", [[VKSdk accessToken] permissions]);
    
    
    [_delegate performVKShareDialog:shareDialog];;
}

- (void)vkSdkUserAuthorizationFailed
{
    NSLog(@"Autorization failed");
}

- (void)vkSdkAccessTokenUpdated:(VKAccessToken *)newToken oldToken:(VKAccessToken *)oldToken
{
  //  NSLog(@"VK Access TOken updated");
   
}

@end
