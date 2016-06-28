//
//  KRNTicTacToeModel.m
//  TicTacToe
//
//  Created by Drapaylo Yulian on 24.01.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import "KRNTicTacToeModel.h"

NSString* const KRNTicTacToeModelErrorDomain = @"KRNTicTacToeModelErrorDomain";

@interface KRNTicTacToeModel()

{
    KRNBoardCoordinates _winSquareCoords[3];
    
}

@end


@implementation KRNTicTacToeModel

-(id) init
{
   return [self initWithDelegate:nil];
}


-(id) initWithDelegate:(id<KRNTicTacToeDelegate>)delegate
{
    self = [super init];
    
    if (self)
    {
        [self setInitialValues]; // установить начальные значения класса
        _delegate = delegate;
        
        
    }
    return self;
}


-(NSError*)setFigure:(KRNSquareFillType) figure toFieldWithFirstDim:(unsigned char)firstDim AndSecondDim:(unsigned char)secondDim
{
    
//    [NSError errorWithDomain:KRNRemindersErrorDomain code:KRNRemindersErrorReminderWasntFoundInEventStore userInfo:@{NSLocalizedDescriptionKey : @"Can't retrieve UpToNewYear reminder from Reminders", NSLocalizedFailureReasonErrorKey : @"Possibly it was deleted manually from Reminders."}];
    
    if (figure != KRNCross && figure != KRNRound)
        
        return [NSError errorWithDomain:KRNTicTacToeModelErrorDomain code:KRNSetFigureErrorUndefinedFigure userInfo:@{NSLocalizedDescriptionKey : @"Figure you've tried to set is not Cross or Round", NSLocalizedFailureReasonErrorKey : @"Possibly your've tried to set a figure with type of KRNSquareUnfilled"}];
    
    if (firstDim < 0 || firstDim > 2 || secondDim < 0 || secondDim > 2) // проверяем соблюдение границ массива
        return [NSError errorWithDomain:KRNTicTacToeModelErrorDomain code:KRNSetFigureErrorOutOfBounds userInfo:nil];
    
    if (_ticTacToeField[firstDim][secondDim] != KRNSquareUnfilled) // если поле уже заполнено фигурой
    {
        return [NSError errorWithDomain:KRNTicTacToeModelErrorDomain code:KRNSetFigureErrorSquareIsFilled userInfo:@{NSLocalizedDescriptionKey : @"Square is already filled with a figure", NSLocalizedRecoverySuggestionErrorKey : @"Try to set figure to another square"}];

    }
    
    _ticTacToeField[firstDim][secondDim] = figure; // ставим фигуру на доску
    
    [self checkGameResult];
    
    
    if ([_delegate respondsToSelector:@selector(ticTacToe:figureIsSet:ToCoordinates:)])
        [_delegate ticTacToe:self figureIsSet:figure ToCoordinates:KRNBoardCoordinatesMake(firstDim, secondDim)];  // отправляем результат делегатному методу
    
    
    if (_gameResult != KRNGameResultUndefined) // если изменился результат игры
    {
        if ([_delegate respondsToSelector:@selector(ticTacToe:GameIsCompletedWithResult:WinSquaresCoord:)])
            [_delegate ticTacToe:self GameIsCompletedWithResult:_gameResult WinSquaresCoord:_winSquareCoords];
        // отправим сообщение делегату
    }
    
    return nil; // ошибки нет

}

-(void) resetModel
{
    [self setInitialValues];
    
}


#pragma mark - private methods

-(void) setInitialValues
{
    for (int i = 0; i < 3; i++)
        for (int i2 = 0; i2 < 3; i2++)
            _ticTacToeField[i][i2] = KRNSquareUnfilled;
    
    _gameResult = KRNGameResultUndefined;
}

