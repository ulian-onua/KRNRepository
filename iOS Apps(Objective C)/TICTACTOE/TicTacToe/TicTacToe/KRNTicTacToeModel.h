//
//  KRNTicTacToeModel.h
//  TicTacToe
//
//  Created by Drapaylo Yulian on 24.01.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString* const KRNTicTacToeModelErrorDomain;

static NSInteger const KRNSetFigureErrorUndefinedFigure = 0; // фигура, которую необходимо установить, неопределена
static NSInteger const KRNSetFigureErrorSquareIsFilled = 1; // ячейка поля уже заполнена фигурой
static NSInteger const KRNSetFigureErrorOutOfBounds = 2; // выход за пределы массива при попытке поставить фигуру


enum KRNTicTacToeGameResult // результат игры
{
    KRNGameResultUndefined,
    KRNGameResultCrossesWon,  // крестики победили
    KRNGameResultRoundsWon,  // нолики победили
    KRNGameResultDraw      // ничья
};

typedef enum KRNTicTacToeGameResult KRNTicTacToeGameResult;

enum KRNSquareFillType
{
    KRNSquareUnfilled = 0, // поле не заполнено
    KRNCross, // поле заполнено крестиком
    KRNRound // поле заполнено ноликом
};
typedef enum KRNSquareFillType KRNSquareFillType;

struct KRNBoardCoordinates
{
    char firstDim;
    char secondDim;
};

typedef struct KRNBoardCoordinates KRNBoardCoordinates;



@protocol KRNTicTacToeDelegate;

@interface KRNTicTacToeModel : NSObject
{
    @public
    KRNSquareFillType _ticTacToeField[3][3];  // поле крестиков-ноликов - двумерный массив 3-3
}




@property (assign, readonly, nonatomic) KRNTicTacToeGameResult gameResult; // результат игры

@property (weak, nonatomic) id<KRNTicTacToeDelegate> delegate;


-(id) initWithDelegate:(id<KRNTicTacToeDelegate>)delegate;


-(NSError*)setFigure:(KRNSquareFillType) figure toFieldWithFirstDim:(unsigned char)firstDim AndSecondDim:(unsigned char)secondDim; // установить фигуру (крестик или нолик) на соответствующее место поля (firstDim - первое измерение двумерного массива поля, secondDim - второе измерение массива поля).
    // В случае, если по результатам установки фигуры изменится результат игры, то будет отправлено сообщение делегату
    // 
-(void) resetModel;



@end

@protocol KRNTicTacToeDelegate<NSObject>
@optional

-(void) ticTacToe:(KRNTicTacToeModel*)ticTacToe figureIsSet:(KRNSquareFillType) figure ToCoordinates:(KRNBoardCoordinates) coordinates; // установлена фигура на координаты

-(void) ticTacToe:(KRNTicTacToeModel*)ticTacToe GameIsCompletedWithResult:(KRNTicTacToeGameResult)result WinSquaresCoord:(KRNBoardCoordinates[])coordinates; // игра завершена с результатом
//-(void)ticTacToeWasReset:(KRNTicTacToeModel*)ticTacToe; // модель с игрой была перезагружена (установлены начальные значения)


@end

