//
//  ODSSearchController.h
//  testDictionary
//
//  Created by Jarvis on 29/02/16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ODSSearchController : UISearchController

-(id) initWithSearchResultsController:(UIViewController *)searchResultsController andDelegate:(id)delegate;


-(NSString*)cleanSearchString; // очистить строку поиска от пробелов и другого

-(BOOL) isSearching; // возвращает YES, если SearchController находится в режиме поиска (т.е. на данный момент кто-то ищет какую-то строку)





//функция возвращает нужный объект(любой) в зависимости от статуса поиска
// если поиска в момент вызова функции нет, то возвращается firstObject
// если поиск в момент вызова функции есть, то возвращается secondObject

-(id)getObjectDependingOnSearchingStatus:(id)firstObject andSecondObject:(id) secondObject;


// данная функция работает аналогично предыдущей
// она проверяет являются ли объекты массивами
//если да, то определяем необходимый массив
// если нет, то возвращает nil

-(__kindof NSArray*)getArrayDependingOnSearchingStatus:(__kindof NSArray*) firstArray andSecondArray:(__kindof NSArray*) secondArray;


@end
