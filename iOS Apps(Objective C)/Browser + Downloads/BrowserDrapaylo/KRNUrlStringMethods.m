//
//  KRNUrlStringMethods.m
//  BrowserDrapaylo
//
//  Created by admin on 20.05.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import "KRNUrlStringMethods.h"

@implementation KRNUrlStringMethods


+(NSString*)getFileNameFromURL:(NSString*) url // возвращает имя и расширение файла для URL либо nil, если имя файла нельзя определить
{
    NSArray <NSString*> *stringComponents = [url componentsSeparatedByString:@"/"]; // компоненты всего URL
    
    if (stringComponents.count < 2)
        return nil;

    return [stringComponents lastObject];
    
    
}


// возвращает расширение файла для URL либо nil, если это нельзя сделать
+(NSString*)getFileExtensionFromURL:(NSString*) url
{
        NSArray <NSString*> *stringComponents = [url componentsSeparatedByString:@"."]; // компоненты всего URL
    if (stringComponents.count < 2)
        return nil;
    
    return [stringComponents lastObject];
}



+(NSString*) getCorrectFilePathForDublicate:(NSString*) path // функция возвращает правильный путь для дубликата пути path
{
    NSFileManager *fileMan = [NSFileManager defaultManager]; // получаем файловый менеджер
    
    NSString* fileFullName = [self getFileNameFromURL:path]; // получаем имя файла
    
   if (!fileFullName)
        return nil; // если не смогли вернуть имя файла, то вернем nil
    
    NSRange range = [path rangeOfString:@"/" options:NSBackwardsSearch];
    
    NSString* directoryPath = [path substringToIndex:range.location]; // возвращаем URL директории
    
    
   // NSString* directoryPath = [[path componentsSeparatedByString:@"/"] penultObject]; // возвращаем URL директории
    
  //  NSLog(@"DIRECTORY = %@", directoryPath);
    
    NSArray<NSString*> *fileParts = [fileFullName componentsSeparatedByString:@"."]; // части имени файла
    
    if (fileParts.count !=2 ) // ошибка в выделении частей файла
        return nil;
    
    NSString* fileName = [fileParts firstObject]; // имя файла расширение файла
    NSString* fileExtension  = [fileParts lastObject];
    NSLog(@"FILE EXT = %@", fileExtension);
    
    
    NSString* fileNamePattern = @"%@%d.%@"; // паттерн имени файла
    

    if (![fileMan fileExistsAtPath:path]) // если файла, путь которого введен - нет
    {
        for (int i = 1; i < INT32_MAX; i++)
        {
            NSString *newFileName = [NSString stringWithFormat:fileNamePattern, fileName, i, fileExtension]; // получаем новое имя файла
            
            
            NSString* newPath = [NSString stringWithFormat:@"%@/%@", directoryPath, newFileName]; // получаем новый путь
            
            if (![fileMan fileExistsAtPath:newPath]) // если по новому пути нет файла, то
            {
                return newPath; // возвращаем этот путь
            }
            
        }
        return nil; // свободного имени нет, все файлы записаны - вернем nil
    }
    
    
    return path; // введенный путь и так корректный
    
}

+(NSArray<NSString*>*) filterStringsArrayFromServiceFiles:(NSArray<NSString*>*)stringArray
{
    if (!stringArray)
        return nil;
    NSArray* arrayWithServiceFilesNames = @[@".DS_Store", @"Settings.plist"];
    
    
    NSMutableArray* tempArray = [NSMutableArray new];
    
    for (NSString* string in stringArray)
    {
        // если очередной строки нет в массиве с служебными именами файлов
        if ([arrayWithServiceFilesNames indexOfString:string] == NSNotFound)
            [tempArray addObject:string]; // добавим эту строку в новый массив
    }
        
    
    
    return [NSArray arrayWithArray:tempArray];
    
}

+(NSString*) getDocumentsDirectory // получить директорию документов
{
    static NSString* documentsDirectory = nil;
    
    if (!documentsDirectory)
    { 
        NSArray<NSString*> *directories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if (directories.count > 0)
            documentsDirectory = directories.firstObject;
    }
    return documentsDirectory;
}


@end


@implementation NSArray (NSArrayGetPenultObject)

-(instancetype) penultObject // вернуть предпоследний объект
{
    return [self objectAtIndex:self.count-2];
}

@end

@implementation NSArray (NSArrayStringSearch)

-(NSInteger) indexOfString:(NSString *)string
{
    for (int i = 0; i < self.count; i++)
    {
        NSString* nextString = [self objectAtIndex:i];
        if ([nextString isEqualToString:string]) // если найдено совпадение
            return i;
        
    }
    return NSNotFound; // совпадение на найдено
}

@end
