//
//  ODSSearchController.m
//  testDictionary
//
//  Created by Jarvis on 29/02/16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import "ODSSearchController.h"

@interface ODSSearchController ()<UISearchBarDelegate>

@end

@implementation ODSSearchController



-(id) initWithSearchResultsController:(UIViewController *)searchResultsController andDelegate:(id)delegate
{
    self = [super initWithSearchResultsController:searchResultsController];
    
    if (self)
    {
        self.delegate = delegate;
        self.searchBar.delegate = self;
        
        self.searchResultsUpdater = delegate;
        
        [self.searchBar sizeToFit];
        self.dimsBackgroundDuringPresentation = NO;
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString*)cleanSearchString
{
    NSString *searchString = self.searchBar.text;
    
    
    //Очищаем ее от пробелов и любых отступов в начале и в конце строки
    return [searchString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

-(BOOL) isSearching
{
    return (self.active && (![self.searchBar.text isEqual: @""]));
            
}

-(id)getObjectDependingOnSearchingStatus:(id)firstObject andSecondObject:(id) secondObject
{
    return (![self isSearching]) ? firstObject : secondObject;
    
}

-(__kindof NSArray*)getArrayDependingOnSearchingStatus:(__kindof NSArray*) firstArray andSecondArray:(__kindof NSArray*) secondArray
{
    if ([firstArray isKindOfClass:[NSArray class]] && [secondArray isKindOfClass:[NSArray class]])

        return [self getObjectDependingOnSearchingStatus:firstArray andSecondObject:secondArray];
    
    else
        return nil;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
