//
//  ShowFullNoteViewController.h
//  Notes
//
//  Created by Drapaylo Yulian on 28.08.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface ShowFullNoteViewController : UIViewController // View Controller, в котором будет отображаться полный текст заметки

@property (weak, nonatomic) IBOutlet UITextView *fullNoteTextField; // текстовое поле, в котором будет отображаться полный текст заметки

@property NSString* fullNote; // переменная, которая будет хранить текст заметки и который после инициализации по ViewDidLoad будет присваиваеться текстовому виду (UITextView)

@end
