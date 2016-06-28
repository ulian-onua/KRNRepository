//
//  KRNShowImageVC.m
//  BrowserDrapaylo
//
//  Created by Drapaylo Yulian on 25.05.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import "KRNShowImageVC.h"

//@interface KRNShowImageVC()
//{
//    dispatch_queue_t loadFileQueue;
//}
//
//@end

@implementation KRNShowImageVC


-(void) viewDidLoad
{
   
    
  
    _imageName.text = [KRNUrlStringMethods getFileNameFromURL:_imagePath]; // получаем имя файла
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSData* rawImage = [NSData dataWithContentsOfFile:_imagePath]; // получаем изображение c файла
        UIImage *image = [UIImage imageWithData:rawImage];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _imageView.image = image;
        });
    });
    
   
    NSLog(@"IMAGE NAME TEXT = %@", _imageName.text);
    
}

- (IBAction)returnButton:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
@end
