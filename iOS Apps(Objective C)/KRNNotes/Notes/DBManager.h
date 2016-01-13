//
//  DBManager.h
//  Notes
//
//  Created by Drapaylo Yulian on 30.08.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface DBManager : UITableViewController


@property (nonatomic, strong) NSString *documentsDirectory;
@property (nonatomic, strong) NSString *databaseFilename;

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename;



-(NSArray *)loadDataFromDB:(NSString *)query; // загрузит данные из базы данных

-(void)executeQuery:(NSString *)query; // выполнить запрос

-(void) updateIndexesInTable:(NSString*) table;


@end
