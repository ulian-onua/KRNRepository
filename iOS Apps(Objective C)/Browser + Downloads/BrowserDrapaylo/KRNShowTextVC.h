//
//  KRNShowTextVC.h
//  BrowserDrapaylo
//
//  Created by Drapaylo Yulian on 27.05.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRNUrlStringMethods.h"

@interface KRNShowTextVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *textFileName;

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) NSString* filePath;


- (IBAction)backButtonPressed:(id)sender;

@end
