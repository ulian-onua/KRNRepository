//
//  KRNDownloadTasksManager.m
//  BrowserDrapaylo
//
//  Created by Drapaylo Yulian on 24.05.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import "KRNDownloadTasksManager.h"

static NSString* const plistName = @"Unfinishedtasks.dat";
static NSString* const unfinishedDownloadsSuffix = @".unfinished";

@implementation KRNDownloadTasksManager
{
    //NSOperationQueue *_operationQueue; // очередь операций
    KRNSessionManager* _sessionManager;
    NSString* _documentsDirectoryPath;
}



-(id) initWithMaxNumOfConcurentOperation:(NSUInteger)num // инициализировать с максимальным числом параллельных операций
{
    self = [super init];
    
    if (self)
    {
          _documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        
        
        _numOfMaxOperations = num;
        
        _sessionManager = [[KRNSessionManager alloc] initWithNumOfMaxTasks:_numOfMaxOperations];
        
        
        _tasks = [NSMutableArray new]; // cоздаем массив задач
        
    }
    return self;
}

// добавить задачу в загрузку
-(void) addTask:(KRNDownloadTask*) downloadTask // добавить задачу и запустить
{
    
    [_tasks insertObject:downloadTask atIndex:0]; // добавляем задачу в в начало массива
    
    // если реализован делегатный метод
    if ([_delegate respondsToSelector:@selector(downloadTaskManager:newTaskWasAdded:)])
    {
        dispatch_sync(dispatch_get_main_queue(), ^{
             [_delegate downloadTaskManager:self newTaskWasAdded:downloadTask];
        });
               
    }
        
    
    if (downloadTask.downloadStatus == KRNDownloadStatusInitialized) // если загрузка только инициализирована (уже не ставилась на закачку или не загружена)
    {
        
        [_sessionManager addDownloadTask:downloadTask]; // добавляем загрузку в сессию
            
    }
}

-(void) createNewTaskWithURLString:(NSString*) string // создать новую задачу и запустить с URL String
{
    KRNDownloadTask *downloadTask = [[KRNDownloadTask alloc]initWithURL:string];
    [self addTask:downloadTask];
}

-(BOOL) removeTask:(KRNDownloadTask*) downloadTask AndFromFileSystem:(BOOL) removeFromFileSystem
{

    if ([self.tasks containsObject:downloadTask]) // задача найдена
    {
        if (removeFromFileSystem) // если нужно удалить из файловой системы, то
        {
            [[NSFileManager defaultManager]removeItemAtPath:downloadTask.filePath error:nil];
        }
        
        [self.tasks removeObject:downloadTask];
        if (downloadTask.connectedURLSessionDownloadTask) // привыкаем к Swift-стилю - если есть связанный URL, то нужно совершить соответствующее действие
            [downloadTask.connectedURLSessionDownloadTask cancel]; // останавливаем связанный URLSessionDownloadTask
        


        return YES;
    }
    
    return NO;
}

-(NSArray<NSNumber*>*)checkTasksForRemovedFile
{
    NSMutableArray* returnedArray = [NSMutableArray new];
    
    for (int i = 0; i < self.tasks.count; i++)
    {
        if (self.tasks[i].downloadStatus == KRNDownloadStatusFinished || self.tasks[i].downloadStatus == KRNDownloadStatusLoadFromFile)
        {
        if (!self.tasks[i].checkFileExisting)
            [returnedArray addObject:[NSNumber numberWithInt:i]];
        }
    }
    
    if (returnedArray.count == 0)
        return nil;
    else
        return [NSArray arrayWithArray:returnedArray];
}

// установить максимальное число операций
-(void) setNumOfMaxOperations:(NSUInteger)numOfMaxOperations
{
    _numOfMaxOperations = numOfMaxOperations;
    [_sessionManager changeValueOfMaxTasks:_numOfMaxOperations];
  //  _operationQueue.maxConcurrentOperationCount = _numOfMaxOperations;
    
}

