//
//  KRNDownloadTableViewCell.m
//  BrowserDrapaylo
//
//  Created by Drapaylo Yulian on 24.05.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import "KRNDownloadTableViewCell.h"

@implementation KRNDownloadTableViewCell

-(void) awakeFromNib
{

}

-(void)setName:(NSString*) name andStatus:(KRNVisibleStatus) status
{
    _downloadTaskName.text = name;

    [self changeViewsWithStatus:status];
}

// подсветить часть имени в указанном диапазоне (используется для поиска)
-(void) highlightPartOfNameWithRange:(NSRange) range
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:_downloadTaskName.text];
   // NSDictionary* colorAttr = @{NSForegroundColorAttributeName : [UIColor redColor]};
    [attrStr addAttribute:NSForegroundColorAttributeName  value:[UIColor redColor] range:range];
    [attrStr addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:range];
    
    [_downloadTaskName setAttributedText:attrStr];
    
}

-(void) downloadTaskStatusIsPending:(KRNDownloadTask*)task // ожидания загрузки в очереди
{
    [self changeViewsWithStatus:KRNVisibleStatusPending];
}

-(void) downloadTaskStatusIsDownloading:(KRNDownloadTask*)task // началась загрузка
{
    [self changeViewsWithStatus:KRNVisibleStatusDownloading];
}
-(void) downloadTaskStatusIsFinished:(KRNDownloadTask*)task // закончилась загрузка
{
   [self changeViewsWithStatus:KRNVisibleStatusFinished];
    
}

-(void) downloadTask:(KRNDownloadTask*)task percentWritten:(double)percent
{
   // _downloadProgress.progress = percent;
    
    [_downloadProgress setProgress:(float)percent animated:YES];
}

-(void) changeViewsWithStatus:(KRNVisibleStatus) status
{
    switch (status) {
        case KRNVisibleStatusInitialized:
        
            _doneLabel.hidden = YES;
            _activityIndicator.hidden = YES;
            _downloadProgress.hidden = YES;
            break;
        case KRNVisibleStatusPending:
            _doneLabelTrailingContraint.constant = 30.f;
            _doneLabel.text = @"Pending";
            //_doneLabel.textColor = [UIColor redColor];
            _doneLabel.hidden = NO;
            _downloadProgress.hidden = YES;
            _activityIndicator.hidden = NO;
            [_activityIndicator startAnimating];
      
            
            break;
        case KRNVisibleStatusDownloading:
            _downloadTaskNameWidthToSuperView.active = YES;
            _downloadProgress.hidden = NO;
            _doneLabel.hidden = YES;
            _activityIndicator.hidden = NO;
            [_activityIndicator startAnimating];
            break;
        case KRNVisibleStatusFinished:
            // скрываем индикатор активности
            
            _downloadTaskNameWidthToSuperView.active = NO;
            
            _doneLabel.text = @"Done";
              _doneLabelTrailingContraint.constant = 0.f;
            [_activityIndicator stopAnimating];
            _activityIndicator.hidden = YES;
            _downloadProgress.hidden = YES;
            
            _doneLabel.hidden = NO;
            break;
            
        default:
            
            break;
    }
}


@end
