//
//  KRNDownloadTask.h
//  BrowserDrapaylo
//
//  Created by admin on 20.05.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KRNUrlStringMethods.h"

@class NSURLSessionDownloadTask;



extern NSString* const KRNDownloadTaskIsFinished; // загрузка завершена
extern NSString* const KRNDownloadTaskIsCompletedWithError;

typedef NS_ENUM(NSUInteger, KRNDownloadStatus)
{
    KRNDownloadStatusInitialized, // класс загрузки только инициализирован, никаких дальнейших действий не происходит
    KRNDownloadStatusPending, // загрузка находится в очереди (в состоянии ожидания)
    KRNDownloadStatusDownloading, // загрузка идет
    KRNDownloadStatusFinished, // загрузка завершена,
    KRNDownloadStatusLoadFromFile, // загрузка уже завершена ранее (в прошлом запуске приложения) и сейчас просто выгружена с диска
    KRNDownloadStatusInterrupted // загрузка прервана
};

typedef NS_ENUM(NSUInteger, KRNDownloadFileType)
{
    KRNDownloadFileTypeImage, // загрузка завершена,
    KRNDownloadFileTypeTXT,
    KRNDownloadFileTypePDF,
    KRNDownloadFileTypeOther// загрузка прервана
};




@protocol KRNDownloadTaskDelegate;


@interface KRNDownloadTask : NSObject



@property (strong, nonatomic, readonly) NSString *filePath; // путь загрузки на устройстве (куда сохраняется файл)
@property (strong, nonatomic, readonly) NSString* url; // URL-адрес загрузки

@property (assign, nonatomic, readonly) KRNDownloadStatus downloadStatus; // текущий статус загрузки

@property (assign, nonatomic, readonly) KRNDownloadFileType downloadFileType; // тип загружаемого файла

@property (strong, nonatomic, readonly) NSString* name; // имя задачи

@property (assign, nonatomic) NSUInteger sessionDownloadTaskIdentifier; // идентификатор сессии, с которой связана задач

@property (weak, nonatomic) NSURLSessionDownloadTask *connectedURLSessionDownloadTask; // связанный downloadTask


@property (weak, nonatomic) id <KRNDownloadTaskDelegate> delegate; // делегат


-(id) initWithURL:(NSString*) string; // инициализировать с URL еще незагруженный файл
-(id) initWithFilePath:(NSString*) filePath; // инициализировать с путем к файлу уже загруженный файл


-(void) start; // начать загрузку задания

-(void) setPendingStatus; // установить, что загрузка находится в статусе ожидания загрузки
-(BOOL) checkFileExisting; // проверяет существует ли файл по своему местонахождению. Если нет, то возвращает NO, если существует, то вернем YES.
-(NSString*) returnFilePathForURL:(NSString*)url;

-(void) performOperationsForDownloadedTaskWithLocation:(NSURL*) location;
-(void) performOperationsForCompletedTaskWithError;


@end

@protocol KRNDownloadTaskDelegate<NSObject>

@optional

-(void) downloadTaskStatusIsPending:(KRNDownloadTask*)task; //  загрузка находится в ожидании
-(void) downloadTaskStatusIsDownloading:(KRNDownloadTask*)task; // началась загрузка
// возвращает количество записанных данных в процентном соотношении
-(void) downloadTask:(KRNDownloadTask*)task percentWritten:(double)percent;
-(void) downloadTaskStatusIsFinished:(KRNDownloadTask*)task; // закончилась загрузка


@end
