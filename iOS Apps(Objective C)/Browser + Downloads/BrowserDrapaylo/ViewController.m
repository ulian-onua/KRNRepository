//
//  ViewController.m
//  BrowserDrapaylo
//
//  Created by Drapaylo Yulian on 05.08.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

@synthesize myWebView, siteField;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    // домашняя страница - google.com (Загрузить ее)
    
    [myWebView setDelegate:self]; // наш класс UIViewController является делегатом класса myWebView и может обрабатывать некоторые его сообщения
    
    NSURL *x = [NSURL URLWithString:@"https://google.com"];
    
    [myWebView loadRequest:[NSURLRequest requestWithURL:x]];
    
    
    // добавляем tap gesture recognizer на mytextfield
    
    UITapGestureRecognizer * tapSiteField = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(siteFieldTap)];
    
    tapSiteField.numberOfTapsRequired = 2;
    
    [siteField addGestureRecognizer:tapSiteField];
    
   // _downloadFormatTypes = @[@"jpg", @"png", @"pdf", @"txt", @"jpeg"];
 
    
    _appDelegate = [[UIApplication sharedApplication] delegate];
    
    
}



-(void) siteFieldTap // по двойному тапу выделяем весь текст в поле ввода строки сайта
{
    if ([siteField selectedTextRange] != nil)
        [siteField selectAll:siteField];
    
 //   siteField sel
    
    //[siteField sele]
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goButton:(id)sender {
    
    if (! [siteField.text isEqualToString:@""]) // если строка не пустая, то
    {
        //NSRange temp;
        //temp = [siteField.text rangeOfString:@"http://"];
        
        
    
  
            if (([siteField.text rangeOfString:@"http://"].location== NSNotFound) && ([siteField.text rangeOfString:@"https://"].location== NSNotFound))
            
             // если подстрока http:// или https:// не найдена, то
        {
         
            siteField.text = [NSString stringWithFormat:@"http://%@", siteField.text]; // создать новую строку путем добавления к ней http в начале строки
       
        }
    }
    
    [myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:siteField.text]]]; // загружаем наш запрос с полученной строкой
    
    [siteField resignFirstResponder];
    
}


#pragma mark - UIWebViewDelegate


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType // обработка делегатной функции UIWebView
{
   
    static BOOL dontAskForDownload = NO;
    
    if (dontAskForDownload)
    {
        dontAskForDownload = NO;
        return YES;
    }
    
    
    
    NSString* temp = [[request URL] absoluteString]; // получаем текущий URL (как NSString) нашего запроса
    
    NSArray <NSString*> *requestParts = [temp componentsSeparatedByString:@"."];
    
    NSString *lastTypeFormat = [requestParts lastObject];
 //   NSString *typeName = [requestParts objectAtIndex:requestParts.count - 2];
    
                                         
    
    
    for (NSString* formatType in [_appDelegate.appSettings getSupportedFileTypesInArray]) {
        if ([lastTypeFormat.lowercaseString isEqualToString:formatType])
        {
            NSString *alertMessage = [NSString stringWithFormat:@"Should download file: %@", [KRNUrlStringMethods getFileNameFromURL:temp]]; // [typeName stringByAppendingString:lastTypeFormat]];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"NEW DOWNLOAD TASK" message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
            
            
          
    
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action)
            {
                [_appDelegate.taskManager createNewTaskWithURLString:temp]; // добавляем новую задачу
      
                
            }]];
            
            
            [alertController addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                // если пользователь сказал нет, то загрузим в веб вью, но без вопроса о загрузке
                dontAskForDownload = YES;
                [webView loadRequest:request];
                
                
            }]];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
            
            return NO;
        }
    }
    
    
    
    if (![temp isEqualToString:@"about:blank"]) // почему-то при вводе сайта вручную, данный метод в итоге вызывается с запросос about:blank. Пока уберем соответствущее присваивание if-ом, а потом нужно будет разобраться)
        
        siteField.text = temp; // присваиваем строке сайта на экране URL запроса при переходе пользователем по ссылке в WebView (а не нажатии кнопок на пользовательском интерфейсе)
    
    
    
    return YES;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error // обработка ошибки, если невозможно загрузить страницу
{
    NSString *temp = [NSString stringWithFormat:@"Невозможно загрузить страницу: %@", [[webView.request URL] absoluteString]]; // cоздаем временную строку с указанием страницы, которую невозможно загрузить
    
 
  
    
    [self showAlertControllerWithTitle:@"Ошибка загрузки" Message:temp andButtonTitle:@"OK"];
    
                                
}


-(void) showAlertControllerWithTitle:(NSString*) title Message:(NSString*) message andButtonTitle:(NSString*) buttonTitle  // показать соответствующий аlert controller или alert view с единичной опцией выбора
{
    
    if ([UIAlertController class]) // если класс UIAlertController поддерживается
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController* myAlertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle: UIAlertControllerStyleAlert];
            
            
            [myAlertController addAction:[UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [myAlertController dismissViewControllerAnimated:YES completion:nil];
            }]];
            
            [self presentViewController:myAlertController animated:YES completion:nil];
            
        });
    }
}




- (IBAction)forwardButtonAction:(id)sender
{
    [myWebView goForward]; // переход в браузере вперед
}

- (IBAction)backButtonAction:(id)sender
{
    [myWebView goBack]; // переход в браузере назад
}
@end
