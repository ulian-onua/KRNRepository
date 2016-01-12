//
//  KRNNotes.h
//  Notes
//
//  Created by Drapaylo Yulian on 28.08.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KRNNote.h"

@interface KRNNotes : NSObject // класс, который управляет записями

-(id)init;

-(void)addNoteByString:(NSString*) str; // добавить запись путем передачи в метод строки

- (NSString*) getNoteAsStringAtIndex:(NSUInteger) index; // получит запись как строку по индексу

- (NSArray*) getAllNotesAsStringArray; // получить все записи как строковый массив

-(BOOL) deleteNoteAtIndex:(NSUInteger)index; // удалить запись по индексу


@end
