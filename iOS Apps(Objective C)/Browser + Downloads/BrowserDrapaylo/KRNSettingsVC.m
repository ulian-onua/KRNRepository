//
//  KRNSettingsVC.m
//  BrowserDrapaylo
//
//  Created by Drapaylo Yulian on 24.05.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import "KRNSettingsVC.h"

@interface  KRNSettingsVC()
{
    NSInteger _pickerValueChecked;
}

@end

@implementation KRNSettingsVC

-(void) viewDidLoad
{
    _appSettings = [KRNAppSettings sharedSettings];
    
    _maxDownloadTasks.text = [NSString stringWithFormat:@"%lu", (unsigned long)_appSettings.maxDownloadTasks];
    
    
    _catchJPG.on = _appSettings.catchFileTypes & KRNFormatJPG;
    _catchJPEG.on = _appSettings.catchFileTypes & KRNFormatJPEG;
    _catchPNG.on = _appSettings.catchFileTypes & KRNFormatPNG;
    _catchPDF.on = _appSettings.catchFileTypes & KRNFormatPDF;
    _catchTXT.on = _appSettings.catchFileTypes & KRNFormatTXT;
    
    
    
    // настраиваем picker
    _downloadTasksPicker.hidden = YES;
    _downloadTasksPicker.dataSource = self;
    _downloadTasksPicker.delegate = self;
    
    // настраиваем кнопку, которая отрабатывает с pickerом
    
    _okTasksPickerButton.hidden = YES;
}

- (IBAction)changedFormatCatch:(id)sender
{
    UISwitch *switchChanged = sender;
    if (switchChanged == _catchJPG)
        _appSettings.catchFileTypes ^= KRNFormatJPG;
    else
        if (switchChanged == _catchJPEG)
            _appSettings.catchFileTypes ^= KRNFormatJPEG;
    else
        if (switchChanged == _catchPNG)
             _appSettings.catchFileTypes ^= KRNFormatPNG;
    else
        if (switchChanged == _catchPDF)
            _appSettings.catchFileTypes ^= KRNFormatPDF;
    else
        if (switchChanged == _catchTXT)
             _appSettings.catchFileTypes ^= KRNFormatTXT;

}

#pragma mark -  UIPickerViewDataSource


// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 100;
}



- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [NSString stringWithFormat:@"%ld", (long)row];
    
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _pickerValueChecked = row; // последняя выбранная строка
    _appSettings.maxDownloadTasks = row;
    _maxDownloadTasks.text = [NSString stringWithFormat:@"%lu", (unsigned long)_appSettings.maxDownloadTasks];
    
}

- (IBAction)okTasksPickerButtonPressed:(id)sender
{
    _downloadTasksPicker.hidden = YES;
    _okTasksPickerButton.hidden = YES;
}
- (IBAction)maxDownloadTasksChecked:(id)sender
{
    _downloadTasksPicker.hidden = NO;
    _okTasksPickerButton.hidden = NO;
    [_downloadTasksPicker selectRow:_appSettings.maxDownloadTasks inComponent:0 animated:NO];
    
}
@end
