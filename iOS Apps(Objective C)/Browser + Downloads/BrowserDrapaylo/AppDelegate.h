//
//  AppDelegate.h
//  BrowserDrapaylo
//
//  Created by Drapaylo Yulian on 05.08.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "KRNDownloadTasksManager.h"
#import "KRNAppSettings.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) KRNAppSettings* appSettings;


@property (strong, nonatomic) KRNDownloadTasksManager *taskManager;





@end

