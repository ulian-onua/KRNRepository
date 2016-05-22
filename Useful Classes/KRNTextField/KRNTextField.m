//
//  KRNTextField.m
//  KRNTextField
//
//  Created by Drapaylo Yulian on 05.03.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import "KRNTextField.h"

@implementation KRNTextField

-(id) init
{
    KRNTextFieldDelegateBooleanBlock block = ^(UITextField* textField)
    {
        [textField resignFirstResponder];
        return YES;
        
    };
    
    
    return [self initWithReturnBlock:block];
}

-(id) initWithReturnBlock:(KRNTextFieldDelegateBooleanBlock) returnBlock
{
    self = [super init];
    
    if (self)
    {
        _textFieldShouldReturnBlock = returnBlock;
        self.delegate = self;
        
    }
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        self.delegate = self;
        // закрываем окно по умолчанию
        _textFieldShouldReturnBlock = ^(UITextField* textField)
        {
            [textField resignFirstResponder];
            return YES;
        };

    }
    return self;
}

#pragma mark - UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    __weak UITextField* textFieldForBlock = textField;
    return _textFieldShouldReturnBlock(textFieldForBlock);

}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    __weak UITextField* textFieldForBlock = textField;
    if (_textFieldShouldBeginEditingBlock)
        _textFieldDidBeginEditingBlock(textFieldForBlock);

}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    __weak UITextField* textFieldForBlock = textField;
    if (_textFieldShouldBeginEditingBlock)
        return _textFieldShouldBeginEditingBlock(textFieldForBlock);
    else
        return YES;
        
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    __weak UITextField* textFieldForBlock = textField;
    if (_textFieldDidEndEditingBlock)
        _textFieldDidEndEditingBlock(textFieldForBlock);
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (_textFieldShouldChangeCharactersInRangeBlock)
    {
        __weak UITextField* textFieldForBlock = textField;
        return _textFieldShouldChangeCharactersInRangeBlock(textFieldForBlock, range, string);
    }
    else
        return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    if (_textFieldShouldClearBlock)
    {
    
    __weak UITextField* textFieldForBlock = textField;
    
    
    return _textFieldShouldClearBlock(textFieldForBlock);
    }
    else
        return YES;
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    
    if (_textFieldShouldBeginEditingBlock)
        {
            __weak UITextField* textFieldForBlock = textField;
           return _textFieldShouldBeginEditingBlock(textFieldForBlock);
        }
    else
        return YES;
 
}




@end
