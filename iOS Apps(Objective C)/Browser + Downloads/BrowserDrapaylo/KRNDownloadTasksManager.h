//
//  KRNDownloadTasksManager.h
//  BrowserDrapaylo
//
//  Created by Drapaylo Yulian on 24.05.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KRNSessionManager.h"
#import "KRNDownloadTask.h"

// менеджер DownloadTask'ов, который отвечает за их загрузку




@protocol KRNDownloadTasksManagerDelegate;



@interface KRNDownloadTasksManager : NSObject

@property (atomic, readonly) NSMutableArray <KRNDownloadTask*> *tasks; // все задачи

@property (assign, nonatomic) NSUInteger numOfMaxOperations; // максимальное количество операций, выполняемых одновременно


@property (weak, nonatomic) id <KRNDownloadTasksManagerDelegate> delegate;



-(id) initWithMaxNumOfConcurentOperation:(NSUInteger)num; // инициализировать с максимальным числом параллельных операций
-(void) addTask:(KRNDownloadTask*) downloadTask; // добавить задачу и запустить
-(void) createNewTaskWithURLString:(NSString*) string; // создать новую задачу и запустить с URL String

// удалить задачу из списка задача, а также (опциально) из файловой системы
-(BOOL) removeTask:(KRNDownloadTask*) downloadTask AndFromFileSystem:(BOOL) removeFromFileSystem;

-(void)loadTasksFromDocumentsDirectory; // загрузить задачи из Documents Directory при первом запуске

-(BOOL) addNewTasksFromDocumentsDirectory; // добавить новые задачи из Documents Directory (если пользователь добавил файл через iTunes), если хотя бы одна из задач добавлена, то вернем true


-(void) saveUnfinishedTasksToLocalStore; // сохраняем информацию о незавершенных заданиях в местное хранилище

-(void) loadUnfinishedTasksFromLocalStore; // загружаем информацию о незавершенных заданиях из местного хранилища


-(NSArray<NSNumber*>*)checkTasksForRemovedFile; // функция проверяет задачи, не удален ли у них файл (это может сделать пользователь через айтюнс)
// функция возвращает массив, в котором содержатся номера taskов в соответствии с их нахождением в массиве
// если ни одного удаленного файла нет, то функция возвращает nil

@end


@protocol KRNDownloadTasksManagerDelegate <NSObject>

@optional

-(void) downloadTaskManager:(KRNDownloadTasksManager*) manager newTaskWasAdded:(KRNDownloadTask*)addedTask; // добавлена новая задача, сообщить делегату


@end
