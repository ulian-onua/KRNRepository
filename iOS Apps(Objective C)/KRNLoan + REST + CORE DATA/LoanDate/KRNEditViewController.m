//
//  KRNEditViewController.m
//  LoanDate
//
//  Created by Drapaylo Yulian on 05.12.15.
//  Copyright © 2015 Administrator. All rights reserved.
//

#import "KRNEditViewController.h"

@interface KRNEditViewController ()

@property (retain) dispatch_queue_t myQueue;

@end

@implementation KRNEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];

 
    
    _myQueue = dispatch_queue_create("com.LoanDate.myQueue", NULL);
    
    
    
}

- (void) viewWillAppear:(BOOL)animated
{
    // заполняем текстовые поля
    _personNameTextField.text = _currentPerson.name;
    _personActivityTextField.text = _currentPerson.activity_string;
    
    _idTextField.text = [_currentPerson.loan.loanId stringValue];
    _dataTextField.text = _currentPerson.loan.date;
    _loanAmountTextField.text = [_currentPerson.loan.loan_amount stringValue];
    _raiseTextField.text = [_currentPerson.loan.raise stringValue];
    _useTextField.text = _currentPerson.loan.use_string;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)saveButtonAction:(id)sender
{
    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    
     _currentPerson.name = _personNameTextField.text;
    
        
    NSLog(@"%@", _currentPerson.name);
    
    
    
    
    _currentPerson.activity_string = _personActivityTextField.text;
    
    _currentPerson.loan.loanId = [NSNumber numberWithInt: [_idTextField.text intValue]];
    
    
    _currentPerson.loan.date = _dataTextField.text;
    
    _currentPerson.loan.loan_amount = [NSNumber numberWithInt: [_loanAmountTextField.text intValue]];
    
    _currentPerson.loan.raise = [NSNumber numberWithInt: [_raiseTextField.text intValue]];
    
    _currentPerson.loan.use_string = _useTextField.text;

    dispatch_async(_myQueue, ^{
       [appDelegate saveContext];
    });
    
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
    
    
    
    
}
@end
