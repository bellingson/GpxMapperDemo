//
//  GPSPoint.h
//  ScoutsterGPS
//
//  Created by Ben Ellingson on 8/20/10.
//  Copyright 2010 Northstar New Media. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

@interface GPXSample : NSObject {

	MKMapPoint point;
	CLLocationCoordinate2D coordinate;
	
	double elevation;
	NSDate *time;
	
}

@property CLLocationCoordinate2D coordinate;
@property MKMapPoint point;
@property double elevation;
@property (retain, nonatomic) NSDate *time;


@end
