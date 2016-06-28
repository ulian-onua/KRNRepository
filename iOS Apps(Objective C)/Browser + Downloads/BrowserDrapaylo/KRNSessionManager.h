//
//  KRNSessionManager.h
//  BrowserDrapaylo
//
//  Created by Drapaylo Yulian on 30.05.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KRNDownloadTask.h"
#import "KRNQueue.h"

@interface KRNSessionManager : NSObject<NSURLSessionDelegate>

@property (strong, nonatomic, readonly) NSURLSession *urlSession;

@property (strong, nonatomic) KRNQueue *pendingTasksQueue; // очередь с ожидающими задачами



-(id) initWithNumOfMaxTasks:(NSUInteger) maxTasks; // инициализировать с макс количеством загрузок

-(void) addDownloadTask:(KRNDownloadTask*) downloadTask; // добавить и запустить download task

-(void) changeValueOfMaxTasks:(NSUInteger) value; // изменить значения максимального количества загрузка

-(KRNDownloadTask*) getDownloadTaskWithURLSessionTaskID:(NSUInteger) sessionTaskID AndRemoveItFromArray:(BOOL)remove; // вернуть задание, в котором sessionTaskID равен введенному и опциально удалить его из массива

@end
