//
//  ViewController.h
//  LoanDate
//
//  Created by Administrator on 03.12.15.
//  Copyright © 2015 Administrator. All rights reserved.
//

#import <UIKit/UIKit.h>

@import MapKit;
#import "Person.h"
#import "Loan.h"
#import "Location.h"

#import "KRNEditViewController.h"



@interface ViewController : UIViewController

@property (strong) Person *currentPerson; // слабая ссылка на клиента, который хранится в массиве результатов запроса в Core Data в предыдущем контроллере


// Person Info Outlets
@property (weak, nonatomic) IBOutlet UILabel *personName;
@property (weak, nonatomic) IBOutlet UILabel *personActivity;

// Loan Info Outlets

@property (weak, nonatomic) IBOutlet UILabel *loanId;
@property (weak, nonatomic) IBOutlet UILabel *loanDate;
@property (weak, nonatomic) IBOutlet UILabel *loanAmount;
@property (weak, nonatomic) IBOutlet UILabel *raise;
@property (weak, nonatomic) IBOutlet UILabel *use;

// Geo Info Outlets

@property (weak, nonatomic) IBOutlet MKMapView *locationMap;

@end

