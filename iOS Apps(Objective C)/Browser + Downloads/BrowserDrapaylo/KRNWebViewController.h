//
//  KRNWebViewController.h
//  BrowserDrapaylo
//
//  Created by admin on 27.05.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRNUrlStringMethods.h"

@interface KRNWebViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *pdfNameLabel;

@property (strong, nonatomic) NSString* filePath;

- (IBAction)backButton:(id)sender;

@end
