//
//  KRNShowNoteCell.m
//  Notes
//
//  Created by Drapaylo Yulian on 28.08.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//

#import "KRNShowNoteCell.h"

NSString *const ShowFullNoteVCTrashButtonPressed = @"ShowFullNoteVCTrashButtonPressed";

@implementation KRNShowNoteCell

- (IBAction)trashButton:(id)sender
{
    UIButton* tempButton = sender;
    
    CGPoint buttonPoints = [tempButton convertPoint:CGPointZero toView:self.superview];

    
    NSDictionary *tempDict = CFBridgingRelease(CGPointCreateDictionaryRepresentation(buttonPoints));
    
    //[NSDictionary dictionaryWithObjectsAndKeys:myCGPointX, @"Xkey", myCGPointY, @"Ykey", nil];
    
    NSNotificationCenter* tempNC = [NSNotificationCenter defaultCenter];
    
    [tempNC postNotificationName:ShowFullNoteVCTrashButtonPressed object:self userInfo:tempDict];
    
    /*CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:[super view]];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition]; */

}
@end
