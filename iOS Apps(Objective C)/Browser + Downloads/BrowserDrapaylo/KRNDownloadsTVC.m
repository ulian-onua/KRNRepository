//
//  KRNDownloadsTVC.m
//  BrowserDrapaylo
//
//  Created by Drapaylo Yulian on 24.05.16.
//  Copyright © 2016 Drapaylo Yulian. All rights reserved.
//

#import "KRNDownloadsTVC.h"


@interface KRNDownloadsTVC()
{
    NSInteger _lastRowSelected;
    dispatch_source_t directoryDispatchSource; // соурс для отслеживания изменения файлов в директории
    
    NSArray <KRNDownloadTask*> *_filteredTasks; // отфильтрованные таски
    
    NSArray <NSValue *> *_rangesWithFoundValues; // диапазоны с найденными вхождения подстроки

    
}

@end

@implementation KRNDownloadsTVC


-(void)viewDidLoad
{
    _appDelegate = [[UIApplication sharedApplication]delegate]; // получаем делегат
    

    
    NSString* documentsDirPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    documentsDirPath = [documentsDirPath stringByAppendingString:@"/"];
    
    int fileDescriptor = open([documentsDirPath UTF8String], O_EVTONLY);
    
    
    directoryDispatchSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_VNODE, fileDescriptor, DISPATCH_VNODE_WRITE | DISPATCH_VNODE_DELETE | DISPATCH_VNODE_RENAME, dispatch_get_main_queue()); // создаем source
    
    dispatch_source_set_event_handler(directoryDispatchSource, ^{
    
        unsigned long data = dispatch_source_get_data(directoryDispatchSource);
        
        if (data == DISPATCH_VNODE_WRITE)
        {
            // проверяем на наличие удаленных или переименнованных файлов и удаляем их из числа задач
            NSArray<NSNumber*> *deletedTasksNums = [_appDelegate.taskManager checkTasksForRemovedFile];
            if (deletedTasksNums)
            {
                for (NSNumber* num in deletedTasksNums)
                {
                [_appDelegate.taskManager removeTask:[_appDelegate.taskManager.tasks objectAtIndex:num.integerValue]  AndFromFileSystem:YES];
                     
                }
             
            }
            
            
            
            // проверяем на наличие новых файлов и добавляем их в задачи
            
            [_appDelegate.taskManager addNewTasksFromDocumentsDirectory];
            
            [self.tableView reloadData]; // перезагружаем таблицу
            
        }

        
        
    });
    
    dispatch_resume(directoryDispatchSource);
    
    // инициализируем Search Controller
    
    _searchController = [[ODSSearchController alloc] initWithSearchResultsController:nil andDelegate:self];
    
    
    self.tableView.tableHeaderView = _searchController.searchBar;
    
    self.definesPresentationContext = YES;
    
}




