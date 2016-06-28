//
//  ViewController.h
//  TicTacToe
//
//  Created by Drapaylo Yulian on 23.01.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "KRNSingleSquare.h"
#import "KRNTicTacToeBoard.h"
#import "KRNTicTacToeModel.h"
#import "KRNComputerGamer.h"

@interface ViewController : UIViewController<KRNTicTacToeDelegate, KRNTicTacToeBoardDelegate>

// View Properties
@property (strong, nonatomic) KRNTicTacToeBoard *boardView;
@property (strong, nonatomic) UILabel *infoLabel;
@property (strong, nonatomic) UIButton *startButton;

@property (strong, nonatomic) UIImageView* headerView;

//Model Properties
@property KRNTicTacToeModel *boardModel; // логическая модель доски

@property KRNComputerGamer *computerGamer; // игрок компьютер





@end

