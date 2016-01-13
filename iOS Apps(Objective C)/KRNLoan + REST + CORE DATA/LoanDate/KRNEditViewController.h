//
//  KRNEditViewController.h
//  LoanDate
//
//  Created by Drapaylo Yulian on 05.12.15.
//  Copyright © 2015 Administrator. All rights reserved.
//

#import "AppDelegate.h"

#import <UIKit/UIKit.h>

#import "Person.h"
#import "Loan.h"
#import "Location.h"

@interface KRNEditViewController : UIViewController

@property (strong) Person *currentPerson; // слабая ссылка на клиента, который хранится в массиве результатов запроса в Core Data в предыдущем контроллере



// person Info Properties - Outlets
@property (weak, nonatomic) IBOutlet UITextField *personNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *personActivityTextField;

// Loan Info Properties - Outlets

@property (weak, nonatomic) IBOutlet UITextField *idTextField;

@property (weak, nonatomic) IBOutlet UITextField *dataTextField;

@property (weak, nonatomic) IBOutlet UITextField *loanAmountTextField;

@property (weak, nonatomic) IBOutlet UITextField *raiseTextField;

@property (weak, nonatomic) IBOutlet UITextField *useTextField;

//save Result
- (IBAction)saveButtonAction:(id)sender;



@end
