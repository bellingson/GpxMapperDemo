//
//  ScoutsterGPSAppDelegate.h
//  ScoutsterGPS
//
//  Created by Ben Ellingson on 8/11/10.
//  Copyright Northstar New Media 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>

@class TrackViewController;

@interface ScoutsterGPSAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TrackViewController *viewController;
	
	IBOutlet UINavigationController *navController;
	IBOutlet UITabBarController *tabBar;
	
	
	NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;	    
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
	
	
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navController;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBar;


@property (nonatomic, retain) IBOutlet TrackViewController *viewController;

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;


- (NSString *)applicationDocumentsDirectory;

@end

