//
//  KRNShowImageVC.h
//  BrowserDrapaylo
//
//  Created by Drapaylo Yulian on 25.05.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRNUrlStringMethods.h"

@interface KRNShowImageVC : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *imageName;

@property (strong, nonatomic) NSString* imagePath;

- (IBAction)returnButton:(id)sender;

@end
