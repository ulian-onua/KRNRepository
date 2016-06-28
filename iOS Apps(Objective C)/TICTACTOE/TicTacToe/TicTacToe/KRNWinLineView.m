//
//  KRNWinLineView.m
//  TicTacToe
//
//  Created by Drapaylo Yulian on 25.01.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import "KRNWinLineView.h"

@interface KRNWinLineView()
{
    BOOL _hide;
}
@end

@implementation KRNWinLineView

-(id)initWithFrame:(CGRect)frame StartPoint:(CGPoint)startPoint AndEndPoint:(CGPoint)endPoint;
{
    self = [super initWithFrame:frame];
    
    
    if (self)
    {
        _startPoint = startPoint;
        _endPoint = endPoint;
        _hide = NO;
    }
    return self;
    
}

-(void)drawRect:(CGRect)rect
{
    if (_hide == NO)
    {
        
   
    CGContextRef context = UIGraphicsGetCurrentContext();
  
  //  CGContextSetRGBStrokeColor(context, 1, 0, 0, 1); // красная линия
        CGContextSetRGBStrokeColor(context, 0, 0, 0, 1);
    CGContextSetLineWidth(context, 9);
    
    CGContextSetRGBFillColor(context, 1, 1, 1, 0);
    CGContextMoveToPoint(context, _startPoint.x, _startPoint.y);
    CGContextAddLineToPoint(context, _endPoint.x, _endPoint.y);
    CGContextStrokePath(context);
    }

}

-(void) hideView
{
    _hide = YES;
    [self setNeedsDisplay];
}


@end
