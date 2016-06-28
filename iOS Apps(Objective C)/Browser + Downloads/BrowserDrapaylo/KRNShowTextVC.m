//
//  KRNShowTextVC.m
//  BrowserDrapaylo
//
//  Created by Drapaylo Yulian on 27.05.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import "KRNShowTextVC.h"

@implementation KRNShowTextVC

-(void) viewDidLoad
{
    
    
    
    _textFileName.text = [KRNUrlStringMethods getFileNameFromURL:_filePath]; // получаем имя файла
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        
        NSError *error;
        
        NSString* bufferedString = [NSString stringWithContentsOfFile:_filePath encoding:NSUTF8StringEncoding error:&error];
        
        
        if (!error)
        {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _textView.text = bufferedString;
        });
        }
    });
    
    
  
    
}

- (IBAction)backButtonPressed:(id)sender
{
        [self dismissViewControllerAnimated:YES completion:nil];
}
@end
