//
//  GPSPoint.m
//  ScoutsterGPS
//
//  Created by Ben Ellingson on 8/20/10.
//  Copyright 2010 Northstar New Media. All rights reserved.
//

#import "GPXSample.h"


@implementation GPXSample

@synthesize elevation, time, point, coordinate; 

- (void) dealloc
{
	[time release];
	[super dealloc];
}


@end
