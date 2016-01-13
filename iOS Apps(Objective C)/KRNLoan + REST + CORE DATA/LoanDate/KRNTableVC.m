//
//  KRNTableVC.m
//  LoanDate
//
//  Created by Administrator on 03.12.15.
//  Copyright © 2015 Administrator. All rights reserved.
//

#import "KRNTableVC.h"

NSString* const KRNCoreDataFilled = @"KRNCoreDataFilled";

@interface KRNTableVC ()<ReguestDelegate>

{
    NSInteger _selectedRow;  // последняя выделенная строка
    BOOL _reload; // подан запрос на релоад данных?
}

@property RequestObject* myRequest; // класс, осуществляющий HTTP-запрос

@property __block NSArray <Person*> *fetchedResults; // массив с выборком из Core Data


@property (weak) AppDelegate* appDelegate; // ссылка на AppDelegate

//@property (strong) dispatch_queue_t myQueue; // поток для работы с Core Data

@end

@implementation KRNTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
     _appDelegate = [[UIApplication sharedApplication] delegate];
    
    _reload = NO;
    
    //_myQueue = dispatch_queue_create("com.LoanDate.myQueue2", NULL);
    
    _myRequest = [[RequestObject alloc] init];
    _myRequest.requestDelegate = self;


    // если это первый запуск и Core Data вообще не заполнена
    if ([[NSUserDefaults standardUserDefaults] objectForKey:KRNCoreDataFilled] == nil)
        
        
        
        [_myRequest makeRequest]; // делаем запрос

        else
        {
            _activityIndicator.hidden = YES;
            _reloadButton.enabled = YES;
     //       dispatch_async(_myQueue,
       //     ^{
                [self fetchRequestForPersons:^(NSArray<Person *> *fetchedRes) // делаем выборку
                 {
                     // если выборка успешна, то в главном потоке перегружаем TableView
                     dispatch_async(dispatch_get_main_queue(),
                                    ^{
                                        [self.tableView reloadData];
                                    });
                 }];
     //       });
        }
    
    
    
   
    
    
}

