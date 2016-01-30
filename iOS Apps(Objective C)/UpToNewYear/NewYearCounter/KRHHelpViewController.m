//
//  KRHHelpViewController.m
//  UpToNewYear
//
//  Created by Drapaylo Yulian on 17.01.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import "KRHHelpViewController.h"

@interface KRHHelpViewController ()

@end

@implementation KRHHelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _helpTextView = [[UITextView alloc]initWithFrame:self.view.frame];
    
    [self.view addSubview:_helpTextView];
    
    NSString* helpText = @"UpToNewYear Options\n\nNotifications and Reminders\n\n1. Switching on notifications. You will receive everyday notifications that remind you to check time up to New year.\n2. Switching on reminders. App will schedule everyday reminders that freshen up your memory to check time up to New year.\n\nShare \n\n1.SMS. You can send an SMS with time up to New year.\n2.Twitter. You can make a tweet with time up to New year.\n3.Vkontakte. You can share time up to New year in Vkontakte social network.\n4.E-mail. You can share time up to New year via e-mail.\n\nAuthor: Drapailo Yulian\nSupport: ulian_onua@ukr.net";
    
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.alignment                = NSTextAlignmentJustified;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:helpText attributes:@{NSParagraphStyleAttributeName:paragraphStyle, NSFontAttributeName: [UIFont systemFontOfSize:16]}];
    
    
    
    paragraphStyle = NSMutableParagraphStyle.new;
    paragraphStyle.alignment  = NSTextAlignmentCenter;
    
    [attrString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:[helpText rangeOfString:@"UpToNewYear Options"]];
     
    
    
    [attrString addAttribute: NSLinkAttributeName value: @"mailto://ulian_onua@ukr.net" range: [helpText rangeOfString:@"ulian_onua@ukr.net"] ];
    
    

    
    [self makeItalicSomeParts:@[@"Switching on notifications.", @"Switching on reminders.", @"SMS.", @"Twitter.", @"Vkontakte.", @"E-mail.", @"Author", @"Support"] ofString:helpText inToString:attrString];
    
    
    [self makeBoldSomeParts:@[@"UpToNewYear Options", @"Notifications and Reminders", @"Share" ] ofString:helpText inToString:attrString];
    
    
    _helpTextView.editable = NO;
    _helpTextView.scrollEnabled = YES;
 
   
    
    
    [_helpTextView setAttributedText:attrString];
  
    self.navigationItem.title = @"Help";
    
   
}

-(void)viewDidAppear:(BOOL)animated
{
  [_helpTextView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) makeBoldSomeParts:(NSArray<NSString*>*) parts ofString:(NSString*)simpleString inToString:(NSMutableAttributedString*) string
{
     UIFont* boldFont = [UIFont boldSystemFontOfSize:18];
    
    for (NSString* onePart in parts)
    {
        [string addAttribute:NSFontAttributeName value:boldFont range:[simpleString rangeOfString:onePart]];
        
    }
}

-(void) makeItalicSomeParts:(NSArray<NSString*>*) parts ofString:(NSString*)simpleString inToString:(NSMutableAttributedString*) string
{
    UIFont* boldFont = [UIFont italicSystemFontOfSize:16];
    
    for (NSString* onePart in parts)
    {
        [string addAttribute:NSFontAttributeName value:boldFont range:[simpleString rangeOfString:onePart]];
        
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
