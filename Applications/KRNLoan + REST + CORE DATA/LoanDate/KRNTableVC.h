//
//  KRNTableVC.h
//  LoanDate
//
//  Created by Administrator on 03.12.15.
//  Copyright © 2015 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RequestObject.h"
#import "AppDelegate.h"
#import "Person.h"
#import "Location.h"
#import "Loan.h"

#import "ViewController.h"



extern NSString* const KRNCoreDataFilled; // заполнена ли Core Data?



@interface KRNTableVC : UITableViewController


@property (weak, nonatomic) IBOutlet UIBarButtonItem *reloadButton;


- (IBAction)reloadAction:(id)sender;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;


@end
