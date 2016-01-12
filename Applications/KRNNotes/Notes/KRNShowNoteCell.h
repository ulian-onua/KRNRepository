//
//  KRNShowNoteCell.h
//  Notes
//
//  Created by Drapaylo Yulian on 28.08.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//

#import <UIKit/UIKit.h>

 extern NSString *const ShowFullNoteVCTrashButtonPressed;

@interface KRNShowNoteCell : UITableViewCell // класс для метки, которая будет отображать начальные слова заметки


@property (weak, nonatomic) IBOutlet UILabel *noteLabel; // метка, которая будет отображать начальные слова заметки

- (IBAction)trashButton:(id)sender; // нажата кнопка удалить
@end
