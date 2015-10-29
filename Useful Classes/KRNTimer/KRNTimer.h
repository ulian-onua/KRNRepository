//
//  KRNTimer.h
//  testDatas
//
//  Created by Drapaylo Yulian on 23.10.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol KRNTimerDelegate;

@interface KRNTimer : NSObject

@property (nonatomic, assign, readonly) CFTimeInterval timeIntervalInSeconds;

@property (weak, nonatomic) id<KRNTimerDelegate> delegate; // делегат


-(id) init; // по умолчанию таймер устанавливается на 30 секунд
-(id)initTimerWithTimeInterval:(CFTimeInterval)second; // инициализировать интервал таймер

-(void) startTimer; // запустить таймер
-(void) stopTimer; // остановить и перезагрузить таймер


-(BOOL) changeTimeInterval:(CFTimeInterval)second; // изменить интервал таймера


@property (nonatomic) BOOL timerIsPaused; // таймер на паузе или нет?

@end


@protocol KRNTimerDelegate <NSObject>

@optional

-(void)timerDidFinished:(KRNTimer*)timer; // время таймера истекло
-(void)timerDidStopped:(KRNTimer*)timer; // таймер был остановлен

-(void)timer:(KRNTimer*) timer reachedNextSecond:(UInt32)second; // таймер достиг очередной секунды

@end