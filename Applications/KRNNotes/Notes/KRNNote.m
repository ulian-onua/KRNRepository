//
//  KRNNote.m
//  Notes
//
//  Created by Drapaylo Yulian on 28.08.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//

#import "KRNNote.h"


@interface KRNNote ()

@property (strong, nonatomic) NSString* note; // отдельная запись

@end

@implementation KRNNote

-(id) initWithString:(NSString*) note // инициировать класс с добавлением отдельной записи

{
    self = [super init];
    
    if (self)
    {
        _note = note;
    }
    return self;
}

-(NSString*) getNote // получить запись
{
    return _note;
}
-(void)setNote:(NSString*)note// установить новую запись, затерев существующую
{
    _note = note;
}


@end
