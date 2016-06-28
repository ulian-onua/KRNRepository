//
//  ViewController.m
//  AudioJulian
//
//  Created by admin on 05.06.16.
//  Copyright © 2016 admin. All rights reserved.
//

#import "ViewController.h"

NSString* const KRNVolumeLabel = @"Volume = %g";
NSString* const KRNSecondsLabel = @"%d of %d s";

char *KRNPickerData[3] = {"NO", "Infinite Loop", "%ld" };






@interface ViewController ()<AVAudioPlayerDelegate>

{
    SystemSoundID _mySound;
    BOOL _paused; // на паузе
    BOOL _changeSliderPositionByTimer; // изменять слайдер таймером
   
    
}

@property (strong, nonatomic) NSTimer *myTimer;



@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // получаем путь к аудио файлу
    
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"Deals" ofType:@"mp3"];
    
    NSURL *pathURL = [NSURL URLWithString:filePath];
    
    CFURLRef cfPathURL =  (__bridge CFURLRef)(pathURL); // делаем Bridge
    

    //  создаем аудио файл
    
    AudioServicesCreateSystemSoundID(cfPathURL, &_mySound);
    
  
    
   
    NSError *myError;
    
  
    _myPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL URLWithString:filePath] error:&myError];
    
    
    
    _volumeLabel.text = [NSString stringWithFormat:KRNVolumeLabel, _myPlayer.volume*10];  // громкость на данный момент
    _volumeChanger.value = _myPlayer.volume * 10;
    
    _secondLabel.text = [NSString stringWithFormat:KRNSecondsLabel, 0,  (int)_myPlayer.duration];
    
    
    _rateSegmentedControl.selectedSegmentIndex = 1; // по умолчанию - нормальная скорость проигрывания
    
    _panSegmentedControl.selectedSegmentIndex = 1; // по умолчанию - по центру
    
    
    _changeLoopAudioPickerView.delegate = self; 

    
    
    _paused = NO;
    
    _changeSliderPositionByTimer = YES;
    
    
   
}

-(float)getRateFromCurrentSegmentedControl // получить Rate исходя из текущих значений Segmented Control'а
{
    NSString* currentControlTitle = [_rateSegmentedControl titleForSegmentAtIndex:_rateSegmentedControl.selectedSegmentIndex]; // получаем текущее значение
    
    currentControlTitle = [currentControlTitle stringByTrimmingCharactersInSet:[NSCharacterSet letterCharacterSet]]; // удаляем все буквы
    
    return [currentControlTitle floatValue]; // возвращаем float значение
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)playSound:(id)sender
{
  //  AudioServicesPlaySystemSound(_mySound);
  //  AudioServicesPlayAlertSound(_mySound);
//    AudioServicesPlayAlertSoundWithCompletion(_mySound, ^{
//        NSLog(@"Sound was played");
//    });
    

    
//      _myPlayer.rate = 4.0f;
//    _myPlayer.enableRate = YES;
//

if (!_paused)
{
    // допускаем возможность регулирования рейта
    _myPlayer.enableRate = YES;
    _myPlayer.rate = [self getRateFromCurrentSegmentedControl];
    
    [_myPlayer prepareToPlay];
    
    [_myPlayer setDelegate:self];
    _myTimer = [NSTimer timerWithTimeInterval:0.1 target:self selector:@selector(changeProgressViewProgress) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_myTimer forMode:NSDefaultRunLoopMode];
}
    

    

[_myPlayer play];
    
    _paused = NO;
    
 
    
}


// таймер отрабаывает
-(void) changeProgressViewProgress
{
    // меняем прогресс
    
  if (_changeSliderPositionByTimer) // если кнопка слайдера не выбрана пользователем
  {
      
 
    
  _soundProgressView.progress = (_myPlayer.currentTime / _myPlayer.duration);
  _slider.value = _soundProgressView.progress;
    
     _secondLabel.text = [NSString stringWithFormat:KRNSecondsLabel, (int)_myPlayer.currentTime, (int)_myPlayer.duration];
  }
}



- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"Player %@ did finish playing. Successfully: %d", player, flag);
    _soundProgressView.progress = 0;
    _slider.value = _soundProgressView.progress;
    [_myTimer invalidate];
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error
{
    NSLog(@"ERROR occurred");
}



- (IBAction)stop:(id)sender
{
    [_myPlayer stop];
    _myPlayer.currentTime = 0;
    _soundProgressView.progress = 0;
    _slider.value = _soundProgressView.progress;
     [_myTimer invalidate];
}

- (IBAction)pause:(id)sender
{
    [_myPlayer pause];
    
}

- (IBAction)touchDown:(id)sender
{
    NSLog(@"Touch down");
    _changeSliderPositionByTimer = NO;
}



- (IBAction)touchUp:(id)sender
{
     NSLog(@"Touch cancel");
    
    UISlider* slider = sender;
    
    _myPlayer.currentTime = slider.value * _myPlayer.duration; // меняем текущее время проигрывания на слайдере
    
    _soundProgressView.progress = slider.value;
    
     _secondLabel.text = [NSString stringWithFormat:KRNSecondsLabel, (int)_myPlayer.currentTime, (int)_myPlayer.duration]; // меняем текущую секунду
    
    
    
    _changeSliderPositionByTimer = YES;
}

- (IBAction)volumeChanged:(id)sender
{
    UIStepper *stepper = sender;
    
    _myPlayer.volume = (float) stepper.value / 10;
    
    _volumeLabel.text = [NSString stringWithFormat:KRNVolumeLabel, _myPlayer.volume*10];  // громкость на данный момент
}


- (IBAction)rateChanged:(id)sender
{
    UISegmentedControl* segmentedControl = sender;
    
    
    // меняем рейт в зависимости от показателей _selectedSegmentedControl
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            _myPlayer.rate = 0.5f;
            break;
        case 1:
            _myPlayer.rate = 1.f;
            break;
        case 2:
            _myPlayer.rate = 1.5f;
            break;
        case 3:
            _myPlayer.rate = 2.f;
            break;
        default:
            break;
    }

}
- (IBAction)panChanged:(id)sender
{
     UISegmentedControl* segmentedControl = sender;
    
    // меняем стерео сигналы в зависимости от Pan
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            _myPlayer.pan = -1.0f;
            break;
        case 1:
            _myPlayer.pan = 0.f;
            break;
        case 2:
            _myPlayer.pan = 1.0f;
            break;
        default:
            break;
    }
    
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
   if (row == 0 || row == 1)  // если выбран режим без повторений или бесконечное количество повторений, то вернем соответствующую строку
       return [NSString stringWithUTF8String:KRNPickerData[row]];
    else
    {
      
        NSString* formatString = [NSString stringWithUTF8String: KRNPickerData[2]];
        
        return [NSString stringWithFormat:formatString,(long)row];
    }

    
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row == 0 || row == 1)
    {
        _loopAudioLabel.text =[NSString stringWithUTF8String:KRNPickerData[row]];
        
        if (row == 0) // если повторений не нужно
        {
            _myPlayer.numberOfLoops = 0;
        }
        else // бесконечное число повторений
            _myPlayer.numberOfLoops = -1;
        
    }
    else
    {
           NSString* formatString = [NSString stringWithUTF8String: KRNPickerData[2]];
        _loopAudioLabel.text = [NSString stringWithFormat:formatString,(long)row];
        
        _myPlayer.numberOfLoops = row-1; // соответствующее число повторений
    }
  
    
}


-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    // скроем PickerView по нажатию в любом месте экрана
    UITouch *touch = [touches anyObject];
    
    CGPoint locInView = [touch locationInView:nil];
    
    if (!CGRectContainsPoint(_changeLoopAudioPickerView.frame, locInView))
        {
            _changeLoopAudioPickerView.hidden = YES;
        }
    
    
}

- (IBAction)changeLoopAudio:(id)sender
{
    _changeLoopAudioPickerView.hidden = NO;
}
@end
