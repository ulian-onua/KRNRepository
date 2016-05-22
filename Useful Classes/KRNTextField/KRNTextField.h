//
//  KRNTextField.h
//  KRNTextField
//
//  Created by Drapaylo Yulian on 05.03.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

typedef void(^KRNTextFieldDelegateBlock)(UITextField*);
typedef BOOL(^KRNTextFieldDelegateBooleanBlock)(UITextField*);

typedef BOOL(^KRNTextFieldShouldChangeCharactersInRangeBlock)(UITextField*, NSRange, NSString*);





@interface KRNTextField : UITextField<UITextFieldDelegate>

@property (strong, nonatomic) KRNTextFieldDelegateBooleanBlock textFieldShouldBeginEditingBlock;
@property (strong, nonatomic) KRNTextFieldDelegateBlock textFieldDidBeginEditingBlock;
@property (strong, nonatomic) KRNTextFieldDelegateBooleanBlock textFieldShouldEndEditingBlock;
@property (strong, nonatomic) KRNTextFieldDelegateBlock textFieldDidEndEditingBlock;
@property (strong, nonatomic) KRNTextFieldShouldChangeCharactersInRangeBlock textFieldShouldChangeCharactersInRangeBlock;
@property (strong, nonatomic) KRNTextFieldDelegateBooleanBlock textFieldShouldClearBlock;
@property (strong, nonatomic) KRNTextFieldDelegateBooleanBlock textFieldShouldReturnBlock;


-(id) initWithReturnBlock:(KRNTextFieldDelegateBooleanBlock) returnBlock;



@end


