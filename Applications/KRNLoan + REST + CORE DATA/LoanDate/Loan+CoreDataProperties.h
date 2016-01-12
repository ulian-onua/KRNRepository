//
//  Loan+CoreDataProperties.h
//  LoanDate
//
//  Created by Drapaylo Yulian on 05.12.15.
//  Copyright © 2015 Administrator. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Loan.h"

NS_ASSUME_NONNULL_BEGIN

@interface Loan (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *date;
@property (nullable, nonatomic, retain) NSNumber *loanId;
@property (nullable, nonatomic, retain) NSNumber *loan_amount;
@property (nullable, nonatomic, retain) NSNumber *raise;
@property (nullable, nonatomic, retain) NSString *use_string;
@property (nullable, nonatomic, retain) Person *person;

@end

NS_ASSUME_NONNULL_END
