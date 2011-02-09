//
//  GPXDataManager.h
//  ScoutsterGPS
//
//  Created by Ben Ellingson on 8/27/10.
//  Copyright 2010 Northstar New Media. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "EntityManager.h"
#import "Track.h"

@interface GPXDataManager : NSObject {

	
	NSString *dirPath;
	
	EntityManager *entityManager;
	
}

@property (retain, nonatomic) NSString *dirPath;
@property (retain, nonatomic) EntityManager *entityManager;

- (id) initWithDirectory: (NSString *) docDir;

- (void) readGPXFiles;
- (void) initSample;


@end
