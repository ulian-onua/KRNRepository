//
//  KRNTicTacToeBoard.h
//  TicTacToe
//
//  Created by Drapaylo Yulian on 23.01.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KRNSingleSquare.h"
#import "KRNWinLineView.h"


@protocol KRNTicTacToeBoardDelegate;

@interface KRNTicTacToeBoard : UIButton <KRNSingleSquareDelegate>


@property (nonatomic, strong) NSArray <KRNSingleSquare*> *squares;   // отдельные квадраты поля

@property (nonatomic, weak) UIView *superView; // суперВью, исходя из размера которого будет определяться размер каждого квадрата


@property (strong, nonatomic) KRNWinLineView *winLineView;


@property (weak, nonatomic) id<KRNTicTacToeBoardDelegate> delegate;




-(id) initWithSuperView:(UIView*)superView;

-(void) drawBoard; // нарисовать всю доску
-(void) hideBoard; // скрыть всю доску

-(void)drawLinesAboveWinSquaresWithTags:(NSInteger[])tags; // перечеркнуть победившие фигуры, tags - массив из трех победивших фигур


-(void)resetBoard; // перезапустить доску





@end

@protocol KRNTicTacToeBoardDelegate<NSObject>

-(void) ticTacToeBoard:(KRNTicTacToeBoard*) board SquareWasTapped:(KRNSingleSquare*)square; // была нажата ячейка с соответствующим тегом

@end