//
//  KRNAbstractViewController.m
//  BrowserDrapaylo
//
//  Created by Drapaylo Yulian on 28.05.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import "KRNAbstractViewController.h"

@implementation KRNAbstractViewController


-(void) viewDidLoad
{
    [super viewDidLoad];
    

    
    
}

-(void) viewDidAppear:(BOOL)animated
{
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadTaskIsFinished:) name:KRNDownloadTaskIsFinished object:nil];
}

-(void) viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(void) downloadTaskIsFinished:(NSNotification*) notification
{
    KRNDownloadTask* downloadTask = [notification.userInfo objectForKey:KRNDownloadTaskIsFinished];
    
    NSString *alertMessage = [NSString stringWithFormat:@"Open file: %@?", downloadTask.name]; // [typeName stringByAppendingString:lastTypeFormat]];
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"FILE DOWNLOADED" message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
    {
      
        
        switch (downloadTask.downloadFileType) {
            case KRNDownloadFileTypeImage:
            {
                KRNShowImageVC* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ShowImageVC"];
                vc.imagePath = downloadTask.filePath;
                [self presentViewController:vc animated:YES completion:nil];
            }
                
                break;
            case KRNDownloadFileTypeTXT:
            {
                KRNShowTextVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ShowTextVC"];
                vc.filePath = downloadTask.filePath;
                [self presentViewController:vc animated:YES completion:nil];
            }
                break;
            
            case KRNDownloadFileTypePDF:
            {
                KRNWebViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"WebViewController"];
                vc.filePath = downloadTask.filePath;
                [self presentViewController:vc animated:YES completion:nil];
            }
                break;
                
            default:
                break;
        }
                                  
                                    
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    
    [self presentViewController:alertController animated:YES completion:nil];
    

    
}



@end