-(void) checkGameResult
{
    // проверяем по горизонтали
    // проверяем по вертикали
    // проверяем диагонали
    
    KRNSquareFillType wonFigure = KRNSquareUnfilled;
    

    
    BOOL unfilledSquareWasFound = NO;
    // проверяем по горизонтали
    for (int i = 0; i < 3; i++)
    {
        if (_ticTacToeField[i][0] != KRNSquareUnfilled) // если это поле не пустое, то нужно проверить линию
        {
            if (_ticTacToeField[i][0] == _ticTacToeField[i][1] && _ticTacToeField[i][0] == _ticTacToeField[i][2])
            {
                wonFigure = _ticTacToeField[i][0]; // определяем выигрывшую фигуру
                
                // присваиваем выигрышные координаты
                _winSquareCoords[0] = KRNBoardCoordinatesMake(i, 0);
                _winSquareCoords[1] = KRNBoardCoordinatesMake(i, 1);
                _winSquareCoords[2] = KRNBoardCoordinatesMake(i, 2);
                
                _gameResult = (wonFigure == KRNCross) ? KRNGameResultCrossesWon : KRNGameResultRoundsWon;
                return;
            }
        }
        
        if (_ticTacToeField[i][0] == KRNSquareUnfilled || _ticTacToeField[i][1] == KRNSquareUnfilled || _ticTacToeField[i][2] == KRNSquareUnfilled)
            unfilledSquareWasFound = YES; // найдено одно незаполненное поле, что свидетельствует о том, что игру нужно продолжать и ничьи нет, даже если никто не победил
    }
    
    // проверяем по вертикали
    for (int i2 = 0; i2 < 3; i2++)
    {
        if (_ticTacToeField[0][i2] != KRNSquareUnfilled)
        {
             if (_ticTacToeField[0][i2] == _ticTacToeField[1][i2] && _ticTacToeField[0][i2] == _ticTacToeField[2][i2])
             {
                 wonFigure = _ticTacToeField[0][i2];
                 
                 _winSquareCoords[0] = KRNBoardCoordinatesMake(0, i2);
                 _winSquareCoords[1] = KRNBoardCoordinatesMake(1, i2);
                 _winSquareCoords[2] = KRNBoardCoordinatesMake(2, i2);
                 
                 _gameResult = (wonFigure == KRNCross) ? KRNGameResultCrossesWon : KRNGameResultRoundsWon;
                 return;
             }
        }
    }
    //проверяем по диагонали
    
    if (_ticTacToeField[0][0] != KRNSquareUnfilled && _ticTacToeField[0][2] != KRNSquareUnfilled) // проверяем по одной клетке из каждой диагонали, чтобы она не была не заполнена и была целесообразность дальнейей проверки
    {
        BOOL gameWon = (_ticTacToeField[0][0] == _ticTacToeField[1][1] && _ticTacToeField[1][1] == _ticTacToeField[2][2]); // проверяем диагональ с левого угла
        if (gameWon)
        {
            _winSquareCoords[0] = KRNBoardCoordinatesMake(0, 0);
            _winSquareCoords[1] = KRNBoardCoordinatesMake(1, 1);
            _winSquareCoords[2] = KRNBoardCoordinatesMake(2, 2);
        }
        
        else
            
            if ((gameWon = (_ticTacToeField[0][2] == _ticTacToeField[1][1] && _ticTacToeField[1][1] == _ticTacToeField[2][0])))
            {
                _winSquareCoords[0] = KRNBoardCoordinatesMake(0, 2);
                _winSquareCoords[1] = KRNBoardCoordinatesMake(1, 1);
                _winSquareCoords[2] = KRNBoardCoordinatesMake(2, 0);

            }// проверяем диагональ с правого угла
            
        
        
        if (gameWon)
        {
            wonFigure = _ticTacToeField[1][1]; // присваиваем фигуру по центру (она будет правильной независимо от того, какая из диагоналей выигрышная)
            _gameResult = (wonFigure == KRNCross) ? KRNGameResultCrossesWon : KRNGameResultRoundsWon;
            return;
        }
        
    }
    
    if (!unfilledSquareWasFound) // если на поле не была найден хотя бы один незаполненный квадрат, то результат игры - ничья
        _gameResult = KRNGameResultDraw;
    
}

KRNBoardCoordinates KRNBoardCoordinatesMake(char firstDim, char secondDim)
{
    KRNBoardCoordinates returnedValue = {firstDim, secondDim};
    
    return returnedValue;
}




@end
