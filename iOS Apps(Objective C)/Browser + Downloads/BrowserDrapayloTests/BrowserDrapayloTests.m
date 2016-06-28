//
//  BrowserDrapayloTests.m
//  BrowserDrapayloTests
//
//  Created by Drapaylo Yulian on 05.08.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "KRNUrlStringMethods.h"

@interface BrowserDrapayloTests : XCTestCase

@end

@implementation BrowserDrapayloTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}



-(void)testGetFileNameFromUrl
{
    NSString *someURL = @"http://ukrlawyer.net/wp-content/uploads/2015/02/drapaylo_photo-150x150.jpg";
    NSString *fileName = [KRNUrlStringMethods getFileNameFromURL:someURL];
    
    XCTAssertEqualObjects(fileName, @"drapaylo_photo-150x150.jpg");
    
}

-(void)testGetFileExtensionFromUrl
{
  NSString *someURL = @"http://ukrlawyer.net/wp-content/uploads/2015/02/drapaylo_photo-150x150.jpg";
    
   NSString *fileExtension = [KRNUrlStringMethods getFileExtensionFromURL:someURL];
    
    XCTAssertEqualObjects(fileExtension, @"jpg");
    
}

-(void)testExample
{
  //  NSString* path = @"/Users/drapayloyulian1/Library/Developer/CoreSimulator/Devices/957F2725-655D-47B2-B9E9-57AB3439A859/data/Containers/Data/Application/3DE2D7D2-23C0-444D-8C47-20459CC43861/Documents/settings2_icon.png";
    
    NSString* fileName = @"settings2_icon.png";
    
    NSString* documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    NSString* path = [NSString stringWithFormat:@"%@/%@", documentsDirectory, fileName];
    
    
    
    NSString* newPath = [KRNUrlStringMethods getCorrectFilePathForDublicate:path];
    
    NSString* neededPath = @"/Users/drapayloyulian1/Library/Developer/CoreSimulator/Devices/957F2725-655D-47B2-B9E9-57AB3439A859/data/Containers/Data/Application/60E7F15B-672D-4B1D-8303-EC2FB25A590C/Documents/settings2_icon1.png";
    
    NSLog(@"newPath = %@_", newPath);
    NSLog(@"neededPath = %@_", neededPath);

    
    XCTAssertEqualObjects(newPath, neededPath);
    
}


- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
