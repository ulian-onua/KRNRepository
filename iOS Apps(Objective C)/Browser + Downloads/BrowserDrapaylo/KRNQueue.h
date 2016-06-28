//
//  KRNQueue.h
//  MagnetometerOSX
//
//  Created by Macbook on 01.02.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol KRNQueueDelegate;


@interface KRNQueue : NSObject

@property (strong, nonatomic, readonly) NSMutableArray *storageArr; // массив, в котором будет храниться наша очередь


@property (weak, nonatomic) id<KRNQueueDelegate> delegate; // делегат

-(id) init;
-(void)addObject:(id)object; // добавить объект в конец очереди
-(id)getObject; // получить первый в очереди объект

@end


@protocol KRNQueueDelegate <NSObject>
@optional

-(void) object:(id)object WasAddedToQueue:(KRNQueue*) queue; // информация о том, что новый объект был добавлен в очередь 

@end
