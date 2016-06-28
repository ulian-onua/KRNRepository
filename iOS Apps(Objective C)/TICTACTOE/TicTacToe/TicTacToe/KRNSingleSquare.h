//
//  KRNSingleSquare.h
//  TicTacToe
//
//  Created by Drapaylo Yulian on 23.01.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KRNSingleSquareDelegate;

enum KRNSquareState  // перечисляемый тип с состоянием квадрата
{
    KRNSquareStateEmpty, // пустой квадрат
    KRNSquareStateCross, // квадрат с крестиком
    KRNSquareStateRound //  квадрат с ноликом
};

typedef enum KRNSquareState KRNSquareState;


@interface KRNSingleSquare : UIButton

@property (assign, nonatomic, readwrite) KRNSquareState squareState; // состояние квадрата (меняется при вызове сеттера данного проперти)

@property (weak, nonatomic) id<KRNSingleSquareDelegate> delegate;




-(id) initWithFrame:(CGRect)frame AndDelegate:(id<KRNSingleSquareDelegate>)delegate;



@end

@protocol KRNSingleSquareDelegate <NSObject>

-(void)KRNSingleSquareWasTapped:(KRNSingleSquare*)square; // делегату отправляется сообщение, когда квадрат был выбран

@end