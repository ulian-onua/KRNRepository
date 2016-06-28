//
//  KRNDownloadsTVC.h
//  BrowserDrapaylo
//
//  Created by Drapaylo Yulian on 24.05.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "KRNDownloadTasksManager.h"
#import "KRNDownloadTableViewCell.h"

#import "KRNShowImageVC.h"
#import "KRNShowTextVC.h"
#import "KRNWebViewController.h"

#import "ODSSearchController.h"








@interface KRNDownloadsTVC : UITableViewController


@property (weak, nonatomic) AppDelegate *appDelegate;

@property (nonatomic, strong) ODSSearchController *searchController;



@end
