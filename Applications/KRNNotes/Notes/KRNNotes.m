//
//  KRNNotes.m
//  Notes
//
//  Created by Drapaylo Yulian on 28.08.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//

#import "KRNNotes.h"


@interface KRNNotes()

@property (strong, nonatomic) NSMutableArray *arrayOfNotes; // массив отдельных записей

@end

@implementation KRNNotes

-(id) init
{
    self = [super init];
    
    if (self)
    {
        _arrayOfNotes = [[NSMutableArray alloc] init]; 
    }
    return self;
}

-(void) addNoteByString:(NSString*) str;
{
    KRNNote *tempNote = [[KRNNote alloc] initWithString:str]; //инициализируем объект записи как строку
    
    [_arrayOfNotes addObject:tempNote]; // добавляем новую запись в конец массива
}

- (NSString*) getNoteAsStringAtIndex:(NSUInteger) index // получить запись по индексу как строку

{
    if (index < _arrayOfNotes.count) // если введенный индекс не выходит за пределы границ массива записей
    {
    
        KRNNote* tempNote = [_arrayOfNotes objectAtIndex:index]; // получаем соответствующий объект записи
        
        return [tempNote getNote]; // возвращаем отдельную запись как строку
    }
    
    else return nil; // если индекс введен неправильно, то вернем nil
}

- (NSArray*) getAllNotesAsStringArray // вернуть все строки как массив строк

{
    NSMutableArray *tempStrArray = [[NSMutableArray alloc] init]; // временный строковый массив
    
    for (int i = 0; i < _arrayOfNotes.count; i++)
    {
        KRNNote* tempNote = [_arrayOfNotes objectAtIndex:i]; // получаем во временную переменную очередную запись
        [tempStrArray addObject:[tempNote getNote]]; // добавляем запись как строку в массив
    }
    
    return tempStrArray;
}

-(BOOL) deleteNoteAtIndex:(NSUInteger)index // удалить запись из массива записей
{
     if (index < _arrayOfNotes.count) // если введенный индекс не выходит за пределы границ массива записей
     {
         [_arrayOfNotes removeObjectAtIndex:index];
         return YES;
     }
    
    return NO;
}


@end
