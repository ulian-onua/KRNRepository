//
//  KRNDownloadTableViewCell.h
//  BrowserDrapaylo
//
//  Created by Drapaylo Yulian on 24.05.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRNDownloadTask.h"

@class KRNDownloadTask;
@protocol KRNDownloadTaskDelegate;



typedef NS_ENUM(NSUInteger, KRNVisibleStatus)
{
    KRNVisibleStatusInitialized, // класс загрузки только инициализирован, никаких дальнейших действий не происходит
    KRNVisibleStatusPending, // загрузка находится в очереди ожидания
    KRNVisibleStatusDownloading, // загрузка идет
    KRNVisibleStatusFinished, // загрузка завершена,
    KRNVisibleStatusInterrupted, // загрузка прервана
    KRNVisibleStatusLoadFromFile // загружено из файла
};







@interface KRNDownloadTableViewCell : UITableViewCell<KRNDownloadTaskDelegate>

@property (weak, nonatomic) IBOutlet UILabel *downloadTaskName; // имя задачи
@property (weak, nonatomic) IBOutlet UILabel *doneLabel; // выполнена ли задача
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator; // индикатор загрузки
@property (weak, nonatomic) IBOutlet UIProgressView *downloadProgress; // прогресс загрузки


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *doneLabelTrailingContraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downloadTaskNameWidthToSuperView; // соотношение ширины к SuperView


-(void)setName:(NSString*) name andStatus:(KRNVisibleStatus) status;
-(void) highlightPartOfNameWithRange:(NSRange) range; // подсветить часть имени в указанном диапазоне (используется для поиска)

-(void) downloadTaskStatusIsDownloading:(KRNDownloadTask*)task; // началась загрузка
-(void) downloadTaskStatusIsFinished:(KRNDownloadTask*)task; // закончилась загрузка

-(void) downloadTask:(KRNDownloadTask*)task percentWritten:(double)percent;
@end
