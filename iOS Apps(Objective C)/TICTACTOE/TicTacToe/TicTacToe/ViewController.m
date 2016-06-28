//
//  ViewController.m
//  TicTacToe
//
//  Created by Drapaylo Yulian on 23.01.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import "ViewController.h"

enum KRNCurrentMove
{
    KRNCurrentMoveHuman, // ходит человек
    KRNCurrentMoveComputer // ходит компьютер
};

typedef enum KRNCurrentMove KRNCurrentMove;

@interface ViewController ()
{
    KRNCurrentMove currentMove;   // текущий ход - человека или компьютера
    BOOL _isStarted; // начата игра или нет
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self performViewsInitialization];
    
    currentMove = KRNCurrentMoveHuman; // ходит человек
    
    _boardModel = [[KRNTicTacToeModel alloc]initWithDelegate:self];
    
    _computerGamer = [[KRNComputerGamer alloc] initWithGameField:_boardModel andGameFigure:KRNRound];
    
    
    _isStarted = NO;
    
    self.view.backgroundColor = [UIColor colorWithRed:212.0/255.0 green:234.0/255.0 blue:222.0/255.0 alpha:1];
    

    

    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) startButtonClicked
{
    if (!_isStarted)
    {
        _isStarted = YES;
        _infoLabel.text = @"YOUR MOVE";
        
        if (_boardModel.gameResult != KRNGameResultUndefined) // если игра закончилась
        {
            [self resetGame]; // перезапустим игру
        }
    }
    
    
}



#pragma mark - KRNTicTacToeModel delegate methods

-(void) ticTacToe:(KRNTicTacToeModel*)ticTacToe figureIsSet:(KRNSquareFillType) figure ToCoordinates:(KRNBoardCoordinates) coordinates
{
   NSInteger squareTag = [self convertBoardCoordinatesToSquareViewTag:coordinates];
    
    if (currentMove == KRNCurrentMoveHuman) // если ход - человека
    {
        _boardView.squares[squareTag].squareState = KRNSquareStateCross;
        
        if (ticTacToe.gameResult == KRNGameResultUndefined) // если результат игры неопределен
        {
        _infoLabel.text = @"COMPUTER IS THINKING...";
        currentMove = KRNCurrentMoveComputer;
        [_computerGamer performSelector:@selector(makeMove) withObject:nil afterDelay:1.0f];
        }
        
        
    }
    else // если ход - компьютера
    {
        _boardView.squares[squareTag].squareState = KRNSquareStateRound;
        
        if (ticTacToe.gameResult == KRNGameResultUndefined) // если результат игры неопределен
        {
        currentMove = KRNCurrentMoveHuman;
        _infoLabel.text = @"YOUR MOVE";
        }
    }
    
    
}

#pragma mark - TicTacToeBoard Delegate


-(void) ticTacToeBoard:(KRNTicTacToeBoard*) board SquareWasTapped:(KRNSingleSquare*)square;
{
    
    if (_isStarted)  // если игра начать
    {
        KRNBoardCoordinates coords = [self convertSquareViewTagToBoardCoordinates:square.tag];
    
        if (currentMove == KRNCurrentMoveHuman)
        [_boardModel setFigure:KRNCross toFieldWithFirstDim:coords.firstDim AndSecondDim:coords.secondDim];
    }
    
    else
        [self showAlertControllerWithTitle:@"Game is not started!" Message:@"Press \"Start\" button to start game" andButtonTitle:@"OK"];
    
}