-(void) viewWillAppear:(BOOL)animated
{
    [self.tableView reloadData];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
    NSString *cleanString = [self.searchController cleanSearchString];
    
    //Начинаем искать совпаденя в ключах
    
    
    NSMutableArray <KRNDownloadTask*> *sortedArray = [NSMutableArray new]; // сортированный массив  строк, по которым будем искать
    NSMutableArray <NSValue*> *rangesWithValues = [NSMutableArray new]; // диапазон, с найденными значениями
    
    //сравниваем строку поиска (cleanString) с каждой строкой из массива
    for (int i = 0; i < _appDelegate.taskManager.tasks.count; i++)
    {
        // получаем очередную строку из массива
        NSString* temStr = [_appDelegate.taskManager.tasks[i].name uppercaseString];
        
        // проверяем всю строку на совпадение
        
        NSRange foundedSubstrRange;
        
        foundedSubstrRange = [temStr rangeOfString:cleanString options:NSCaseInsensitiveSearch];
        
        if (foundedSubstrRange.location != NSNotFound)
        {
            [sortedArray addObject:_appDelegate.taskManager.tasks[i]]; // добавляем найденный объект
            [rangesWithValues addObject:[NSValue valueWithRange:foundedSubstrRange]]; // добавляем найденный диапазон подстроки
            continue;
            
        }
        
        
//        if ([temStr hasPrefix:[cleanString uppercaseString]])
//        {
//            [sortedArray addObject:_appDelegate.taskManager.tasks[i]];
//            continue; // если строка найдена, то добавляем ее и продолжаем цикл сначала
//            
//        }
        

        
        
    }
    
    _filteredTasks = [NSArray arrayWithArray:sortedArray];; // присваиваем свойству предка
    _rangesWithFoundValues = [NSArray arrayWithArray:rangesWithValues]; // обновляем массив с найденными значенияи
    
    [self.tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  //  return _appDelegate.taskManager.tasks.count; // количество задач в таблице
    
    if (_appDelegate.taskManager.tasks != nil || _filteredTasks != nil)
    {
        
        return (![_searchController isSearching]) ? _appDelegate.taskManager.tasks.count : _filteredTasks.count;
    }
    else
        return 0;
}





- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KRNDownloadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DownloadCell"];
    
 //   KRNDownloadTask* currentTask = _appDelegate.taskManager.tasks[indexPath.row];
    
    KRNDownloadTask* currentTask;
    
   
    if ([self.searchController isSearching]) {
        currentTask = [_filteredTasks objectAtIndex:indexPath.row];
    }  else
    {
        currentTask = [_appDelegate.taskManager.tasks objectAtIndex:indexPath.row];
    }
    
    
    [cell setName:currentTask.name andStatus:[self convertDownloadStatusToVisibleStatus:currentTask.downloadStatus]];
    
    if ([self.searchController isSearching])
    {
        [cell highlightPartOfNameWithRange:_rangesWithFoundValues[indexPath.row].rangeValue];
    }
    
    currentTask.delegate = cell;
    
    return cell;

}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        KRNDownloadTask* currentTask = _appDelegate.taskManager.tasks[indexPath.row]; //  получаем задачу, которую нужно удалить
        [_appDelegate.taskManager removeTask:currentTask AndFromFileSystem:YES];
        [self.tableView reloadData];
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    _lastRowSelected = indexPath.row;
    
    KRNDownloadTask* currentTask = _appDelegate.taskManager.tasks[indexPath.row];
    
    if (currentTask.downloadStatus == KRNDownloadStatusFinished || currentTask.downloadStatus == KRNDownloadStatusLoadFromFile)
    {
        if (currentTask.downloadFileType == KRNDownloadFileTypeImage)
            [self performSegueWithIdentifier:@"showImageSegue" sender:self];
        else if (currentTask.downloadFileType == KRNDownloadFileTypeTXT)
            [self performSegueWithIdentifier:@"showTextSegue" sender:self];
        else if (currentTask.downloadFileType == KRNDownloadFileTypePDF)
        {
            [self performSegueWithIdentifier:@"showPDFSegue" sender:self];
        }
    }
}

-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
         KRNDownloadTask* currentTask = _appDelegate.taskManager.tasks[_lastRowSelected];
    
    
    // реализовать сегвей - показать изображение
    if ([segue.identifier isEqualToString:@"showImageSegue"])
    {
        KRNShowImageVC *destVC = segue.destinationViewController;
        destVC.imagePath = [currentTask.filePath copy];
    }
    
    else if ([segue.identifier isEqualToString:@"showTextSegue"])
    {
        KRNShowTextVC *showTextVC = segue.destinationViewController;
        showTextVC.filePath = [currentTask.filePath copy];
    }
    else if ([segue.identifier isEqualToString:@"showPDFSegue"])
    {
        KRNWebViewController *webViewController = segue.destinationViewController;
        webViewController.filePath = [currentTask.filePath copy];
    }
    
}



-(KRNVisibleStatus) convertDownloadStatusToVisibleStatus:(KRNDownloadStatus)downloadStatus
{
    switch (downloadStatus) {
        case KRNDownloadStatusInitialized:
            return KRNVisibleStatusInitialized;
            break;
        case KRNDownloadStatusPending:
            return KRNVisibleStatusPending;
            break;
        case KRNDownloadStatusDownloading:
            return KRNVisibleStatusDownloading;
            break;
        case KRNDownloadStatusFinished:
        case KRNDownloadStatusLoadFromFile:
            return KRNVisibleStatusFinished;
            break;
        default:
            return KRNVisibleStatusInterrupted;
            break;
    }

    
    return 0;
}

@end
