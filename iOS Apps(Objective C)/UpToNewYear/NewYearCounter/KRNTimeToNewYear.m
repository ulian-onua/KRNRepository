//
//  KRNTimeToNewYear.m
//  NewYearCounter
//
//  Created by Drapaylo Yulian on 08.11.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//

#import "KRNTimeToNewYear.h"


@interface KRNTimeToNewYear ()

{
    NSTimer* timer; // таймер, который будет каждую секунду посылать сообщение делегату
    
    NSCalendar* gregorianCalendar; // грегорианский календарь
}




-(void) engineOfClass; // движок класса, который вычисляет дату до нового года и посылает сообщение делегату



@end

@implementation KRNTimeToNewYear

@synthesize nextNewYear = _nextNewYear;


-(long) nextNewYear
{
    NSDate *currentDate = [NSDate date]; // получаем текущую дату
    
    NSUInteger unitFlags = NSCalendarUnitYear;
    
    NSDateComponents *temp = [gregorianCalendar components:unitFlags fromDate:currentDate];

    
    return  (_nextNewYear = temp.year + 1);
}




-(id) initWithDelegate:(id<KRNTimeToNewYearDelegate>) delegate
{
    
    self = [super init];
    
    if (self)
    {
        _delegate = delegate;
        
        gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian]; // создаем грегорианский календарь
        
        [self engineOfClass]; // отрабатываем первый раз движок класса для определения текущего времени до нового года
        
        
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(engineOfClass) userInfo:nil repeats:YES];
                 
      
        
        
    }
    return self;
}


-(void) engineOfClass
{

    
    
    // собираем компоненты нового года
    NSDateComponents* newYear2015c = [[NSDateComponents alloc] init];
    newYear2015c.year = [self nextNewYear];
    newYear2015c.day  = 1;
    newYear2015c.month = 1;
    newYear2015c.hour = 0;
    newYear2015c.minute = 0;
    newYear2015c.second = 0;
    newYear2015c.nanosecond = 0;
    
    
    // получаем дату
    
    NSDate *newYear2015 = [gregorianCalendar dateFromComponents:newYear2015c];
    
    
    NSDate *currentDate = [NSDate date]; // получаем текущую дату
    
    NSUInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitNanosecond;
    
    _timeToNewYear = [gregorianCalendar components:unitFlags fromDate:currentDate toDate:newYear2015 options:0]; // получаем текущую дату
    
    if ([_delegate respondsToSelector:@selector(timeToNewYearWasChangedInSeconds:)])
        [self.delegate timeToNewYearWasChangedInSeconds:self]; // вызываем делегат
    

}


-(NSString*)getFormattedEnglishStringWithTimeToNewYear
{
    
NSString *month = [NSString stringWithFormat:@"%ld %@", (long)_timeToNewYear.month, [KRNEngLangTimeFunctions getEnglishWordForMonth:_timeToNewYear.month]];

    
NSString *days= [NSString stringWithFormat:@"%ld %@", (long)_timeToNewYear.day, [KRNEngLangTimeFunctions getEnglishWordForDay:_timeToNewYear.day]];
    
NSString *hours =[NSString stringWithFormat:@"%ld %@", (long)_timeToNewYear.hour,[KRNEngLangTimeFunctions getEnglishWordForHour:_timeToNewYear.hour]];

 NSString *minutes = [NSString stringWithFormat:@"%ld %@", (long)_timeToNewYear.minute, [KRNEngLangTimeFunctions getEnglishWordForMinute:_timeToNewYear.minute]];
    
NSString* seconds =[NSString stringWithFormat:@"%ld %@", (long)_timeToNewYear.second,
                         [KRNEngLangTimeFunctions getEnglishWordForSecond:_timeToNewYear.second]];

    
    return [NSString stringWithFormat:@"Time to New Year %ld left: %@, %@, %@, %@ and %@!", [self nextNewYear], month, days, hours, minutes, seconds];
    
}




@end
