//
//  CurrentTrackViewController.h
//  ScoutsterGPS
//
//  Created by Ben Ellingson on 8/27/10.
//  Copyright 2010 Northstar New Media. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <MapKit/MapKit.h>

@interface CurrentTrackViewController : UIViewController {

	IBOutlet MKMapView *map;
}

@property (retain, nonatomic) IBOutlet MKMapView *map;

@end
