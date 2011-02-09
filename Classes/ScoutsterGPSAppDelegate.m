//
//  ScoutsterGPSAppDelegate.m
//  ScoutsterGPS
//
//  Created by Ben Ellingson on 8/11/10.
//  Copyright Northstar New Media 2010. All rights reserved.
//

#import "ScoutsterGPSAppDelegate.h"
#import "TrackViewController.h"

#import "GPXDataManager.h"
#import "EntityManager.h"


@implementation ScoutsterGPSAppDelegate

@synthesize window;
@synthesize navController;
@synthesize viewController;
@synthesize tabBar;


- (id) init
{
	self = [super init];
	if (self != nil) {
		
		EntityManager *em = EntityManager.instance;
		em.managedObjectContext = [self managedObjectContext];
		
		GPXDataManager *gpxDataManager = [[GPXDataManager alloc] initWithDirectory: [self applicationDocumentsDirectory]];
		
	}
	return self;
}




#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after application launch.
	
	NSLog(@"dir: %@",[self applicationDocumentsDirectory]);
	

    // Add the view controller's view to the window and display.
    //[window addSubview:viewController.view];
	//[window addSubview: navController.view];
	[window addSubview:tabBar.view];
    [window makeKeyAndVisible];

    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
     */
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of  transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     See also applicationDidEnterBackground:.
     */
}

- (NSString *)applicationDocumentsDirectory {
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

#pragma mark -
#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *) managedObjectContext {
	
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
	
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created by merging all of the models found in the application bundle.
 */
- (NSManagedObjectModel *)managedObjectModel {
	
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];    
	
    return managedObjectModel;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 
 Conditionalize for the current platform, or override in the platform-specific subclass if appropriate.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
	
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
	
	NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent: @"ScountsterGPS.sqlite"];
    NSURL *storeUrl = [NSURL fileURLWithPath: storePath];
	
	NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error]) {
		
		NSLog(@"error code: %d",error.code);
		
		// incompatible dbs... just replace it
		if (error.code == 134100) {
			if([self replaceOldDb: storePath storeUrl: storeUrl psc: persistentStoreCoordinator]) {
				return persistentStoreCoordinator;
			}
		}
		
		NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
		abort();
		
	}    
	
    return persistentStoreCoordinator;
}

- (BOOL) replaceOldDb: (NSString *) storePath storeUrl: (NSURL *) storeUrl psc: (NSPersistentStoreCoordinator *) persistentStoreCoordinator {
	
	NSLog(@"replacing old data store");
	
	NSFileManager *nfm = [NSFileManager defaultManager];
	if ([nfm fileExistsAtPath: storePath]) {
		NSError *error2 = nil;
		[nfm removeItemAtPath:storePath error:&error2];
		if (error2 != nil) {
			NSLog(@"could not remove old data store: %@",[error2 userInfo]);
		} else {
			// try to recover
			NSError *error = nil;
			[persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeUrl options:nil error:&error];
			if (error == nil) {
				return YES;
			}
		}
		
	}
	return NO;
	
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
