//
//  KRNTableViewControllerMS.m
//  Notes
//
//  Created by Drapaylo Yulian on 28.08.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//

#import "KRNTableViewControllerMS.h"

@implementation KRNTableViewControllerMS




- (void)viewDidLoad
{
    [super viewDidLoad];
    _myDataSource = [[MyTableViewDataSource alloc] init]; // инициализируем экземпляр объекта, который будет работать с данными
    self.tableView.dataSource = _myDataSource; // присваиваем указатель на этот экземпляр нашему tableView
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSNotificationCenter* tempNC = [NSNotificationCenter defaultCenter];
    
    [tempNC addObserver:self selector:@selector(ifDeleteButtonClicked:) name:ShowFullNoteVCTrashButtonPressed object:nil];
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableView methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == 0) ? 0 : 40; // если секция - 0, то хедер ей не нужен (там будет кнопка "Добавить заметку"), в противном случае размер хедера - 40 пунктов

}



- (void)tableView:(UITableView *)tableView
willDisplayHeaderView:(UIView *)view
       forSection:(NSInteger)section
{
    if (section == 1)
    view.tintColor = [UIColor yellowColor]; // меняем background цвет для нашего headerа
}

 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section == 1)
    {
        NSLog (@"Section1.row.selected");
    }

    
}


#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSUInteger rowSelected; // временная переменная, которая хранит индекс строки, которая была выбрана перед переходом
    
    if ([segue.identifier isEqualToString:@"sequeToFullNote"]) // если был осуществлен переход к View Controller, который выводит полный текст заметки, то нужно ему передать эту заметку с соответствующей строки
    {
        
        rowSelected = self.tableView.indexPathForSelectedRow.row; // сохраняем индекс строки, которая была нажата
        ShowFullNoteViewController *vc = [segue destinationViewController]; // получаем указатель на View Controller, который выводит полный текст заметки
        MyTableViewDataSource* tempSource = self.myDataSource; // во временную переменную получаем указатель на наш data source объект, чтобы можно было обращаться к его методам и свойствам без приведения типов
        vc.fullNote = [tempSource.notes getNoteAsStringAtIndex:rowSelected]; // получаем с dataSource объекта по индексу строки, которая была нажата, полный текст заметки и передаем его в NSString переменную View Controller'а, который будет выводить полный текст заметки
    }
}

- (IBAction)unwindToTableVC:(UIStoryboardSegue *)segue // используем unwind seque для возврата после ввода заметки
{
    AddNoteViewController *vc = [segue sourceViewController]; // сохраняем во временную переменную View Controller, с которого был осуществлен переход (это View Controller, на котором добавляем заметку)
        
    if (! [KRNTableViewControllerMS whitespacesOnlyInString:vc.noteField.text]) // если введеная заметка - не пустая (не состоит только из пробелов, то осуществим процедуры ее добавления в объект данных и вывода на экран
    {
        MyTableViewDataSource* tempSource = self.myDataSource;
        
        [tempSource addOneNotebyString:vc.noteField.text]; // добавляем заметку
        
        
        
        [self.tableView reloadData]; // перезагружаем данные в Table View
    }
}

- (IBAction)unwindBackToTableVC:(UIStoryboardSegue *)segue //пустой" unwind метод, который вызывается при нажатии кнопки "Назад" и ничего не выполняет
{
    
}

+ (BOOL) whitespacesOnlyInString:(NSString*) str
{
    NSString* tempStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return ([tempStr isEqualToString:@""]) ? YES : NO;
    
}




-(void) ifDeleteButtonClicked:(NSNotification*) notification // если нажата кнопка "Удалить ячейку",  то получаем соответствующую нотификацию
{
    
  //  NSUInteger *g = self.tableView.indexPathForSelectedRow.row;
    
  //  NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
    CGPoint tempPoint;
        
    
    CGPointMakeWithDictionaryRepresentation(CFBridgingRetain(notification.userInfo), &tempPoint);
    
    
    NSInteger row = [self.tableView indexPathForRowAtPoint:tempPoint].row; // определяем номер ячейки по заданным координатам
    
    MyTableViewDataSource *dataSource = self.myDataSource;
    
    [dataSource deleteOneNoteByIndex:row]; // удаляем запись по индексу
    
    
    [self.tableView reloadData];
    
    
    
    
//  NSLog (@"NSNotificationCenter: selected row: %d", indexPath.row);
    
}


@end
