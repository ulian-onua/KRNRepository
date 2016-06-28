//
//  KRNDownloadTask.m
//  BrowserDrapaylo
//
//  Created by admin on 20.05.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import "KRNDownloadTask.h"

static NSString* defaultURLString = @"http://www.apple.com";

NSString* const KRNDownloadTaskIsFinished = @"KRNDownloadTaskIsFinished";
NSString* const KRNDownloadTaskIsCompletedWithError = @"KRNDownloadTaskIsCompletedWithError";


@implementation KRNDownloadTask

-(id) initWithURL:(NSString*) string; // инициализировать с URL
{
    self = [super init];
    
    if (self)
    {
        _url = string;
        _name = [KRNUrlStringMethods getFileNameFromURL:_url];
        _downloadFileType = [self getDownloadFileTypeForFileExtension:[KRNUrlStringMethods getFileExtensionFromURL:string]]; // определить тип загрузки в зависимости от расширения файла
        _downloadStatus = KRNDownloadStatusInitialized;
        
        _filePath = nil;
        
        
    }
    
    return self;
}

-(id) initWithFilePath:(NSString*) filePath // инициализировать с путем к файлу уже загруженный файл
{
    self = [super init];
    if (self)
    {
        if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) // если файл по найденному пути существует
        {
            _filePath = filePath; //  присваиваем путь
            _name = [KRNUrlStringMethods getFileNameFromURL:_filePath];
            _downloadFileType = [self getDownloadFileTypeForFileExtension:[KRNUrlStringMethods getFileExtensionFromURL:filePath]]; // определяем тип файла
            _downloadStatus = KRNDownloadStatusLoadFromFile; // указываем, что файл загружен из файла
        }
        else
            return nil; // файл по соответствующему пути не найден
    }
    return self;
}

// проверить наличие файла
-(BOOL) checkFileExisting
{
    return [[NSFileManager defaultManager]fileExistsAtPath:_filePath];
}


-(NSString*) returnFilePathForURL:(NSString*)url
{
    NSString* fileName = [KRNUrlStringMethods getFileNameFromURL:url]; // получаем имя файла
    
    if (!fileName)
        return nil;
    
    // проверяем нет ли имени файла в NSDocuments с таким же именем
    NSString* documentsDirectory =  NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject; // получаем директорию документов
    
    NSString* fullFileAddress = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName]; // получаем полный адрес файла
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:fullFileAddress]) // если такого файла по адресу нет, то в данный путь можно загружать
        return fullFileAddress;
    else // если такой файл существует, то
    {
        // вызовем функцию, которая разрешит проблему с дубликатом
        return [KRNUrlStringMethods getCorrectFilePathForDublicate:fullFileAddress];
    }
    
    
    return nil;
}


-(void) start
{
    _downloadStatus = KRNDownloadStatusDownloading;
    // сообщаем делегату о начала загрузки
    if ([_delegate respondsToSelector:@selector(downloadTaskStatusIsDownloading:)])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
             [_delegate downloadTaskStatusIsDownloading:self];
        });
    }
    
}

-(void) setPendingStatus
{
    _downloadStatus = KRNDownloadStatusPending;
    
    // сообщаем делегату о том, что загрузка находится в статусе ожидания
    if ([_delegate respondsToSelector:@selector(downloadTaskStatusIsPending:)])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [_delegate downloadTaskStatusIsPending:self];
        });
    }
    
}



-(void) performOperationsForDownloadedTaskWithLocation:(NSURL*) location
{

        _filePath = [self returnFilePathForURL:_url]; // получаем путь для загруженного задания
        
        // копируем файл с временной папки (куда было закачано NSURLSession) в постоянное место (NSDocuments)
        
        [[NSFileManager defaultManager]copyItemAtURL:location toURL:[NSURL fileURLWithPath:_filePath] error:nil];
    
    
        _downloadStatus = KRNDownloadStatusFinished; // меняем статус
        
        // сообщаем делегату
        if ([_delegate respondsToSelector:@selector(downloadTaskStatusIsFinished:)])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [_delegate downloadTaskStatusIsFinished:self];
                
                
            });
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:KRNDownloadTaskIsFinished object:self userInfo:@{KRNDownloadTaskIsFinished: self}]; // постим нотификацию, в которую передаем себя
        });

}

-(void) performOperationsForCompletedTaskWithError
{
    // постим нотификацию о том, что выполнение задания завершено с ошибкой
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:KRNDownloadTaskIsCompletedWithError object:self userInfo:@{KRNDownloadTaskIsCompletedWithError: self}]; // постим нотификацию, в которую передаем себя
    });

}


// получить тип загружаемого файла для расширения
-(KRNDownloadFileType) getDownloadFileTypeForFileExtension:(NSString*) fileType
{
    fileType = [fileType uppercaseString];
    
    if ([fileType isEqualToString:@"JPG"] || [fileType isEqualToString:@"JPEG"] || [fileType isEqualToString:@"PNG"])
        return KRNDownloadFileTypeImage;
    else
        if ([fileType isEqualToString:@"TXT"])
            return KRNDownloadFileTypeTXT;
    else
        if ([fileType isEqualToString:@"PDF"])
            return KRNDownloadFileTypePDF;
    
    else
        return KRNDownloadFileTypeOther;
    
    
}



@end
