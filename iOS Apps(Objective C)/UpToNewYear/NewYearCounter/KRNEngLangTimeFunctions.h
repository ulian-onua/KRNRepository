//
//  KRNEngLangTimeFunctions.h
//  NewYearCounter
//
//  Created by Drapaylo Yulian on 18.11.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KRNEngLangTimeFunctions : NSObject

+ (NSString*)getEnglishWordForMonth:(long) month;

+ (NSString*)getEnglishWordForDay:(long) day;

+ (NSString*)getEnglishWordForHour:(long) hour;

+ (NSString*)getEnglishWordForMinute:(long) minute;

+ (NSString*)getEnglishWordForSecond:(long) second;




@end
