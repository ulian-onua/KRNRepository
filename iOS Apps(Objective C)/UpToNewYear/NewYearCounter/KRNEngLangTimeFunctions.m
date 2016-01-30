//
//  KRNEngLangTimeFunctions.m
//  NewYearCounter
//
//  Created by Drapaylo Yulian on 18.11.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//

#import "KRNEngLangTimeFunctions.h"


@interface KRNEngLangTimeFunctions ()

NSString* classEngine (long numOfTime, NSString* timeWord);

@end


@implementation KRNEngLangTimeFunctions

+ (NSString*)getEnglishWordForMonth:(long) month
{
    return classEngine(month, @"month");
}

+ (NSString*)getEnglishWordForDay:(long) day
{
   return classEngine(day, @"day");
}

+ (NSString*)getEnglishWordForHour:(long) hour
{
    return classEngine(hour, @"hour");
}

+ (NSString*)getEnglishWordForMinute:(long) minute
{
    return classEngine(minute, @"minute");
}

+ (NSString*)getEnglishWordForSecond:(long) second
{
    return classEngine(second, @"second");
}

        
        
NSString* classEngine(long numOfTime, NSString* timeWord)
{
    if (numOfTime == 1)
        return timeWord;
    else
        return [NSString stringWithFormat:@"%@s", timeWord];
}

@end




