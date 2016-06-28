//
//  KRNSessionManager.m
//  BrowserDrapaylo
//
//  Created by Drapaylo Yulian on 30.05.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import "KRNSessionManager.h"

@interface KRNSessionManager()
{
    NSMutableArray<KRNDownloadTask*> *_downloadTasks; // массив, в котором хранятся download таски, находящиеся в процессе загрузки
    NSUInteger _maxOfDownloadTasksCount;
    
    
}

@end

@implementation KRNSessionManager 

-(id) initWithNumOfMaxTasks:(NSUInteger) maxTasks
{
    self = [super init];
    
    if (self)
    {
        NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    
        _maxOfDownloadTasksCount = maxTasks;
        _urlSession = [NSURLSession sessionWithConfiguration: sessionConfig delegate:self delegateQueue:nil];
     
        _downloadTasks = [NSMutableArray new];
        _pendingTasksQueue = [[KRNQueue alloc] init];

    }
    return self;
}

-(void) addDownloadTask:(KRNDownloadTask*) downloadTask // добавить и запустить download task
{
    if (_downloadTasks.count < _maxOfDownloadTasksCount) // если количество  тасков в массиве меньше, чем максимальное, то добавим задачу на загрузку
    {
        [self startDownloadTaskOperations:downloadTask];
    }
    
    else // иначе, если максимальное количество задач уже загружено, то
    {
        [downloadTask setPendingStatus]; // установить, что загрузка находится в статусе ожидания
        [_pendingTasksQueue addObject:downloadTask]; // добавляем объект в очередь загрузки
    }
    
    
}


-(void)startDownloadTaskOperations:(KRNDownloadTask*) downloadTask
{
    NSURLSessionDownloadTask *sessionDownloadTask = downloadTask.connectedURLSessionDownloadTask; // download task
    
    if (!sessionDownloadTask) // если нет связанной URL Download Task, то нужно создать новую
    {
    
     sessionDownloadTask = [_urlSession downloadTaskWithURL:[NSURL URLWithString: downloadTask.url]]; // создаем задачу для загрузки
    
    downloadTask.connectedURLSessionDownloadTask = sessionDownloadTask; // связываем downloadTask
    
    downloadTask.sessionDownloadTaskIdentifier = sessionDownloadTask.taskIdentifier; // присваиваем ID Taska нашему KRNDownloadTaske
    }
    
    
    
    [_downloadTasks addObject:downloadTask];
    
    [downloadTask start]; // инициализируем KRNDownload Task как запущенный
    
    [sessionDownloadTask resume]; // запускаем задачу

}

-(void) checkQueueForDownloadTasks // обработать очередь, в случае изменения максимальное количества параллельных загрузок
{
    KRNDownloadTask* nextTask;
    
    while (_downloadTasks.count < _maxOfDownloadTasksCount)
    {
        if ((nextTask = [_pendingTasksQueue getObject]))
            [self startDownloadTaskOperations:nextTask];
        else
            break;
    }
}

-(void) suspendTasksToLimitMaxDownloadTasks
{
    [_urlSession getTasksWithCompletionHandler:^(NSArray<NSURLSessionDataTask *> * _Nonnull dataTasks, NSArray<NSURLSessionUploadTask *> * _Nonnull uploadTasks, NSArray<NSURLSessionDownloadTask *> * _Nonnull downloadTasks) {
        
        NSArray<NSURLSessionDownloadTask *>* runningURLdownloadTasks = [downloadTasks filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.state  == %d",  (int)NSURLSessionTaskStateRunning ]]; // отфильтровываем все download таски
        
        
        if (runningURLdownloadTasks.count > _maxOfDownloadTasksCount) // если количество загружающихся тасков больше, чем возможно на данный момент, то
        {
            for (int i = 0; i < runningURLdownloadTasks.count - _maxOfDownloadTasksCount; i++)
            {
                [runningURLdownloadTasks[i] suspend]; // приостанавливаем задачу
                KRNDownloadTask* connectedDownloadTask = [self findConnectedDownloadTaskForNSURLSessionTask:runningURLdownloadTasks[i]];
                [connectedDownloadTask setPendingStatus];
                [_downloadTasks removeObject:connectedDownloadTask];
                [_pendingTasksQueue addObject:connectedDownloadTask];
                
                
                //найти соответствующий KRNDownloadTask и выполнить соответствующие действия
            }
                
        }
        
        NSLog(@"RUNNING DOWNLOAD TASK: %@", runningURLdownloadTasks);
        
    }];
}


// найти связанные с urlSessionTask'ом KRNDownloadTask
-(KRNDownloadTask*) findConnectedDownloadTaskForNSURLSessionTask:(NSURLSessionDownloadTask *) urlSessionTask
{
    NSArray* filteredArray = [_downloadTasks filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:
                                                                          @"SELF.sessionDownloadTaskIdentifier == %d", urlSessionTask.taskIdentifier]];
    if (filteredArray.count > 0)
        return filteredArray[0];
    else
        return 0;
}

