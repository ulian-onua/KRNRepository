//
//  KRNSettingsVC.h
//  BrowserDrapaylo
//
//  Created by Drapaylo Yulian on 24.05.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KRNAppSettings.h"
#import "KRNAbstractViewController.h"

@interface KRNSettingsVC : KRNAbstractViewController<UIPickerViewDelegate, UIPickerViewDataSource>

@property (weak, nonatomic) KRNAppSettings *appSettings;


@property (weak, nonatomic) IBOutlet UILabel *maxDownloadTasks;
- (IBAction)maxDownloadTasksChecked:(id)sender;

@property (weak, nonatomic) IBOutlet UISwitch *catchJPG;
@property (weak, nonatomic) IBOutlet UISwitch *catchJPEG;
@property (weak, nonatomic) IBOutlet UISwitch *catchPNG;
@property (weak, nonatomic) IBOutlet UISwitch *catchPDF;
@property (weak, nonatomic) IBOutlet UISwitch *catchTXT;

- (IBAction)changedFormatCatch:(id)sender;



@property (weak, nonatomic) IBOutlet UIPickerView *downloadTasksPicker;

@property (weak, nonatomic) IBOutlet UIButton *okTasksPickerButton;

- (IBAction)okTasksPickerButtonPressed:(id)sender;


@end
