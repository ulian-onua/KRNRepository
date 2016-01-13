//
//  Location+CoreDataProperties.h
//  LoanDate
//
//  Created by Drapaylo Yulian on 05.12.15.
//  Copyright © 2015 Administrator. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Location.h"

NS_ASSUME_NONNULL_BEGIN

@interface Location (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *country;
@property (nullable, nonatomic, retain) NSString *geo;
@property (nullable, nonatomic, retain) NSString *town;
@property (nullable, nonatomic, retain) NSSet<Person *> *persons;

@end

@interface Location (CoreDataGeneratedAccessors)

- (void)addPersonsObject:(Person *)value;
- (void)removePersonsObject:(Person *)value;
- (void)addPersons:(NSSet<Person *> *)values;
- (void)removePersons:(NSSet<Person *> *)values;

@end

NS_ASSUME_NONNULL_END
