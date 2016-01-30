//
//  ViewController.h
//  NewYearCounter
//
//  Created by Drapaylo Yulian on 08.11.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRNTimeToNewYear.h"

#import "KRNEngLangTimeFunctions.h"




#import <Fabric/Fabric.h>
#import <TwitterKit/TwitterKit.h>


@interface ViewController : UIViewController



@property (strong, nonatomic) KRNTimeToNewYear* timeToNewYear;


@property (weak, nonatomic) IBOutlet UILabel *monthsLabel;
@property (weak, nonatomic) IBOutlet UILabel *daysLabel;
@property (weak, nonatomic) IBOutlet UILabel *hoursLabel;
@property (weak, nonatomic) IBOutlet UILabel *minutesLabel;

@property (weak, nonatomic) IBOutlet UILabel *secondsLabel;

@property (weak, nonatomic) IBOutlet UIView *subViewUpLabel;

@property (weak, nonatomic) IBOutlet UIView *subViewCenterLabel;

@property (weak, nonatomic) IBOutlet UILabel *upLabel; // до Нового Года осталось

@property (weak, nonatomic) IBOutlet UILabel *numberOfNewYearLabel;


@end

