//
//  KRNUrlStringMethods.h
//  BrowserDrapaylo
//
//  Created by admin on 20.05.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KRNUrlStringMethods : NSObject

+(NSString*)getFileNameFromURL:(NSString*) url; // возвращает имя и расширение файла для URL либо nil, если имя файла нельзя определить
+(NSString*)getFileExtensionFromURL:(NSString*) url; // возвращает расширение файла для URL либо nil, если это нельзя сделать

+(NSArray<NSString*>*) filterStringsArrayFromServiceFiles:(NSArray<NSString*>*)stringArray; //функция очищает массив строк от служебных файлов директорий (типа .DS_STORE и др.)

+(NSString*) getCorrectFilePathForDublicate:(NSString*) path; // функция возвращает правильный путь для дубликата пути path

+(NSString*) getDocumentsDirectory; // получить директорию документов

@end


@interface NSArray (NSArrayGetPenultObject) // получить предоследний объект

-(instancetype) penultObject; // вернуть предпоследний объект

@end


@interface NSArray (NSArrayStringSearch)
-(NSInteger) indexOfString:(NSString*) string; // функция возвращает первый найденный индекс строки в массиве строк. Если такая строка не найдена, то возвращается NSNotFound


@end
