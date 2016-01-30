//
//  KRNRusLangTimeFunctions.m
//  NewYearCounter
//
//  Created by Drapaylo Yulian on 13.11.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//

#import "KRNRusLangTimeFunctions.h"


@interface KRNRusLangTimeFunctions ()

bool elevenFourteenCheck(long); // проверка является ли число в пределах 11-14, 111-114 и далее по закономерности
bool elevenNineteenCheck(long); // проверка является ли число в пределах 11-19, 111-119 и далее по закономерности

NSString* standardEngine(long value, NSArray <NSString*> *formatStrings); // основной "мотор" класса



@end

@implementation KRNRusLangTimeFunctions

+ (NSString*)getRussianWordForMonth:(long) month
{
    if (elevenFourteenCheck(month))
          return @"месяцев"; // 11 месяцев, 111 месяцев и т.д.
    
    return standardEngine(month, @[@"месяц", @"месяца", @"месяцев"]);
    
}

+ (NSString*)getRussianWordForDay:(long) day
{
    if (elevenFourteenCheck(day))
        return @"дней"; // 11  дней, 111 дней и т.д.
    
    return standardEngine(day, @[@"день", @"дня", @"дней"]);
    
}

+ (NSString*)getRussianWordForHour:(long) hour
{
    
    if (elevenFourteenCheck(hour))
        return @"часов"; // 11 часов, 111 часов и т.д.
    
     return standardEngine(hour, @[@"час", @"часа", @"часов"]);
    
}

+ (NSString*)getRussianWordForMinute:(long) minute
{

   if (elevenNineteenCheck(minute))
       return @"минут";
    
    return standardEngine(minute, @[@"минута", @"минуты", @"минут"]);
   

}

+ (NSString*)getRussianWordForSecond:(long) second
{
    
    if (elevenNineteenCheck(second))
        return @"секунд";

    return standardEngine(second, @[@"секунда", @"секунды", @"секунд"]);
    
}





bool elevenFourteenCheck(long num) // проверка является ли число в пределах 11-14, 111-114 и далее по закономерности
{
    bool check1 = num >= 11 && num <= 14; // 11, 12, 13, 14 дней
    bool check2 = num % 100 >= 11 && num % 100 <= 14;
    
    return check1 || check2;
}

bool elevenNineteenCheck(long num) // проверка является ли число в пределах 11-19, 111-119 и далее по закономерности

{
    bool check1 = num >= 11 && num <= 19; // 11, 12, 13, 14 дней
    bool check2 = num % 100 >= 11 && num % 100 <= 19;
    
    return check1 || check2;
}

NSString* standardEngine(long value, NSArray <NSString*> *formatStrings)
{
    switch (value % 10) // смотрим на последнее число
    {
        case 1:  // 1 месяц
            return formatStrings[0];
            break;
        case 2:
        case 3:
        case 4:
            return formatStrings[1]; // 2,3,4 - месяца
            break;
        default:
            return formatStrings[2]; // 0, 5-10  - месяцев
            break;
    }

}









@end
