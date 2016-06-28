//
//  KRNQueue.m
//  MagnetometerOSX
//
//  Created by Macbook on 01.02.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import "KRNQueue.h"

@implementation KRNQueue

-(id) init
{
    self = [super init];
    if (self)
    {
        _storageArr = [NSMutableArray new];
    }
    return self;
}
-(void)addObject:(id)object // добавить объект в конец очереди
{   if (object != nil) // если объект не равен nil
        [_storageArr addObject:object]; // добавим его
    else
        [_storageArr addObject:[NSNull null]]; // иначе добавим null
    
    if ([_delegate respondsToSelector:@selector(object:WasAddedToQueue:)])
    {
        [_delegate object:object WasAddedToQueue:self];
    }
    
    
}
-(id)getObject // получить первый в очереди объект
{
    
    id returnedObject = nil;
    
    if (_storageArr.count > 0)
    {
    returnedObject = _storageArr[0];
    [_storageArr removeObjectAtIndex:0]; // удаляем с массива
    }
    
    return returnedObject;
    
}




@end
