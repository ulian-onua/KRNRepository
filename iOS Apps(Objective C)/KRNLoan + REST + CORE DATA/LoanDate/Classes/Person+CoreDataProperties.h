//
//  Person+CoreDataProperties.h
//  LoanDate
//
//  Created by Drapaylo Yulian on 05.12.15.
//  Copyright © 2015 Administrator. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Person.h"

NS_ASSUME_NONNULL_BEGIN

@interface Person (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *activity_string;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) Loan *loan;
@property (nullable, nonatomic, retain) Location *location;

@end

NS_ASSUME_NONNULL_END
