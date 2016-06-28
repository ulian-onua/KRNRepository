//
//  ViewController.h
//  BrowserDrapaylo
//
//  Created by Drapaylo Yulian on 05.08.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Foundation;

#import "AppDelegate.h"

#import "KRNUrlStringMethods.h"
#import "KRNAbstractViewController.h"


@interface ViewController : KRNAbstractViewController <UIWebViewDelegate> // делегат класса UIWebView

@property (weak, nonatomic) IBOutlet UIWebView *myWebView; // веб-вью, в котором будет отображаться страница
@property (weak, nonatomic) IBOutlet UITextField *siteField; // строка в которую будет вводиться адрес сайта


//@property NSArray<NSString*> *downloadFormatTypes; // типы возможных загрузок

@property (weak, nonatomic) AppDelegate *appDelegate;



- (IBAction)goButton:(id)sender; // нажимаем кнопку GO


- (IBAction)forwardButtonAction:(id)sender; // кнопка перехода страницу вперед

- (IBAction)backButtonAction:(id)sender; // кнопка перехода на обратную страницу




@end

