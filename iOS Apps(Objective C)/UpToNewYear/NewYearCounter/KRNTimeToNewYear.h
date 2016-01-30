//
//  KRNTimeToNewYear.h
//  NewYearCounter
//
//  Created by Drapaylo Yulian on 08.11.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KRNEngLangTimeFunctions.h"



@class KRNTimeToNewYear;

@protocol KRNTimeToNewYearDelegate <NSObject>
@optional

-(void)timeToNewYearWasChangedInSeconds:(KRNTimeToNewYear*) timeToNewYear; // время до Нового года изменилось в секундах

@end


@interface KRNTimeToNewYear : NSObject

@property (readonly, strong, nonatomic) NSDateComponents* timeToNewYear; // время до нового года

@property (readonly, assign, nonatomic) long nextNewYear; // следующий новый год

@property (weak, nonatomic) id<KRNTimeToNewYearDelegate> delegate; // делегат


#pragma mark - Methods

-(id) initWithDelegate:(id<KRNTimeToNewYearDelegate>) delegate; // инициализировать с указанием делегата

-(NSString*)getFormattedEnglishStringWithTimeToNewYear;




@end
