//
//  KRNShareEmail.h
//  UpToNewYear
//
//  Created by Drapaylo Yulian on 11.01.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//


@import Foundation;
@import UIKit;
@import MessageUI;

#import "KRNTimeToNewYear.h"



@interface KRNShareEmail : NSObject

+(void) sendEmailTo:(NSString *)to withSubject:(NSString *)subject withBody:(NSString *)body;

-(void) shareEmailFromViewController:(UIViewController*)viewController;


@end
