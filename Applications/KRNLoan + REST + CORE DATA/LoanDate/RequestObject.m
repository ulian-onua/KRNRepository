//
//  RequestObject.m
//  JSON-WORK
//
//  Created by student on 03.09.2558 BE.
//  Copyright (c) 2558 BE Student_Julian. All rights reserved.
//

#import "RequestObject.h"

@interface RequestObject ()<NSURLSessionDelegate, NSURLSessionDataDelegate>

@property NSURLSession* mySession;
@property NSURLSessionConfiguration* mySessionConfig;
@property NSURLSessionDataTask *mySessionTask;
@property NSOperationQueue *sessionQueue;

@property NSURL *addressUrl;

@end

@implementation RequestObject

-(id) init// инициализация
{
    self = [super init];
    if (self)
    {
        NSString *initialUrl = [NSString stringWithFormat:@"http://api.kivaws.org/v1/loans/search.json?status=fundraising"];
        NSLog (@"URL: %@", initialUrl);
        
         _addressUrl = [NSURL URLWithString:initialUrl];
     //  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:addressUrl]; // запрос
        
        
       _sessionQueue = [[NSOperationQueue alloc]init];
        
        _sessionQueue.name = @"Session Queue";
        
        
        _mySessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        _mySession = [NSURLSession sessionWithConfiguration:_mySessionConfig delegate:self delegateQueue:_sessionQueue];
        
       
        
        
        
   
        
        
        
   //    connect = [[NSURLConnection alloc] initWithRequest:request delegate:self]; // инициализируем и стартуем запрос
        
    }
    
return self;
    
}

-(void)makeRequest
{
    _mySessionTask = [_mySession dataTaskWithURL:_addressUrl];
    [_mySessionTask resume];

}

-(void)stopRequest
{
    [_mySessionTask cancel];
}
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}



- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    requestData=nil;
    requestData=[[NSMutableData alloc] init];
    [requestData setLength:0];
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    [requestData appendData:data];
}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error
{
    if (error == nil)
    {
        NSDictionary *responceDict = [NSJSONSerialization JSONObjectWithData:requestData options:kNilOptions error:nil]; // опции могут определить куда мы будем возвращать
        //  NSLog (@"Responce: %@", responceDict);
        NSArray *loansArray = [responceDict valueForKey:@"loans"]; // возвращаем массив loans в словарь
        
        dispatch_async(dispatch_get_main_queue(),
        ^{
           [self.requestDelegate connect:loansArray];
        });
                
    }
    else
    {
            if (error.code != NSURLErrorCancelled)
                dispatch_async(dispatch_get_main_queue(),
                ^{
                [self.requestDelegate connectFailed];
                });
    }
}

@end





