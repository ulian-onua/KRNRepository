//
//  KRNComputerGamer.m
//  TicTacToe
//
//  Created by Drapaylo Yulian on 24.01.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import "KRNComputerGamer.h"

@implementation KRNComputerGamer

-(id) init
{
    return [self initWithGameField:nil andGameFigure:KRNRound]; // по умолчанию компьютер играет ноликами
}

-(id) initWithGameField:(KRNTicTacToeModel*)gameField andGameFigure:(KRNSquareFillType)gameFigure
{
    self = [super init];
    if (self)
    {
        _gameField = gameField;
        
        _gameFigure = (gameFigure != KRNSquareUnfilled) ? gameFigure : KRNRound;
        
    }
    return self;
}

-(BOOL) makeMove
{

    
    for (int i = 0; i < 3; i++)
        for (int i2 = 0; i2 < 3; i2++)
            if (_gameField->_ticTacToeField[i][i2] == KRNSquareUnfilled) // выбираем первую свободную фигуру
            {
                [_gameField setFigure:_gameFigure toFieldWithFirstDim:i AndSecondDim:i2];
                return YES;
            }
        
    
    return NO;
}

@end
