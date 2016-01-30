//
//  KRNShareVkontakte.h
//  UpToNewYear
//
//  Created by Drapaylo Yulian on 15.01.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <VK-ios-sdk/VKSdk.h>
#import "KRNTimeToNewYear.h"
#import "AppDelegate.h"

@protocol KRNShareVkontakteProtocol;

@interface KRNShareVkontakte : NSObject<VKSdkDelegate>

@property (weak) VKSdk *vkSdk;

@property NSArray *vkScope;

@property (weak, nonatomic) id<KRNShareVkontakteProtocol> delegate;

-(id) init;

-(void) authorizeInVK;


@end


@protocol KRNShareVkontakteProtocol <NSObject>

-(void) performVKShareDialog:(VKShareDialogController*) dialogController;

@end