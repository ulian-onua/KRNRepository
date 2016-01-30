//
//  KRNRusLangTimeFunctions.h
//  NewYearCounter
//
//  Created by Drapaylo Yulian on 13.11.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KRNRusLangTimeFunctions : NSObject

+ (NSString*)getRussianWordForMonth:(long) month;

+ (NSString*)getRussianWordForDay:(long) day;

+ (NSString*)getRussianWordForHour:(long) hour;

+ (NSString*)getRussianWordForMinute:(long) minute;

+ (NSString*)getRussianWordForSecond:(long) second;


@end