-(void) changeValueOfMaxTasks:(NSUInteger) value
{
    if (value > _maxOfDownloadTasksCount) // если новое значение количества заданий больше того, которое было, то нужно проверить очередь
    {
        _maxOfDownloadTasksCount = value;
        [self checkQueueForDownloadTasks];
    }
    else
        if (value < _maxOfDownloadTasksCount) // если новое значение меньше того, которое было, то нужно
        {
            _maxOfDownloadTasksCount = value;
           [self suspendTasksToLimitMaxDownloadTasks]; // приостановить некоторые задания
        }
  
   
}

#pragma mark - Private Methods

-(KRNDownloadTask*) getDownloadTaskWithURLSessionTaskID:(NSUInteger) sessionTaskID // вернуть задание, в котором sessionTaskID равен введенному и удалить его из массива
{
    return [self getDownloadTaskWithURLSessionTaskID:sessionTaskID AndRemoveItFromArray:YES];
}

-(KRNDownloadTask*) getDownloadTaskWithURLSessionTaskID:(NSUInteger) sessionTaskID AndRemoveItFromArray:(BOOL)remove // вернуть задание, в котором sessionTaskID равен введенному и опциально удалить его из массива
{
    for (int i = 0; i < _downloadTasks.count; i++)
    {
        if (_downloadTasks[i].sessionDownloadTaskIdentifier == sessionTaskID)
        {
            KRNDownloadTask* findedTask = _downloadTasks[i];
            if (remove)
            {
                [_downloadTasks removeObjectAtIndex:i];
            }
            return findedTask;
        }
    }
    
    
    return nil; // задание не найдено
}


#pragma mark - NSURLSessionDelegate methods

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    NSLog(@"DOWNLOAD TASK IS RESUMED");
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
    NSLog(@"BYTES EXPECTED");
    KRNDownloadTask* KRNdownloadTask = [self getDownloadTaskWithURLSessionTaskID:downloadTask.taskIdentifier AndRemoveItFromArray:NO]; /// получаем загрузку по идентификатору
    
    if ([KRNdownloadTask.delegate respondsToSelector:@selector(downloadTask:percentWritten:)])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"PERCENT = %lld", totalBytesWritten/totalBytesExpectedToWrite);
            [KRNdownloadTask.delegate downloadTask:KRNdownloadTask percentWritten:(float)totalBytesWritten/totalBytesExpectedToWrite];
            
        });
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
     KRNDownloadTask* KRNdownloadTask = [self getDownloadTaskWithURLSessionTaskID:downloadTask.taskIdentifier AndRemoveItFromArray:YES];
    

    [KRNdownloadTask performOperationsForDownloadedTaskWithLocation:location];

    
    dispatch_async(dispatch_get_main_queue(), ^{
         if (_downloadTasks.count < _maxOfDownloadTasksCount) // если количество задач меньше, чем максимальное
         {
             KRNDownloadTask *downloadTask = [_pendingTasksQueue getObject]; // получаем последний объект
             if (downloadTask) // если он есть
             {
                 [self startDownloadTaskOperations:downloadTask]; // начинаем новую загрузку
             }
         }
         
     });
        
}

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error
{
    NSLog(@"SESSION TASK ERROR");
    NSLog(@"Error = %@", error.localizedDescription);
    KRNDownloadTask* KRNdownloadTask = [self getDownloadTaskWithURLSessionTaskID:task.taskIdentifier AndRemoveItFromArray:YES];
    
    [KRNdownloadTask performOperationsForCompletedTaskWithError];
    
}


@end
