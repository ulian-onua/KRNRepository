//
//  KRNMyView.m
//  shtrixCode
//
//  Created by Drapaylo Yulian on 30.09.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//

#import "KRNMyView.h"

@implementation KRNMyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void) clearViewFromSubviews

{
    for (UIView* view in self.subviews)
        [view removeFromSuperview];

}


@end
