//
//  KRNComputerGamer.h
//  TicTacToe
//
//  Created by Drapaylo Yulian on 24.01.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KRNTicTacToeModel.h"

@interface KRNComputerGamer : NSObject


@property (assign, nonatomic, readonly) KRNSquareFillType gameFigure; // фигура, которой играет компьютер

@property (weak, nonatomic) KRNTicTacToeModel *gameField; // игровое поле, на котором компьютер будет делать ход


-(id) initWithGameField:(KRNTicTacToeModel*)gameField andGameFigure:(KRNSquareFillType)gameFigure;

-(BOOL) makeMove; // компьютер делает ход. Возвращает YES - если ход успешно сделан, возвращает NO - если нет свободных клеток и ход нельзя сделать



@end
