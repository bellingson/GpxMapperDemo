//
//  DataService.m
//  uber
//
//  Created by Ben Ellingson  - http://benellingson.blogspot.com/ on 3/23/10.
//  Copyright 2010 No Fluff Just Stuff. All rights reserved.
//

#import "EntityManager.h"


@implementation EntityManager

@synthesize managedObjectContext;

static EntityManager *instance;


#pragma mark Entity Management

- (NSArray*) query: (NSString *) entityName criteria: (NSString *) crit sort: (NSString *) sort  {
	return [self query: entityName criteria:crit sort:sort ascending: YES];
}

- (NSArray*) query: (NSString *) entityName criteria: (NSString *) crit sort: (NSString *) sort ascending: (BOOL) asc {
	
	NSPredicate *pred = nil;
	if (crit != nil) {
		pred = [NSPredicate predicateWithFormat: crit];
	}
	return [self query: entityName predicate: pred sort: sort ascending: asc];
}

- (NSArray*) query: (NSString *) entityName predicate: (NSPredicate *) predicate sort: (NSString *) sort ascending: (BOOL) asc {
	
	if (sort == nil) {
		sort = @"ID";
		//sort = @"objectID";
	}
	
	NSFetchedResultsController *frc = [self fetchedResultsController:entityName sort: sort ascending: asc ];
	
	NSFetchRequest *fetchRequest = frc.fetchRequest;
	
	if (predicate != nil) {
		[fetchRequest setPredicate:predicate];
	}
	
	//NSLog(@"perform fetch %@ ",entityName);
	
	NSError *error = nil;
	if(![frc performFetch:&error]) {
		NSLog(@"error: %@",[error userInfo]);
	}
	
	NSArray *entities = [frc fetchedObjects];
	
	return entities;
}


- (id) get: (NSString *) entityName criteria: (NSString *) crit {
	
	NSArray *entities = [self query: entityName criteria: crit sort: nil];

	NSUInteger cnt = [entities count];
	
	if(cnt <= 0) {
		return nil;
	}	 
	
	id *r = [entities objectAtIndex:0];

	
	return r;	
	
}

- (id) get: (NSString *) entityName ID: (NSString *) ID {
	

	NSString *criteria = [NSString stringWithFormat:@"ID = %@",ID];
	
	NSArray *entities = [self query: entityName criteria: criteria sort: nil];
  
	NSUInteger cnt = [entities count];
	
	//NSLog(@"fetch %@ count: %d",entityName,cnt);
	
	if(cnt <= 0) {
		//NSLog(@"nothing found: %@ : %@",entityName,ID);
		return nil;
	}	 
	
	id *r = [entities objectAtIndex:0];
	
	//NSLog(@"select entity: %@",r);
	
	return r;	
}


- (NSFetchedResultsController *)fetchedResultsController : (NSString *) entityName sort: (NSString *) sortKey ascending: (BOOL) asc {
	
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	
	NSEntityDescription *entity = [NSEntityDescription entityForName: entityName inManagedObjectContext: managedObjectContext];
	
	[fetchRequest setEntity:entity];
		
	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] 
										initWithKey:sortKey ascending:asc];
	[fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
	
	
	NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest 
										managedObjectContext:managedObjectContext
										  sectionNameKeyPath:nil
												   cacheName:nil];
	[sortDescriptor release];
	[fetchRequest release];
	
	return frc;
}    

- (id) createEntity: (NSString *) entityName {
	
	NSFetchedResultsController *frc = [self fetchedResultsController: entityName sort: @"ID" ascending: YES];
	NSEntityDescription *entity = [frc.fetchRequest entity];
	return [NSEntityDescription insertNewObjectForEntityForName:[entity name] inManagedObjectContext: managedObjectContext];
}

- (id) createOrUpdateEntity: (NSString *) entityName ID: (NSString *) ID {
	
	id *entity = [self get:entityName ID:ID];
	
	if(entity == nil) {
		entity = [self createEntity:entityName];
		[entity setID: ID];
	}
	return entity;	
}

- (BOOL) save {
	
	NSError *error = nil;
	if(![managedObjectContext save: &error]) {
		NSLog(@"save error: %@",[error userInfo]);
	}
}

- (void) delete: (id) entity {
	[managedObjectContext deleteObject: entity];
	NSError *error = nil;
	[managedObjectContext save:&error];
	if (error != nil) {
		NSLog(@"ERROR: %@",[error userInfo]);
	}
}

- (void) deleteItems: (NSArray *) entities {
	
	if (entities == nil || [entities count] == 0) {
		return;
	}

	for (id item in entities) {
		[managedObjectContext deleteObject: item];
	}
	NSError *error = nil;
	[managedObjectContext save:&error];
	if (error != nil) {
		NSLog(@"ERROR: %@",[error userInfo]);
	}
}

+ (EntityManager *) instance {
	
	if(instance == nil) {
		//NSLog(@"init dataservice");
		instance = [EntityManager new];
	}

	return instance;
}

- (void) dealloc
{
	[managedObjectContext release];
	[super dealloc];
}


@end


