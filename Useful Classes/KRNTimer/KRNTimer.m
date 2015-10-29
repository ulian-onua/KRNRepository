//
//  KRNTimer.m
//  testDatas
//
//  Created by Drapaylo Yulian on 23.10.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//

#import "KRNTimer.h"


@interface KRNTimer ()
{
NSThread* _timerThread; // поток таймера
}

@property BOOL timerIsStarted; // таймер запущен или нет?

@end

@implementation KRNTimer

@synthesize timeIntervalInSeconds = _timeIntervalInSeconds, timerIsStarted = _timerIsStarted, delegate = _delegate;

-(id)initTimerWithTimeInterval:(CFTimeInterval)second // инициализировать интервал таймер
{
    self = [super init];
    
    if (self)
    {
        if (second >= 0)
            _timeIntervalInSeconds = second;
        else
            _timeIntervalInSeconds = 0;
        
        _timerIsStarted = NO;
        _timerIsPaused = NO;
        
        
    }
    return self;
}



-(id) init
{
    return [self initTimerWithTimeInterval:30]; // по умолчанию таймер на 30 секунд
}

-(void) startTimer // запустить таймер
{
    if (!_timerIsStarted) // если таймер еще не запущен, то
    {
        _timerThread = [[NSThread alloc]initWithTarget:self selector:@selector(timerEngine) object:nil];
        _timerIsStarted = YES;
        [_timerThread start]; // запускаем таймер в отдельный поток
    }
        
}

-(void) stopTimer // остановить таймер
{
    if (_timerIsStarted && [_timerThread isExecuting]) // если таймер запущен
    {
        [_timerThread cancel];
        _timerIsStarted = NO;
        _timerIsPaused = NO;
    }
}


-(BOOL) changeTimeInterval:(CFTimeInterval)second // изменить интервал таймера (не влечет за собой остановку таймера или изменения его текущих значений
{
    if (second >= 0)
    {
        _timeIntervalInSeconds = second;
        return YES;
    }
    return NO;
}

- (void) timerEngine // функция обеспечивающая работу таймера
{
    
    @autoreleasepool {
     
  
    CFAbsoluteTime startTime = CFAbsoluteTimeGetCurrent(); // получаем текущее время
    
    UInt32 currentSecond = _timeIntervalInSeconds; // текущая секунда до конца
        CFTimeInterval intervalForLoop = _timeIntervalInSeconds; // временная переменая для цикла
 
        
        CFTimeInterval x,z;
        
        z = startTime + intervalForLoop - CFAbsoluteTimeGetCurrent();
        
    while ( (x = startTime + intervalForLoop - CFAbsoluteTimeGetCurrent()) > 0 )
    {
        if ([[NSThread currentThread] isCancelled])
        {
            break;
        }
        
        if (!_timerIsPaused) //  если таймер не на паузе
        {
            UInt32 nextSecond = (UInt32) x;
        
            if (nextSecond < currentSecond)
            {
                currentSecond = nextSecond;
                [_delegate timer:self reachedNextSecond:currentSecond+1]; // передали эту секунду + 1  делегату
            }
            z = x;
        }
        else // если таймер на паузе
        {
            startTime = CFAbsoluteTimeGetCurrent(); // циклически получаем стартовое время
            intervalForLoop = z; // интервал уже меньше
        }
    }
    
    _timerIsStarted = NO;
    if (![[NSThread currentThread] isCancelled])
    {
        [_delegate timer:self reachedNextSecond:0]; // передали делегату 0 секунду (таймер закончен)
    if (_delegate)
        [_delegate timerDidFinished:self]; // время таймера истекло, и обработать это должен делегат
    }
        else // если таймер был остановлен, то вызовем соответствующий метод делегат
            if (_delegate)
                [_delegate timerDidStopped:self];
        
        
    }
}


@end
