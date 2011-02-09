//
//  ScoutsterGPSViewController.h
//  ScoutsterGPS
//
//  Created by Ben Ellingson on 8/11/10.
//  Copyright Northstar New Media 2010. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>

#import "Track.h"

@interface TrackViewController : UIViewController<MKMapViewDelegate>  {

	Track *track;
	
	IBOutlet MKMapView *map;
	
}

@property (retain, nonatomic) Track *track;
@property (retain, nonatomic) IBOutlet MKMapView *map;

@end

