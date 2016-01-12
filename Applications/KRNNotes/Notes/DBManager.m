//
//  DBManager.m
//  Notes
//
//  Created by Drapaylo Yulian on 30.08.15.
//  Copyright © 2015 Drapaylo Yulian. All rights reserved.
//

#import "DBManager.h"


@interface DBManager()


-(void)copyDatabaseIntoDocumentsDirectory; // скопировать базу даннных в директорию документов


@property (nonatomic, strong) NSMutableArray *arrResults;


-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable;

@property (nonatomic, strong) NSMutableArray *arrColumnNames;

@property (nonatomic) int affectedRows;

@property (nonatomic) long long lastInsertedRowID;

@end

@implementation DBManager

-(instancetype)initWithDatabaseFilename:(NSString *)dbFilename{
    self = [super init];
    if (self) {
        
        // Set the documents directory path to the documentsDirectory property.
        
        // получаем доступ к директории Документов и сохраняем ее в проперти
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        self.documentsDirectory = [paths objectAtIndex:0];
        
        // сохраняет имя базы данных в проперти
        self.databaseFilename = dbFilename;
        
        // Copy the database file into the documents directory if necessary.
        [self copyDatabaseIntoDocumentsDirectory];
        
    }
    return self;
}


-(void)copyDatabaseIntoDocumentsDirectory{
    // Check if the database file exists in the documents directory.
    NSString *destinationPath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename]; // создаем имя базы данных
    
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:destinationPath]) // если база данных не существует
    {
        // The database file does not exist in the documents directory, so copy it from the main bundle now.
        NSString *sourcePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:self.databaseFilename]; // источник с базой данных
        NSError *error;
        [[NSFileManager defaultManager] copyItemAtPath:sourcePath toPath:destinationPath error:&error]; // копируем в документы
        
        // Check if any error occurred during copying and display it.
        if (error != nil) {
            NSLog(@"%@", [error localizedDescription]);
        }
        
    }
}


-(void)runQuery:(const char *)query isQueryExecutable:(BOOL)queryExecutable
{
    // Create a sqlite object.
    sqlite3 *sqlite3Database; // создаем объект sqltie
    
    // Set the database file path.
    NSString *databasePath = [self.documentsDirectory stringByAppendingPathComponent:self.databaseFilename]; // устанавливаем путь к базе данных
    
    // Initialize the results array.
    if (self.arrResults != nil) {
        [self.arrResults removeAllObjects];
        self.arrResults = nil;
    }
    self.arrResults = [[NSMutableArray alloc] init];
    
    // Initialize the column names array.
    if (self.arrColumnNames != nil) {
        [self.arrColumnNames removeAllObjects];
        self.arrColumnNames = nil;
    }
    self.arrColumnNames = [[NSMutableArray alloc] init];
    
    // открываем базу данных
    
    BOOL openDatabaseResult = sqlite3_open([databasePath UTF8String], &sqlite3Database);
    
    NSLog (@"");
 
    if(openDatabaseResult == SQLITE_OK)
    {
    
    sqlite3_stmt *compiledStatement;
        
    BOOL prepareStatementResult = sqlite3_prepare_v2(sqlite3Database, query, -1, &compiledStatement, NULL);
        
   
    
 if(prepareStatementResult == SQLITE_OK) {
     
     // check is query is executable
     if (!queryExecutable)
     {
         // In this case data must be loaded from the database.
         
         // Declare an array to keep the data for each fetched row.
         NSMutableArray *arrDataRow;
         
    //     int i = sqlite3_step(compiledStatement);
         
         
         // Loop through the results and add them to the results array row by row.
         while(sqlite3_step(compiledStatement) == SQLITE_ROW)
         {
             // Initialize the mutable array that will contain the data of a fetched row.
             arrDataRow = [[NSMutableArray alloc] init];
             
             // Get the total number of columns.
             int totalColumns = sqlite3_column_count(compiledStatement);
             
             // Go through all columns and fetch each column data.
             for (int i=0; i<totalColumns; i++){
                 // Convert the column data to text (characters).
                 char *dbDataAsChars = (char *)sqlite3_column_text(compiledStatement, i);
                 
                 // If there are contents in the currenct column (field) then add them to the current row array.
                 if (dbDataAsChars != NULL) {
                     // Convert the characters to string.
                     [arrDataRow addObject:[NSString  stringWithUTF8String:dbDataAsChars]];
                 }
                 
                 // Keep the current column name.
                 if (self.arrColumnNames.count != totalColumns) {
                     dbDataAsChars = (char *)sqlite3_column_name(compiledStatement, i);
                     [self.arrColumnNames addObject:[NSString stringWithUTF8String:dbDataAsChars]];
                 }
             }
             
             // Store each fetched data row in the results array, but first check if there is actually data.
             if (arrDataRow.count > 0) {
                 [self.arrResults addObject:arrDataRow];
             }
         }
     }
     
        else   {
         // This is the case of an executable query (insert, update, ...).
         
         // Execute the query.
           int executeQueryResults = sqlite3_step(compiledStatement);
            if (executeQueryResults == SQLITE_DONE) {
             // Keep the affected rows.
             self.affectedRows = sqlite3_changes(sqlite3Database);
             
             // Keep the last inserted row ID.
             self.lastInsertedRowID = sqlite3_last_insert_rowid(sqlite3Database);
            }
            else {
             // If could not execute the query show the error message on the debugger.
                NSLog(@"DB Error: %s", sqlite3_errmsg(sqlite3Database));
         }
        }
            }
        else {
     // In the database cannot be opened then show the error message on the debugger.
     NSLog(@"%s", sqlite3_errmsg(sqlite3Database));
        
        
        }
        // Release the compiled statement from memory.
        sqlite3_finalize(compiledStatement);
    }
    
    // Close the database.
    sqlite3_close(sqlite3Database);
    

}

-(NSArray *)loadDataFromDB:(NSString *)query{
    // Run the query and indicate that is not executable.
    // The query string is converted to a char* object.
    [self runQuery:[query UTF8String] isQueryExecutable:NO];
    
    // Returned the loaded results.
    return (NSArray *)self.arrResults;
}

-(void)executeQuery:(NSString *)query{
    // Run the query and indicate that is executable.
    [self runQuery:[query UTF8String] isQueryExecutable:YES];
}

-(void) updateIndexesInTable:(NSString*) table // обновляем индексы в таблице, чтобы они были 1,2,3 и т.д
{
    NSString* query = [NSString stringWithFormat:@"select * from %@", table];
    
    NSArray *tempArr = [[NSArray alloc] init];
    tempArr = [self loadDataFromDB:query];
    
    
    
    NSMutableArray *tempArr2 = [NSMutableArray new];
    
    for (int i = 0; i < tempArr.count; i++)
    {
        [tempArr2 addObject:[[tempArr objectAtIndex:i] objectAtIndex:1]];
    }
   
    
    for (int i = 0; i <tempArr2.count; i++)
    {
        
        //NSArray *tempArr2 = [tempArr objectAtIndex:i]; // получаем вложенный массив (пока непонятно, почему их два вложенных
        
        NSString *tempQuery = [NSString stringWithFormat:@"update %@ set number=%d where textnote='%@'", table, i+1, [tempArr2 objectAtIndex:i]];
        
        [self executeQuery:tempQuery];
     
    }
    
    //NSLog (@"%@", tempArr);
    
    
}







@end
