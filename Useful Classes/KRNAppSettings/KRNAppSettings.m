//
//  KRNAppSettings.m
//  
//
//  Created by Drapaylo Yulian on 08.04.16.
//  Copyright © 2016 Macbook. All rights reserved.
//


#import "KRNAppSettings.h"

static NSString* const settingsFileName = @"Settings.plist"; // имя plist'а
static NSString* plistPath; // путь к plist NSDocumentsDirectory

dispatch_semaphore_t plistSemaphore; // семафор на запись/чтения из плиста


typedef void(^AllPropertiesBlock)(objc_property_t property); // тип блока, который позволит произвести действий над одним из пропертей в цикле


@interface KRNAppSettings ()
{
    NSMutableDictionary* _settingsDict; // словарь с настройками, полученный из plist'a, и записываем в plist
}
@end


@implementation KRNAppSettings



-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSLog(@"DICT = %@", change);
    NSLog(@"VALUE CHANGED");
    
    
    id changedObject = [self valueForKey:keyPath]; // получаем уже необходимое значение (в случае, если это примитив, то KVC сама переведет его в NSNumber)
    
    [self changeSetting:keyPath andValue:changedObject AndSave:YES]; // меняем и сохраняем настройки
    
    
}

+(id)sharedSettings
{
    
    static PSKAppSettings *sharedSettings = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedSettings = [[self alloc] init];
        
        // копируем в DocumentsDirectory
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
         NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
      
        NSError *error;
        
        NSString *settingsPath = [NSString stringWithFormat:@"%@/%@", documentsDirectory, settingsFileName]; // получаем полный путь
        
        // если в DocumentsDirectory отсутствует файл настроек, то нужно его создать с дефолтными настройками
        if (![fileManager fileExistsAtPath:settingsPath])
        {
            [sharedSettings setDefaultPropertiesValues]; // записываем в проперти дефолтные значения
            __block NSMutableDictionary* dictForPlist = [NSMutableDictionary new];
            
            [self runAllPropertiesLoop:^(objc_property_t property) {
                NSString* nextPropertyName = [NSString stringWithUTF8String: property_getName(property)]; // получаем имя очередной проперти
                id object = [sharedSettings valueForKey: nextPropertyName]; // получаем KVO-значение
                [dictForPlist setValue:object forKey:nextPropertyName]; // запихиваем очередную пару значений в словарь
                 
            }];
            
            
           BOOL result = [dictForPlist writeToFile:settingsPath atomically:YES]; // записываем настройки в DocumentsDirectory
            
           if (!result) // если настройки записать не получилось, то будет креш
                abort();
            
        }
        
        plistPath = settingsPath; // присваиваим путь к плисту

        plistSemaphore = dispatch_semaphore_create(1); // создаем семафор на один поток
        
        
        // устанавливаем обсервер на каждое из пропертей
        [self runAllPropertiesLoop:^(objc_property_t property) {
            const char *name = property_getName(property);
            [sharedSettings addObserver:sharedSettings forKeyPath:[NSString stringWithUTF8String:name] options: NSKeyValueObservingOptionNew context:nil];
        }];
        
        [sharedSettings loadSettings];
    });
    


    
    return sharedSettings;
}



-(void)loadSettings
{
    // ставим семафор (если вдруг в этот момент происходит запись настроек), то поток подождет
    dispatch_semaphore_wait(plistSemaphore, DISPATCH_TIME_FOREVER);
    _settingsDict = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    dispatch_semaphore_signal(plistSemaphore);
    
    
    // загружаем настройки в проперти со словаря
    [PSKAppSettings runAllPropertiesLoop:^(objc_property_t property) {
        
        NSString* nextPropertyName = [NSString stringWithUTF8String: property_getName(property)]; // получаем имя очередной проперти
        
        id objectFromDict = [_settingsDict objectForKey:nextPropertyName]; // получаем объект со словаря
        
        [self setValue:objectFromDict forKey:nextPropertyName]; // установим нужной проперти значение словаря
        //        // если проперти примитивного типа, то KVC автоматически извлечет из NSNumber или NSValue нужный примитивный тип
        
    }];
   
}


-(BOOL)changeSetting:(NSString*)settingKey andValue:(id) newValue // изменить настройку без сохранения

{
    id settingValue = [_settingsDict objectForKey:settingKey]; // текущая настройка
    
    if (settingValue) // если такая настройка существует
    {
        if ([settingValue isKindOfClass:[newValue class]]) // если это экземпляры объектов одного класса или наследника, то можно провести запись
        {
            [_settingsDict setObject:newValue forKey:settingKey];
            [self postNotificationWithSettingsKey:settingKey andValue:newValue]; // постим нотификацию
            return YES;
            
        }
    }
    return NO;
}
-(BOOL)changeSetting:(NSString *)settingKey andValue:(id)newValue AndSave:(BOOL)save  // изменить настройку с возможностью выбора сохранения

{
    if ([self changeSetting:settingKey andValue:newValue])
    {
        if (save)
            [self saveSettings];
        return YES;
    }
    
    return NO;
}

-(void)saveSettings // сохранить настройки (сделать запись в plist)
{
    dispatch_semaphore_wait(plistSemaphore, DISPATCH_TIME_FOREVER);
    [_settingsDict writeToFile:plistPath atomically:YES];
       dispatch_semaphore_signal(plistSemaphore);
}

-(void)postNotificationWithSettingsKey:(NSString*)settingsKey andValue:(id) value // запостить нотификацию об изменении значения настройки через Notification Center
{
    NSNotificationCenter *notifCenter = [NSNotificationCenter defaultCenter];
    [notifCenter postNotificationName:settingsKey object:self userInfo:@{settingsKey:value}];
    
}

-(void) dealloc
{
    // удаляем все обсерверы KVO
    [PSKAppSettings runAllPropertiesLoop:^(objc_property_t property) {
        const char *name = property_getName(property);
        [self removeObserver:self forKeyPath:[NSString stringWithUTF8String:name]]; //
    }];
}

#pragma mark - Help Functions (Вспомогательные функции)

+(void) runAllPropertiesLoop:(AllPropertiesBlock) allPropertiesBlock // запустить цикл прохода всех пропертей класса
{
    unsigned int outCount;
    
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    for (int i = 0; i < outCount; i++)
    {
        allPropertiesBlock(properties[i]); // выполним действия с отдельным проперти
    }
}


#pragma mark - SetDefaultValues

// Тут нужно установить дефолтные значения, которые будут записаны в plist при первом запуске настроек

-(void) setDefaultPropertiesValues // установить дефолтные значения пропертей
{
    _AutoCenterMap = YES;
    _ShowDistanceLine = YES;
}




@end
