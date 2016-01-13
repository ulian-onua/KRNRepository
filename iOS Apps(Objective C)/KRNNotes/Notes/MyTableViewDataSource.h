//
//  MyTableViewDataSource.h
//  ывф
//
//  Created by Drapaylo Yulian on 27.08.15.
//  Copyright (c) 2015 Drapaylo Yulian. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

//импортируем классы заметок
#import "KRNNotes.h"
#import "KRNShowNoteCell.h"


//импортируем класс с менеджером базы данных SQLLite
#import "DBManager.h"


@interface MyTableViewDataSource : NSObject<UITableViewDataSource>


@property int numOfSections; // количество секций
@property (strong, nonatomic) NSMutableArray *rowsOfSection; // количество строк в каждой секции
@property (strong, nonatomic) NSMutableArray *headersOfSection; // хедеры соответствующих секций
@property (strong, nonatomic) KRNNotes* notes;  // заметки

@property (strong, nonatomic) DBManager *db; // файл с базой данных






//Методы для обработки данных Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; // количество строк в секции в Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; // количество секций в Table View


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; // возвращаем конкретную ячейку

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section; // название хедера в секции

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section; // название футера в секции



- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView;


// специфические методы данного класса

-(void) addOneNotebyString:(NSString*) str; // добавить одну заметку по строке

-(BOOL) deleteOneNoteByIndex:(NSUInteger) index; // удалить одну заметку по индексу


-(void) incrementRowsAtSection:(NSUInteger) section; // увеличить на одну количество строк в секции section

-(void) decrementRowsAtSection:(NSUInteger) section; // уменьшить на одну количество строк в секции section





@end
