//
//  ViewController.h
//  AudioJulian
//
//  Created by admin on 05.06.16.
//  Copyright © 2016 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
@import AVFoundation;


@interface ViewController : UIViewController<UIPickerViewDelegate>

- (IBAction)playSound:(id)sender;
@property (weak, nonatomic) IBOutlet UIProgressView *soundProgressView;
@property (weak, nonatomic) IBOutlet UISlider *slider;
@property (weak, nonatomic) IBOutlet UILabel *volumeLabel; // лейбл, отображающий громкость

@property (weak, nonatomic) IBOutlet UILabel *secondLabel; // лебл, отображающий количество секунд

// изменение скорости прокрутки Audio (Rate)
@property (weak, nonatomic) IBOutlet UISegmentedControl *rateSegmentedControl;

- (IBAction)rateChanged:(id)sender;

// изменение баланса стереоканалов

@property (weak, nonatomic) IBOutlet UISegmentedControl *panSegmentedControl;
- (IBAction)panChanged:(id)sender;

// изменить Loop Audio
@property (weak, nonatomic) IBOutlet UIPickerView *changeLoopAudioPickerView;

- (IBAction)changeLoopAudio:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *loopAudioLabel;


@property (strong, nonatomic) AVAudioPlayer *myPlayer;

- (IBAction)stop:(id)sender;
- (IBAction)pause:(id)sender;


- (IBAction)touchDown:(id)sender;

- (IBAction)touchUp:(id)sender;


@property (weak, nonatomic) IBOutlet UIStepper *volumeChanger;

- (IBAction)volumeChanged:(id)sender;

@end

