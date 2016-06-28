//
//  KRNSingleSquare.m
//  TicTacToe
//
//  Created by Drapaylo Yulian on 23.01.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import "KRNSingleSquare.h"

struct RGBColor
{
    CGFloat red, green, blue;
    
};

typedef struct RGBColor RGBColor;




const RGBColor KRNDefaultSquareColor = {208.0, 242.0, 255.0}; // стандартный цвет квадрата
const RGBColor KRNDefaultSquareFilledColor = {155.0, 242.0, 255.0}; // стандартный цвет квадрата, при установлении на него крестика или нолика


@implementation KRNSingleSquare


-(id) init
{
    return [self initWithFrame:CGRectMake(0, 0, 0, 0) AndDelegate:nil];
    
}
-(id) initWithFrame:(CGRect)frame AndDelegate:(id<KRNSingleSquareDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _delegate = delegate;
        [self addTarget:self action:@selector(viewTapAction) forControlEvents:UIControlEventTouchUpInside];
        _squareState = KRNSquareStateEmpty;
       
    }
    
    return self;
    
}


-(void)drawRect:(CGRect)rect
{
 
    CGContextRef context =  UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
    
    if (_squareState == KRNSquareStateEmpty)
    CGContextSetRGBFillColor(context, KRNDefaultSquareColor.red/255.0, KRNDefaultSquareColor.green/255.0, KRNDefaultSquareColor.blue/255.0, 1);
    else
        if (_squareState == KRNSquareStateRound)
        {
            CGContextSetRGBFillColor(context, 55.0/255.0, 154.0/255.0, 212.0/255.0, 1);
        }
    else
        if (_squareState == KRNSquareStateCross) {
            //212 54 84
            
            CGContextSetRGBFillColor(context, 212.0/255.0, 54/255.0, 84.0/255.0, 1);
            
        }
        
    
    
    
    CGContextFillRect(context, rect);
    
    CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
    CGContextSetLineWidth(context, 1);
    
    
    CGContextStrokeRect(context, rect);
    
    
    if (_squareState == KRNSquareStateCross) // рисуем крестик
    {
        [self drawCrossInContext:context InRect:rect];
    }
    else if (_squareState == KRNSquareStateRound)
        [self drawRoundInContext:context inRect:rect]; // рисуем нолик
   
    
}




-(void) drawCrossInContext: (CGContextRef) context InRect:(CGRect)rect
{
    
    CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);
    CGContextSetLineWidth(context, 4);
    
    // рисуем первую линиюк крестика
    CGContextMoveToPoint(context, rect.origin.x, rect.origin.y);
    CGContextAddLineToPoint(context, rect.origin.x + rect.size.width, rect.origin.y + rect.size.height);
    CGContextStrokePath(context);
    
    // рисуем вторую линию крестика
    
    CGContextMoveToPoint(context, rect.origin.x + rect.size.width, rect.origin.y);
    CGContextAddLineToPoint(context, rect.origin.x, rect.origin.y + rect.size.height);
    CGContextStrokePath(context);
    
}

-(void) drawRoundInContext:(CGContextRef) context inRect:(CGRect) rect
{
    CGRect tempRect = CGRectMake(rect.origin.x + 5, rect.origin.y + 5, rect.size.width - 10, rect.size.height - 10); // уменьшаем размеры прямоугольника, в котором нарисуем нолик, чтобы нолик не вылез за пределы нашего квадрата
    
    
    CGContextSetRGBStrokeColor(context, 1, 1, 1, 1);
    CGContextSetLineWidth(context, 4);
    CGContextStrokeEllipseInRect(context, tempRect);
}

-(void)setSquareState:(KRNSquareState)squareState
{
    _squareState = squareState;
    
    [self setNeedsDisplay];
    
}

-(void) viewTapAction
{
    NSLog(@"TAP ACTION with tag : %ld", (long)self.tag);
    
    [_delegate KRNSingleSquareWasTapped:self];
    
    [self setNeedsDisplay];
    
}


@end
