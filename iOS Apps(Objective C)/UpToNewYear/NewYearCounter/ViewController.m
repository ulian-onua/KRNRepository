//
//  ViewController.m
//  NewYearCounter
//
//  Created by Drapaylo Yulian on 08.11.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//

#import "ViewController.h"
@import QuartzCore;

@interface ViewController ()<KRNTimeToNewYearDelegate>

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
   // [self.view setContentMode: UIViewContentModeScaleToFill];
    
        
    _timeToNewYear = [[KRNTimeToNewYear alloc] initWithDelegate:self]; // инициализируем делегата
    
    
    // работает над дизайном
  
    [_subViewUpLabel.layer setCornerRadius:20.f];

    
    [_subViewCenterLabel.layer setCornerRadius:20.f];


}

-(void)viewWillAppear:(BOOL)animated
{
    _numberOfNewYearLabel.text = [NSString stringWithFormat:@"%ld", [_timeToNewYear nextNewYear]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)timeToNewYearWasChangedInSeconds:(KRNTimeToNewYear*) timeToNewYear
{
    NSDateComponents *tempComponents = timeToNewYear.timeToNewYear;
    
    _upLabel.text = [NSString stringWithFormat:@"UP TO NEW YEAR"]; //], timeToNewYear.nextNewYear];
    
    
    
    _monthsLabel.text = [NSString stringWithFormat:@"%ld %@", (long)tempComponents.month, [KRNEngLangTimeFunctions getEnglishWordForMonth:tempComponents.month]];
    
    
    _daysLabel.text = [NSString stringWithFormat:@"%ld %@", (long)tempComponents.day, [KRNEngLangTimeFunctions getEnglishWordForDay:tempComponents.day]];
    
    _hoursLabel.text =[NSString stringWithFormat:@"%ld %@", (long)tempComponents.hour,[KRNEngLangTimeFunctions getEnglishWordForHour:tempComponents.hour]];
    
    _minutesLabel.text =[NSString stringWithFormat:@"%ld %@", (long)tempComponents.minute, [KRNEngLangTimeFunctions getEnglishWordForMinute:tempComponents.minute]];
    
    _secondsLabel.text =[NSString stringWithFormat:@"%ld %@", (long)tempComponents.second,
                         [KRNEngLangTimeFunctions getEnglishWordForSecond:tempComponents.second]];

}




@end
