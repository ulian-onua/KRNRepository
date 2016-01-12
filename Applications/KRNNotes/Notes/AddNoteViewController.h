//
//  AddNoteViewController.h
//  Notes
//
//  Created by Drapaylo Yulian on 28.08.15.
//  Copyright (c) 2015 Drapaylo Yulian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNoteViewController : UIViewController<UITextViewDelegate>




@property (weak, nonatomic) IBOutlet UITextView *noteField;


- (IBAction)AddNoteAction:(id)sender;


@end
