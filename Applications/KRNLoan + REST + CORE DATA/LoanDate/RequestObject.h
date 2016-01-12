//
//  RequestObject.h
//  JSON-WORK
//
//  Created by student on 03.09.2558 BE.
//  Copyright (c) 2558 BE Student_Julian. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ReguestDelegate <NSObject>

-(void) connect:(NSArray*) receivedDictionary;
-(void) connectFailed;

@end

@interface RequestObject : NSObject <NSURLConnectionDelegate>

{
    NSMutableData *requestData; // наши данные
    
    NSURLConnection* connect; // наше соединение
    
}



-(void) makeRequest;
-(void) stopRequest;




@property (nonatomic, retain) id <ReguestDelegate> requestDelegate;

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;

- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
