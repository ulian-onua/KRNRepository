//
//  KRNNote.h
//  Notes
//
//  Created by Drapaylo Yulian on 28.08.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KRNNote : NSObject // класс отдельной записи

-(id) initWithString:(NSString*) note; // инициировать класс с добавлением отдельной записи как строки

-(NSString*) getNote; // получить запись
-(void)setNote:(NSString*)note; // установить новую запись, затерев существующую

@end
