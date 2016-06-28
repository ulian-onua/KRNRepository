//
//  PSKAppSettings.h

//
//  Created by Drapaylo Yulian on 08.04.16.
//  Copyright © 2016 Macbook. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <objc/runtime.h>


//ключи, которые используются для подписи на нотификации
static NSString* const PSKSetAutoCenterMapKey = @"AutoCenterMap";
static NSString* const PSKShowDistanceLine = @"ShowDistanceLine";


@interface KRNAppSettings : NSObject


+(id)sharedSettings; // получать синглтон класса и загрузить настройки из plista

-(void)loadSettings; // загрузить настройки из plista в проперти класса

-(BOOL)changeSetting:(NSString*)settingKey andValue:(id) newValue;// изменить настройку без сохранения
// settingKey ключ настройки
//newValue - новое значение
// функция проверяет, есть ли ключ settingKey в словаре с настройками, если нет
//то вернем NO
// функция проверяет, является ли newValue экземпляром того же класса (или его наследника), что и старое значение (для того, чтобы нельзя было неправильно значение записать в plist). Если нет, то вернем NO


-(BOOL)changeSetting:(NSString *)settingKey andValue:(id)newValue AndSave:(BOOL)save; // изменить настройку с возможностью выбора сохранения

// settingKey ключ настройки
//newValue - новое значение
// save - нужно ли сразу сохранить настройку в plist или нет



-(void)saveSettings;
// сохранить настройки (сделать запись в plist)

-(void)postNotificationWithSettingsKey:(NSString*)settingsKey andValue:(id) value; // запостить нотификацию об изменении значения настройки через Notification Center, где именем нотификации будет settingsKey
// нотификация публикуется автоматически при внесении изменении в настройки (независимо от их сохранения)
// подписывать на нотификации и отписываться от них необходимо по ключам настроек
// в словаре userInfo нотификации хранится один ключ-значения, где ключ - это settingsKey (т.е. совпадает с именем нотификации, а значение - новое значение измененной настройки



@property (assign, nonatomic) BOOL AutoCenterMap;  // автоцентрирование карты при изменении геолокации

@property (assign, nonatomic) BOOL ShowDistanceLine; // показать прямую линию расстояния между текущей точкой и точкой карты

@end
