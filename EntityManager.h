//
//  DataService.h
//  uber
//
//  Created by Ben Ellingson  - http://benellingson.blogspot.com/ on 3/23/10.
//  Copyright 2010 No Fluff Just Stuff. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <CoreData/CoreData.h>


@interface EntityManager : NSObject {

    NSManagedObjectContext *managedObjectContext;	    
	
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

+ (EntityManager *) instance;

- (NSArray*) query: (NSString *) entityName criteria: (NSString *) crit sort: (NSString *) sort;
- (NSArray*) query: (NSString *) entityName criteria: (NSString *) crit sort: (NSString *) sort ascending: (BOOL) asc;
- (NSArray*) query: (NSString *) entityName predicate: (NSPredicate *) predicate sort: (NSString *) sort ascending: (BOOL) asc;
- (id) get: (NSString *) entityName ID: (NSInteger *) ID;
- (id) get: (NSString *) entityName criteria: (NSString *) crit;

- (id) createOrUpdateEntity: (NSString *) entityName ID: (NSInteger *) ID;
- (id) createEntity: (NSString *) entityName;
- (BOOL) save;
- (void) delete: (id) entity;
- (void) deleteItems: (NSArray *) entities;

- (NSFetchedResultsController *)fetchedResultsController : (NSString *) entityName sort: (NSString *) sortKey;




@end