-(void)loadTasksFromDocumentsDirectory
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    
        NSArray <NSString*> *directoryContents = [self getDocumentsDirectoryContents];
 
        NSLog(@"DIRECTORY CONTENTS = %@", directoryContents);
        
        // инициализируем отдельные задания по пути из директории
        for (NSString* fileName in directoryContents)
        {
            NSString* fullFileName = [NSString stringWithFormat:@"%@/%@", _documentsDirectoryPath, fileName];
            KRNDownloadTask* downloadTask = [[KRNDownloadTask alloc] initWithFilePath:fullFileName];
            [self addTask:downloadTask];
        }
        
    });
}

-(void) saveUnfinishedTasksToLocalStore // сохраняем информацию о незавершенных заданиях в местное хранилище
{
//    NSMutableArray<NSString*> *array = [NSMutableArray new];
//    
//    // проверям задачи, которые сейчас находятся в загрузке
//    for (KRNDownloadTask *task in self.tasks) {
//        if (task.downloadStatus == KRNDownloadStatusInitialized || task.downloadStatus == KRNDownloadStatusDownloading)
//        {
//            [array addObject:task.url];
//        }
//    }
//    
    
    
    [_sessionManager.urlSession getTasksWithCompletionHandler:^(NSArray<NSURLSessionDataTask *> * _Nonnull dataTasks, NSArray<NSURLSessionUploadTask *> * _Nonnull uploadTasks, NSArray<NSURLSessionDownloadTask *> * _Nonnull downloadTasks) {
        
        for (NSURLSessionDownloadTask *downloadTask in downloadTasks)
        {
            KRNDownloadTask* krnDownloadTask = [_sessionManager getDownloadTaskWithURLSessionTaskID:downloadTask.taskIdentifier AndRemoveItFromArray:YES]; // получить таск
            
            if (krnDownloadTask)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
              
                    
                    [downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData)
                     {
                    
                         NSString* filePath = [[krnDownloadTask returnFilePathForURL:krnDownloadTask.url] stringByAppendingString:unfinishedDownloadsSuffix];
                         [resumeData writeToFile:filePath atomically:YES];
                    
                    }];
                });
            }
        }
        
        
    }];
    
    
    
}

-(void) loadUnfinishedTasksFromLocalStore // загружаем информацию о незавершенных заданиях из местного хранилища
{
      NSString* documentsDirectory = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject;
    NSArray<NSString*>* arrayWithTasksFilePath = [NSArray arrayWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", documentsDirectory, plistName]];
    
    for (NSString* path in arrayWithTasksFilePath) {
        [self createNewTaskWithURLString:path];
    }
    [[NSFileManager defaultManager] removeItemAtPath:[NSString stringWithFormat:@"%@/%@", documentsDirectory, plistName] error:nil];
    
}



-(NSArray <NSString*>*) getDocumentsDirectoryContents
{
 
    NSFileManager *fileMan = [NSFileManager defaultManager];
    
    NSError *error;
    NSArray <NSString*> *directoryContents = [fileMan contentsOfDirectoryAtPath:_documentsDirectoryPath error:&error];
    
    if (error)
    {
        NSLog(@"Error contents of documents directory = %@", error.localizedDescription);
        return nil;
    }
    return [KRNUrlStringMethods filterStringsArrayFromServiceFiles:directoryContents];
}

-(BOOL) addNewTasksFromDocumentsDirectory
{
    
    BOOL returnedValue = NO;
    
    NSArray <NSString*> *directoryContents = [self getDocumentsDirectoryContents];
    
    
    for (int i = 0; i < directoryContents.count; i++) // проверяем все пути файлов
    {
         NSString* fullFileName = [NSString stringWithFormat:@"%@/%@", _documentsDirectoryPath, directoryContents[i]];  // получаем полный путь файла
        
         BOOL newTaskFound = YES; // предположим, что новая задача найдена, что может быть опровергнуто в следующем цикле
        
         for (int i2 = 0; i2 < self.tasks.count; i2++)
         {
             NSString* taskPath = self.tasks[i2].filePath;
             
             if ([taskPath isEqualToString:fullFileName]) // если нашли уже файл задачи с таким же именем, то
             {
                 newTaskFound = NO;
                 break;
             }
             
         }
        
        if (newTaskFound) // если найдена новая задача, то нужно ее добавить
        {
               KRNDownloadTask* downloadTask = [[KRNDownloadTask alloc] initWithFilePath:fullFileName];
              [self addTask:downloadTask];
            returnedValue = YES;
        }
        
    }
    

    return returnedValue;
}

@end
