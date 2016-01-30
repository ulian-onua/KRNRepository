//
//  KRNShareTwitter.h
//  UpToNewYear
//
//  Created by Drapaylo Yulian on 16.01.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import <Foundation/Foundation.h>

// import Twitter SDK Libraries
#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>

// import UpToNewYearLibraries
#import "KRNTimeToNewYear.h"


@interface KRNShareTwitter : NSObject


+(BOOL) shareOnTwitterFromViewController:(UIViewController*)viewController;

@end
