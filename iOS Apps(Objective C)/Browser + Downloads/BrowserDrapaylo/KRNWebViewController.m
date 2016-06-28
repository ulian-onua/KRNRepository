//
//  KRNWebViewController.m
//  BrowserDrapaylo
//
//  Created by admin on 27.05.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import "KRNWebViewController.h"

@interface KRNWebViewController ()

@end

@implementation KRNWebViewController

-(void) viewDidLoad
{
    _pdfNameLabel.text = [KRNUrlStringMethods getFileNameFromURL:_filePath]; // получаем имя файла
    
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:_filePath]];
    
    [_webView loadRequest:urlRequest];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)backButton:(id)sender
{
     [self dismissViewControllerAnimated:YES completion:nil];
}
@end
