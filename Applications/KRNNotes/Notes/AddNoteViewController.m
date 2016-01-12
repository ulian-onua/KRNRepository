//
//  AddNoteViewController.m
//  Notes
//
//  Created by Drapaylo Yulian on 28.08.15.
//  Copyright (c) 2015 Drapaylo Yulian. All rights reserved.
//

#import "AddNoteViewController.h"

@implementation AddNoteViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

-(void) viewWillAppear:(BOOL)animated
{
 
    [self.noteField becomeFirstResponder];
  
 
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)AddNoteAction:(id)sender {

}


@end
