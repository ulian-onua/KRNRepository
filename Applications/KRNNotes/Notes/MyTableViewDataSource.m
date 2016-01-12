//
//  MyTableViewDataSource.m
//  ывф
//
//  Created by Drapaylo Yulian on 27.08.15.
//  Copyright (c) 2015 Drapaylo Yulian. All rights reserved.
//

#import "MyTableViewDataSource.h"


@implementation MyTableViewDataSource

-(id) init
{
    self = [super init];
    
    if (self)
    {
        self.numOfSections = 2; // создадим 3 секции
        
        self.rowsOfSection= [NSMutableArray arrayWithObjects:@1, @0, nil]; // аллоцируем и инициализируем NSMutable Array
        
        self.headersOfSection = [NSMutableArray arrayWithObjects:@"Добавить", @"Заметки", nil];
        self.notes = [[KRNNotes alloc] init]; // инициализируем записи
        
        self.db = [[DBManager alloc] initWithDatabaseFilename:@"notesdb1.sql"]; // инициализируем базу данных
        
        
        
        [self.db updateIndexesInTable:@"notes"];
       
        
        NSArray* temp = [self.db loadDataFromDB:@"select textnote from notes"];
        
        NSLog (@"%@", temp);
        
        for (int i = 0; i < temp.count; i++)
        {
           [self incrementRowsAtSection:1];
           
            NSArray *tempStr = [temp objectAtIndex:i]; // получаем вложенный массив (пока непонятно, почему их два вложенных
            
            [self.notes addNoteByString: [tempStr objectAtIndex:0]];
            
        }
       
    
        
        NSLog(@"");
        
    }
        
 
       
    return self;
}




-(void) addOneNotebyString:(NSString*) str // добавить одну заметку по строке
{
    [self.notes addNoteByString:str]; // добавляем введенный текст в объект данных
    [self incrementRowsAtSection:1];  // увеличиваем количество строк на одну в 1 секции
    
    // работает с базой данных
    NSString *query = [NSString stringWithFormat:@"insert into notes (textnote) values ('%@')", str];
    
    [self.db executeQuery:query];
    
    [self.db updateIndexesInTable:@"notes"];

}

-(BOOL) deleteOneNoteByIndex:(NSUInteger) index // удалить одну заметку по индексу
{
    
    
    
    if ( [self.notes deleteNoteAtIndex:index] ) // если удаление записи по индексу прошло успешно, то выполним дальнейшие действия
    {
        [self decrementRowsAtSection:1];
        // запрос к базе данных
        NSString *query = [NSString stringWithFormat:@"delete from notes where number=%d", index+1];
        
        [self.db executeQuery:query];
        [self.db updateIndexesInTable:@"notes"];

        return YES;
    }
    else
        return NO;
}

-(void) incrementRowsAtSection:(NSUInteger) section // увеличить количество строк на одну в секции
{
    NSNumber* currentNum = [self.rowsOfSection objectAtIndex:section]; // получаем текущее значение количества строк в секции
    
    NSNumber* newNum = [NSNumber numberWithInt:[currentNum integerValue] +1]; // получаем новое значения путем увеличения текущего на один
    
    [self.rowsOfSection replaceObjectAtIndex:section withObject:newNum]; // меняем объект NSNumber в массиве
    
    
   
}

-(void) decrementRowsAtSection:(NSUInteger) section
{
    NSNumber* currentNum = [self.rowsOfSection objectAtIndex:section]; // получаем текущее значение количества строк в секции
    
    NSNumber* newNum = [NSNumber numberWithInt:[currentNum integerValue] -1]; // получаем новое значения путем увеличения текущего на один
    [self.rowsOfSection replaceObjectAtIndex:section withObject:newNum]; // меняем объект NSNumber в массиве
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) // если секция - 0
    {
        UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"CellAddNote"];
        return cell;
    }
    else // если секция 1
    {
        KRNShowNoteCell* cell2 = [tableView dequeueReusableCellWithIdentifier:@"CellShowNote"];
      
        

        cell2.noteLabel.text = [self.notes getNoteAsStringAtIndex:indexPath.row]; // присваиваем краткое значение значение заметки нашей ячейке
        return cell2;
    
    }
}

#pragma mark - Количество строк и секций
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSNumber *tempNum = self.rowsOfSection[section]; // присваиваем временной переменной ссылку на количество строк в соответствующей секции
    
    return [tempNum integerValue]; // возвращаем Integer значение нашей переменной NSNumber, которая определяет количество строк в соответствующей секции
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView // количество секций в Table View    
{
    //#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return self.numOfSections; // возвращаем количество секций
}

#pragma mark - Настройка header и footer

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section 
{
    
  /*  if (self.headersOfSection.count > section) // если имена хедеров есть в массиве (т.е. кол-во элементом в нем меньше, чем номер секции
    {
    
            NSString* tempStr = self.headersOfSection[section]; // сохраняем хедер во временную строку
    
            return tempStr; // возвращаем строку
    }
        else
            return nil; // если имени хедера нет, то вернем nil и у секции не будет хедера (в соответствии с документацией Apple)
   */
    
    if (section == 1)
        return @"Заметки";
    else return nil;
    
}

- (NSString *)tableView:(UITableView *)tableView
titleForFooterInSection:(NSInteger)section // вернуть футер
{
    return nil; // возвращаем nil, поэтому футеров нет
}

#pragma mark - Получение Index Titles для секции

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView // cписок индексов в правой части экрана для быстрого доступа к отдельным секциям (как, например, в Контатах)
{
    return nil;
}

- (void) dealloc
{
    NSLog (@"The object is deallocated");
}

@end
