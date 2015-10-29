//
//  KRNStack.h
//  StackObjectiveC
//
//  Created by Drapaylo Yulian on 26.10.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KRNStack : NSObject

-(id)init;
-(void)pushObject:(id)object;
-(id)popObject;
-(void)logAllObjects;

@end
