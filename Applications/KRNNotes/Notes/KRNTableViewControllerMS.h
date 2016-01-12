//
//  KRNTableViewControllerMS.h
//  Notes
//
//  Created by Drapaylo Yulian on 28.08.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MyTableViewDataSource.h"

// импортируем View Controllerы, к которым будем переходить
#import "AddNoteViewController.h"
#import "ShowFullNoteViewController.h"


// Table View Controller MS (Main Screen) - View Controller главного экрана

@interface KRNTableViewControllerMS : UITableViewController

@property (strong, nonatomic) id<UITableViewDataSource> myDataSource; // объявим отдельно как property класс myDataSource, которому делегируем функции работы с данными


- (IBAction)unwindToTableVC:(UIStoryboardSegue *)segue; // метод, который вызывает при переходе (segue) типа unwind при нажатии кнопки "Добавить заметку


- (IBAction)unwindBackToTableVC:(UIStoryboardSegue *)segue; // "пустой" unwind метод, который вызывается при нажатии кнопки "Назад" и ничего не выполняет

@end
