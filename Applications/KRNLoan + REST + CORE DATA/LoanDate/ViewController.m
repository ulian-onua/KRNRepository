//
//  ViewController.m
//  LoanDate
//
//  Created by Administrator on 03.12.15.
//  Copyright © 2015 Administrator. All rights reserved.
//

//  loan - сколько он хочет
// raise - сколько ему дали

#import "ViewController.h"

@interface ViewController ()
@property CLLocationCoordinate2D coordinate;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    
    _coordinate = [self parsePersonGeoLocationFromString:_currentPerson.location.geo];
    
    
   // добавить Pin
     MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:_coordinate];
    [annotation setTitle:@"Person's Location"]; //You can set the subtitle too
    [_locationMap addAnnotation:annotation];
    
    
    // перейти к Pinu на карте
    
    [_locationMap showAnnotations:@[annotation] animated:YES];
    
    

}

-(void) viewWillAppear:(BOOL)animated
{
    _personName.text = [NSString stringWithFormat:@"Person name: %@", _currentPerson.name];
    _personActivity.text = [NSString stringWithFormat:@"Person activity: %@", _currentPerson.activity_string];
  
    // заполняем данные о займе
    _loanId.text = [NSString stringWithFormat:@"ID: %@", [_currentPerson.loan.loanId stringValue]];
    

    _loanDate.text = [NSString stringWithFormat:@"Date: %@", _currentPerson.loan.date];
    _loanAmount.text = [NSString stringWithFormat:@"Loan Amount: %@", [_currentPerson.loan.loan_amount stringValue]];
    
    _raise.text = [NSString stringWithFormat:@"Raise: %@", [_currentPerson.loan.raise stringValue]];
    
    _use.text = [NSString stringWithFormat:@"Date: %@", _currentPerson.loan.use_string];
   
}
    
    

    


- (CLLocationCoordinate2D) parsePersonGeoLocationFromString:(NSString*) string
{
    CLLocationCoordinate2D tempCoordinate = {0};
    
    NSString* latitudeStr= [string substringToIndex:[string rangeOfString:@" "].location];
    
    tempCoordinate.latitude = [latitudeStr doubleValue];
    
    NSString* longtitudeStr = [string substringFromIndex:[string rangeOfString:@" "].location];
    
    tempCoordinate.longitude = [longtitudeStr doubleValue];
    
    
    return tempCoordinate;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"editClientPush"])
    {
        KRNEditViewController* destVC = [segue destinationViewController];
        
        destVC.currentPerson = _currentPerson;
        
    }
    
}

@end
