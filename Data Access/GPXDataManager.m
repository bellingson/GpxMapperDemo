//
//  GPXDataManager.m
//  ScoutsterGPS
//
//  Created by Ben Ellingson on 8/27/10.
//  Copyright 2010 Northstar New Media. All rights reserved.
//

#import "GPXDataManager.h"



@implementation GPXDataManager

@synthesize dirPath, entityManager;

- (id) initWithDirectory: (NSString *) docDir
{
	self = [super init];
	if (self != nil) {
		self.dirPath = docDir;
		self.entityManager = EntityManager.instance;
		[self initSample];
		[self readGPXFiles];
	}
	return self;
}


- (void) readGPXFiles {
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	NSError *error = nil;
	NSArray *files = [fileManager contentsOfDirectoryAtPath:dirPath error: &error];
	
	if (error) {
		NSLog(@"READ GPX ERROR: %@",[error userInfo]);
		return;
	}
	
	for (NSString *fileName in files) {
		if ([fileName rangeOfString:@".GPX"].location == NSNotFound) {
			continue;
		}
		NSLog(@"file: %@",fileName);
		[self inspectGPXFile:fileName dir: dirPath];
	}		
	
}

- (void) inspectGPXFile: (NSString *) fileName dir: (NSString *) dir {
	
	NSString *crit = [NSString stringWithFormat:@"name = '%@'",fileName];
	Track *track = [entityManager get: @"Track" criteria:crit];
	
	NSLog(@"track find: %@",track.name);
	
	if (track == nil) {
		track = [entityManager createEntity:@"Track"];
		track.ID = @"1";  // HACK
		track.name = fileName;
		track.filePath = [NSString stringWithFormat:@"%@/%@",dir,fileName];
		track.date = [[NSDate alloc] init];
		
		[entityManager save];
		
	}
	
}

- (void) initSample {
	
	NSString *samplePath = [NSString stringWithFormat: @"%@/data.GPX",dirPath];
	
	NSFileManager *fileManager = [NSFileManager defaultManager];
	
	BOOL exists = [fileManager fileExistsAtPath: samplePath];
	
	// NSLog(@"sample: %@ : %d",samplePath,exists);
	
	if (exists == NO) {
		NSString *bundleSample = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"GPX"];
		NSError *error;
		[fileManager copyItemAtPath:bundleSample toPath:samplePath error: &error];
		if (error) {
			NSLog(@"SAMPLE FILE ERROR: %@",[error userInfo]);
		}
	}
}

- (void) dealloc
{
	[dirPath release];
	[entityManager release];
	[super dealloc];
}




@end