-(void) ticTacToe:(KRNTicTacToeModel*)ticTacToe GameIsCompletedWithResult:(KRNTicTacToeGameResult)result WinSquaresCoord:(KRNBoardCoordinates[])coordinates // игра завершена с результатом
{
    switch (result) {
        case KRNGameResultCrossesWon:
        {
           _infoLabel.text = @"Crosses won";
            break;
        }
        case KRNGameResultRoundsWon:
        {
            _infoLabel.text = @"Rounds won";
            break;
        }
        case KRNGameResultDraw:
        {
            _infoLabel.text = @"Draw";
            break;
        }
        default:
        {
            NSLog(@"ERROR. GAME RESULT IS UNDEFINED");
            [self showAlertControllerWithTitle:@"Error" Message:@"Error was caused while trying to determine result of the game. Try to restart the game." andButtonTitle:@"@OK"];
             _isStarted = NO;
           
            break;
        }
    }
    
    
    
    _isStarted = NO;
    
    if (result != KRNGameResultUndefined)
    {
        NSInteger winTags[3];
        
        for (int i = 0; i < 3; i++)
            winTags[i] = [self convertBoardCoordinatesToSquareViewTag:coordinates[i]];
        
        [_boardView drawLinesAboveWinSquaresWithTags:winTags];
        
    }
    
}



-(void) performViewsInitialization
{
    
    _boardView = [[KRNTicTacToeBoard alloc] initWithSuperView:self.view];
    _boardView.delegate = self;
    
    
    [_boardView drawBoard];
    
    NSLog(@"%f",_boardView.frame.origin.y);
    
    _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(_boardView.frame.origin.x, _boardView.frame.origin.y-20, _boardView.frame.size.width, 20)];
    _infoLabel.text = @"Game is not started";
    
    
    _infoLabel.textAlignment = NSTextAlignmentCenter;
    
    
    _startButton = [[UIButton alloc] initWithFrame:CGRectMake(_boardView.frame.origin.x, _boardView.frame.origin.y+_boardView.frame.size.height + 5, 100, 44)];
    
    //_startButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    _startButton.backgroundColor = [UIColor redColor];
    
    
    
    [_startButton setTitle:@"Start" forState:UIControlStateNormal];
    _startButton.hidden = NO;
    _startButton.enabled = YES;
    
    CGPoint center = _startButton.center;
    
    center.x = _boardView.center.x;
    _startButton.center = center;
    _startButton.showsTouchWhenHighlighted = YES;
    
    _startButton.tintColor = [UIColor blueColor];
    
    
    [self.view addSubview:_startButton];
    
    
    
    
    [self.view addSubview:_infoLabel];
    
    
    [_startButton addTarget:self action:@selector(startButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    _headerView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"header.jpg"]];
    _headerView.frame = CGRectMake(_boardView.frame.origin.x, self.view.frame.origin.y+25, _boardView.frame.size.width, _infoLabel.frame.origin.y - 25);
    [self.view addSubview:_headerView];
    
    
    

}

-(void) resetGame
{
    _isStarted = NO;
    [_boardView resetBoard];
    [_boardModel resetModel];
    
    [_startButton sendActionsForControlEvents:UIControlEventTouchUpInside];
    
   
}

-(NSInteger)convertBoardCoordinatesToSquareViewTag:(KRNBoardCoordinates)coordinates
{
    return 3 * coordinates.firstDim + coordinates.secondDim;
}

-(KRNBoardCoordinates) convertSquareViewTagToBoardCoordinates:(NSInteger)tag
{
    KRNBoardCoordinates returnedCoordinates;
    returnedCoordinates.firstDim = tag / 3;
    returnedCoordinates.secondDim = tag - 3 * returnedCoordinates.firstDim;
    
    return returnedCoordinates;
    
}

-(void) showAlertControllerWithTitle:(NSString*) title Message:(NSString*) message andButtonTitle:(NSString*) buttonTitle  // показать соответствующий аlert controller или alert view с единичной опцией выбора
{
    
    if ([UIAlertController class]) // если класс UIAlertController поддерживается
    {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController* myAlertController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle: UIAlertControllerStyleAlert];
            
            [myAlertController addAction:[UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                [myAlertController dismissViewControllerAnimated:YES completion:nil];
            }]];
            
            [self presentViewController:myAlertController animated:YES completion:nil];
            
        });
    }
    
    else // using UIAlertView
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:buttonTitle otherButtonTitles: nil];
            [alertView show];
        });
    }
}


@end
