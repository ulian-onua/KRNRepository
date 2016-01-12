//
//  ShowFullNoteViewController.m
//  Notes
//
//  Created by Drapaylo Yulian on 28.08.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//

#import "ShowFullNoteViewController.h"




@implementation ShowFullNoteViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.fullNoteTextField.text = self.fullNote;
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

@end
