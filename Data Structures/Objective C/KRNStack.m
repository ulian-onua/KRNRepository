//
//  KRNStack.m
//  StackObjectiveC
//
//  Created by Drapaylo Yulian on 26.10.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//

#import "KRNStack.h"

@interface KRNStack ()
{
    NSMutableArray *stackArray;
}
@end


@implementation KRNStack

-(id)init
{
    self = [super init];
    if (self)
        stackArray = [NSMutableArray new];
    return self;
}

-(void)pushObject:(id)object
{
    [stackArray addObject:object];
}

-(id)popObject
{
    long i = stackArray.count;    
    
    if (i > 0)
    {
        id tempObj = [stackArray lastObject];
        [stackArray removeObjectAtIndex:i-1];
        return tempObj;
    }
    return nil;
}

-(void)logAllObjects
{
  
    for (long i = stackArray.count-1; i >= 0; i--)
        NSLog(@"%@", stackArray[i]);
    
}






@end
