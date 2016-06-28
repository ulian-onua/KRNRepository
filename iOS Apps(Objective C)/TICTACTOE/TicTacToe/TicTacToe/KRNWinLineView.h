//
//  KRNWinLineView.h
//  TicTacToe
//
//  Created by Drapaylo Yulian on 25.01.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;


@interface KRNWinLineView : UIView


@property (assign, readonly, nonatomic) CGPoint startPoint;
@property (assign, readonly, nonatomic) CGPoint endPoint;


-(id)initWithFrame:(CGRect)frame StartPoint:(CGPoint)startPoint AndEndPoint:(CGPoint)endPoint;
-(void) hideView;

@end
