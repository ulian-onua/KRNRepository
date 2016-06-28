//
//  KRNDownloadTaskManagerTests.m
//  BrowserDrapaylo
//
//  Created by Drapaylo Yulian on 25.05.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KRNDownloadTasksManager.h"

@interface KRNDownloadTaskManagerTests : XCTestCase
{
    KRNDownloadTasksManager *_tasksManager;
}
@end

@implementation KRNDownloadTaskManagerTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _tasksManager = [[KRNDownloadTasksManager alloc]initWithMaxNumOfConcurentOperation:5];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testLoadTasksFromFile {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    [_tasksManager loadTasksFromDocumentsDirectory];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