-(void) viewWillAppear:(BOOL)animated
{
   [super viewWillAppear:animated];
   [self.tableView reloadData]; // при возвращении с другого ViewControllera нужно перегрузить Table View, так как данные в результате редактирования могли измениться (если не сделать перезагрузку данных в Table View, то останутся старые данные)
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// делегатный метод
-(void) connect:(NSArray*) receivedArray // успешное соединение
{
    
    NSArray <NSDictionary*> *loans; // cоздаем временный словарь, в который будут записаны loans
    
    NSLog(@"Received Dictionary = %@", receivedArray);
    loans = [NSArray arrayWithArray:receivedArray];
    
   
    
    if (_reload == YES) // если был подан запрос на релоад данных
    {
        [self deleteAllFromCoreData]; // очистим старые данные с Core Data
        _reload = NO;
    }
    
    // распарсим полученные данные и загрузим их в Table View
    

     
    [self parseArrayToCoreData:loans];

    
    [self fetchRequestForPersons:^(NSArray<Person *> *fetchedRes) {
  
            [self.tableView reloadData];
            _activityIndicator.hidden = YES;
            _reloadButton.enabled = YES;
   
    }];

    
}

-(void) connectFailed // ошибка получения данных - выведем Alert View
{
    _activityIndicator.hidden = YES;
    _reloadButton.enabled = YES;
    
    UIAlertController* myAlertController = [UIAlertController alertControllerWithTitle:@"Warning!" message:@"Error receiving data from HTTP.\n Try to refresh." preferredStyle: UIAlertControllerStyleAlert];
    
    [myAlertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        [myAlertController dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [self presentViewController:myAlertController animated:YES completion:nil];

}

- (void) parseArrayToCoreData:(NSArray<NSDictionary*>*) loans // парсим массив cо словарем и кидаем его в Core Data
{
    
    NSManagedObjectContext* context = [_appDelegate managedObjectContext];
    
    for (NSDictionary *loan in loans)
    {

 
           // заполняем entity - Person
        Person *nextPerson = [NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];

            if ([loan objectForKey:@"name"])
            {
                nextPerson.name = [loan objectForKey: @"name"];
                [self logKindOfClass:[loan objectForKey: @"name"] withName:@"name"];
                
            }
        
            if ([loan objectForKey:@"activity"])
            {
                nextPerson.activity_string = [loan objectForKey:@"activity"];
                [self logKindOfClass:[loan objectForKey: @"activity"] withName:@"activity"];
            }
        
        // заполняем entity - Loan
        
        nextPerson.loan = [NSEntityDescription insertNewObjectForEntityForName:@"Loan" inManagedObjectContext:context];
        
            if ([loan objectForKey:@"posted_date"])
            {
                
                nextPerson.loan.date = [loan objectForKey:@"posted_date"];
                [self logKindOfClass:[loan objectForKey: @"posted_date"] withName:@"posted_date"];
            }
        
            if ([loan objectForKey:@"id"])
            {
                nextPerson.loan.loanId = [loan objectForKey:@"id"];
                 [self logKindOfClass:[loan objectForKey: @"id"] withName:@"id"];
            }
        
            if ([loan objectForKey:@"loan_amount"])
            {
                nextPerson.loan.loan_amount = [loan objectForKey:@"loan_amount"];
                [self logKindOfClass:[loan objectForKey: @"loan_amount"] withName:@"loan_amount"];
            }
            if ([loan objectForKey:@"funded_amount"])
            {
                nextPerson.loan.raise = [loan objectForKey:@"funded_amount"];
                [self logKindOfClass:[loan objectForKey: @"funded_amount"] withName:@"funded_amount"];
            }
        
            if ([loan objectForKey:@"use"])
            {
                nextPerson.loan.use_string = [loan objectForKey:@"use"];
                 [self logKindOfClass:[loan objectForKey: @"use"] withName:@"use"];
            }
        
        
        
        // заполняем entity - Location
          nextPerson.location = [NSEntityDescription insertNewObjectForEntityForName:@"Location" inManagedObjectContext:context];
        NSDictionary* tempLocationDict = [loan objectForKey:@"location"];
        
        if (tempLocationDict && [tempLocationDict isKindOfClass:[NSDictionary class]]) // если location есть и это словарь, то
        {
            if ([tempLocationDict objectForKey:@"country"])
            {
                nextPerson.location.country = [tempLocationDict objectForKey:@"country"];
                [self logKindOfClass:[tempLocationDict objectForKey: @"country"] withName:@"country"];
                
            }
            if ([tempLocationDict objectForKey:@"town"])
            {
                nextPerson.location.town = [tempLocationDict objectForKey:@"town"];
                [self logKindOfClass:[tempLocationDict objectForKey: @"town"] withName:@"town"];
            }
           
            NSDictionary* tempGeoDict = [tempLocationDict objectForKey:@"geo"];
            
            if (tempGeoDict && [tempGeoDict isKindOfClass:[NSDictionary class]]) // парсим более глубокий словарь - Geo
            {
                if ([tempGeoDict objectForKey:@"pairs"])
                {
                    nextPerson.location.geo = [tempGeoDict objectForKey:@"pairs"];
                    [self logKindOfClass:[tempGeoDict objectForKey: @"pairs"] withName:@"pairs"];
                }
            }
                
                
        }
        [_appDelegate saveContext];
    }
    
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:KRNCoreDataFilled] == nil)
        [[NSUserDefaults standardUserDefaults] setObject:@YES forKey:KRNCoreDataFilled]; // заполняем NSUserDefaults
    
 

}

- (void) fetchRequestForPersons:(void(^) (NSArray <Person*> *fetchedRes)) block

// fetch request
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName:@"Person"]; // создаем запрос
    
    NSError* error;
    
    _fetchedResults = [[_appDelegate managedObjectContext] executeFetchRequest:request error:&error]; // исполнить fetch Request
    
    
    

    if (error)
        NSLog(@"%@", error.localizedDescription);
    else
    {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        _fetchedResults = [_fetchedResults sortedArrayUsingDescriptors:@[sort]];
        
     
        
        block(_fetchedResults); // выполняем блок, если запрос найден
        
    }
    
    
    
}

-(void) deleteAllFromCoreData // удалить все из Core Data
{
    [self fetchRequestForPersons:^(NSArray<Person *> *fetchedRes)
    {

            for (Person* anyPerson in fetchedRes)
            {
                [[_appDelegate managedObjectContext] deleteObject:anyPerson];
                 [_appDelegate saveContext];
            }
        
        
        
        
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                [self.tableView reloadData];
              
                
            });
       
    }];

}


-(void) logKindOfClass:(id)object withName:(NSString*)name
{
    NSString *tempClassName = nil;
    
    if ([object isKindOfClass:[NSArray class]])
        tempClassName = @"NSArray";
    else if ([object isKindOfClass:[NSDictionary class]])
        tempClassName = @"NSDictionary";
    else if ([object isKindOfClass:[NSString class]])
        tempClassName = @"NSString";
    else if ([object isKindOfClass:[NSNumber class]])
        tempClassName = @"NSNumber";
    else if ([object isKindOfClass:[NSDate class]])
        tempClassName = @"NSDate";
    
    NSLog(@"%@ is kind of class %@", name, tempClassName);
    
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

   // return _loans.count;
    return _fetchedResults.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
   
    cell.textLabel.text = [_fetchedResults[indexPath.row] name];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _selectedRow = indexPath.row;
    
    [self performSegueWithIdentifier:@"detailPush" sender:self];
}




#pragma mark - Navigation




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"detailPush"])
    {
        ViewController* destVC = [segue destinationViewController];
        
        destVC.currentPerson = [_fetchedResults objectAtIndex:_selectedRow];
        
    }

}


- (IBAction)reloadAction:(id)sender // кнопка - перезагрузить запрос
{
    _reloadButton.enabled = NO;
    _activityIndicator.hidden = NO;
    [_myRequest stopRequest];
    [_myRequest makeRequest];
    
    
 // [self deleteAllFromCoreData];
    _reload = YES;
}
@end
