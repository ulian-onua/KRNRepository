//
//  KRNTicTacToeBoard.m
//  TicTacToe
//
//  Created by Drapaylo Yulian on 23.01.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import "KRNTicTacToeBoard.h"

const double KRNDefaultIndentSize = 5.0;



@interface KRNTicTacToeBoard()
{
    NSInteger _winTags[3]; // выигравшие теги
    BOOL _gameFinished;
   
}

@end

@implementation KRNTicTacToeBoard

-(id) initWithSuperView:(UIView*)superView
{

        CGSize frameSize = [KRNTicTacToeBoard defineFrameSizeWithSquareSideSize:[KRNTicTacToeBoard defineSquareSideSizeWithSuperViewSize:superView.frame.size andIndentSize:KRNDefaultIndentSize] AndIndentSize:KRNDefaultIndentSize];
        
        CGRect frame = CGRectMake(0, 0, frameSize.width, frameSize.height);
        
        self = [super initWithFrame:frame];
       
        
        if (self)
        {
              _superView = superView;
              _gameFinished = NO;
            
        }
 
    self.center = _superView.center;
    
    
  //  [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didRotate:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    return self;
 
}

- (void) didRotate:(NSNotification *)notification
{
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    
    if (orientation == UIDeviceOrientationLandscapeLeft)
    {
        NSLog(@"Landscape Left!");
    }
   // NSLog(@"Orientation changed");
    
    [self hideBoard];
    
    CGSize frameSize = [KRNTicTacToeBoard defineFrameSizeWithSquareSideSize:[KRNTicTacToeBoard defineSquareSideSizeWithSuperViewSize:_superView.frame.size andIndentSize:KRNDefaultIndentSize] AndIndentSize:KRNDefaultIndentSize];
    
    CGRect frame = CGRectMake(0, 0, frameSize.width, frameSize.height);
    
    self.frame = frame;
    self.center = _superView.center;
    
    [self drawBoard];
    
}

-(void) drawBoard // нарисовать всю доску
{
    NSMutableArray *tempArray = [NSMutableArray new];
    
    CGFloat squareSideSize = [KRNTicTacToeBoard defineSquareSideSizeWithSuperViewSize:_superView.frame.size andIndentSize:KRNDefaultIndentSize];
    
    
    CGPoint startOrigin = {0, 0};
    
    
    for (int i = 0; i < 9; i++) {
    
        KRNSingleSquare *square = [[KRNSingleSquare alloc]initWithFrame:CGRectMake(startOrigin.x, startOrigin.y, squareSideSize, squareSideSize) AndDelegate:self];
        
        
        square.tag = i;
        square.delegate = self;
        
        [self addSubview:square];
        [tempArray addObject:square];
        
        startOrigin.x += squareSideSize + KRNDefaultIndentSize;
        
        if (i == 2 || i == 5)
        {
            startOrigin.y += squareSideSize + KRNDefaultIndentSize;
            startOrigin.x = 0;

        }
        
    }
    
    _squares = [NSArray arrayWithArray:tempArray];
    
    [_superView addSubview:self];
    
}

-(void) hideBoard
{
   
    for (KRNSingleSquare* square in _squares)
    {
        [square removeFromSuperview];
    }
    _squares = nil;
    [_winLineView hideView];
    
      _winLineView = nil;
   
}



-(void)drawLinesAboveWinSquaresWithTags:(NSInteger[])tags
{
    _gameFinished = YES;
    
    for (int i = 0; i < 3; i++)
    {
        _winTags[i] = tags[i];
    }
    
    
    CGPoint startPoint, endPoint;
    KRNSingleSquare *startView = _squares[_winTags[0]];
    KRNSingleSquare *endView = _squares[_winTags[2]];
    
    if (_winTags[1] == 4 && ((_winTags[0] == 0 && _winTags[2] == 8) || (_winTags[0] == 2 && _winTags[2] == 6))) // если победили диагональные линии
    {

    
   
        
  
        if (_winTags[0] == 0)
        {
            startPoint.x = startView.frame.origin.x;
            startPoint.y = startView.frame.origin.y;
            endPoint.x = endView.frame.origin.x + endView.frame.size.width;
            endPoint.y = endView.frame.origin.y + endView.frame.size.height;
        }
            else
            {
                startPoint.x = startView.frame.origin.x + startView.frame.size.width;
                startPoint.y = startView.frame.origin.y;
                endPoint.x = endView.frame.origin.x;
                endPoint.y = endView.frame.origin.y + endView.frame.size.height;
            }
    }
    
    else if ((_winTags[0] == 0 && _winTags[2] == 6)|| _winTags[0] == 1 || _winTags[0] == 2) // если победили вертикальные линии
    {
        startPoint.x = startView.frame.origin.x + startView.frame.size.width/2.f;
        startPoint.y = startView.frame.origin.y;
        endPoint.x = endView.frame.origin.x + endView.frame.size.width/2.f;
        endPoint.y = endView.frame.origin.y + endView.frame.size.height;
        
    }
    
    else if ((_winTags[0] == 0 && _winTags[2] == 2) || _winTags[0] == 3 || _winTags[0] == 6) // если победили горизонтальные линии
    {
        startPoint.x = startView.frame.origin.x;
        startPoint.y = startView.frame.origin.y + startView.frame.size.height/2.f;
        endPoint.x = endView.frame.origin.x + endView.frame.size.width;
        endPoint.y = endView.frame.origin.y + endView.frame.size.height/2.f;
    }
    
    
    
    
        _winLineView = [[KRNWinLineView alloc]initWithFrame: self.bounds StartPoint:CGPointMake(startPoint.x   , startPoint.y) AndEndPoint:CGPointMake(endPoint.x, endPoint.y)];
        
        _winLineView.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        
    
        [self addSubview:_winLineView];
        
       // [self bringSubviewToFront:_winLineView];
        
   
   // [_winLineView setNeedsDisplay];
    
    
    
    
    
}


#pragma mark - Private Classes

+(CGFloat)defineSquareSideSizeWithSuperViewSize:(CGSize)superViewSize andIndentSize:(double)indentSize
{
    
    double widthSize = superViewSize.width / 3.0 - indentSize * 4.0; // три квадрата и четыре отступа
    double heightSize = superViewSize.height / 3.0 - indentSize * 4.0;
    
    
    return (widthSize > heightSize) ? heightSize : widthSize; // возвращаем меньшую сторону
    
}

+(CGSize) defineFrameSizeWithSquareSideSize:(CGFloat)squareSideSize AndIndentSize:(double) indentSize
{
    
    CGSize returnedSize = CGSizeMake(squareSideSize * 3 + indentSize * 2, squareSideSize * 3 + indentSize * 2);
    
    return returnedSize;
    
}


-(void)resetBoard
{
    [self hideBoard];
    [self drawBoard];
    _winLineView = nil;
}

#pragma mark - Square Delegate Methods

-(void)KRNSingleSquareWasTapped:(KRNSingleSquare*)square
{
    [_delegate ticTacToeBoard:self SquareWasTapped:square]; // передаем нашему делегату
    
}

@end
