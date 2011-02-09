//
//  Track.h
//  ScoutsterGPS
//
//  Created by Ben Ellingson on 8/27/10.
//  Copyright 2010 Northstar New Media. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface Track :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * ID;
@property (nonatomic, retain) NSNumber * elevationChange;
@property (nonatomic, retain) NSNumber * distance;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSNumber * sampleCount;
@property (nonatomic, retain) NSString * filePath;
@property (nonatomic, retain) NSString * name;

@end



