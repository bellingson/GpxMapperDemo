//
//  ScoutsterGPSViewController.m
//  ScoutsterGPS
//
//  Created by Ben Ellingson on 8/11/10.
//  Copyright Northstar New Media 2010. All rights reserved.
//

#import "TrackViewController.h"

#import "GPXParser.h"

@implementation TrackViewController

@synthesize map, track;


- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSLog(@"Track Path: %@",track.filePath);
	 
	//NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data" ofType:@"GPX"];
	
	GPXParser *parser = [[GPXParser alloc] init];
	parser.delegate = self;
	[parser	parse: track.filePath];
	
	CLLocationCoordinate2D *coords = [parser coords];
	
	MKPolyline *polyline = [MKPolyline polylineWithCoordinates:coords count:[parser.samples count]];
	
	map.visibleMapRect = [polyline boundingMapRect];
	map.mapType = MKMapTypeHybrid;
	
	[map addOverlay: polyline];
		
	free(coords);
	
}

#pragma mark -
#pragma mark MKMapViewDelegate methods

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay {

	//NSLog(@"view for overlay: %@",overlay);
	
	if ([overlay isKindOfClass:[MKPolyline class]]) {
		MKPolylineView *view = [[MKPolylineView alloc] initWithOverlay:overlay];
		view.strokeColor = [[UIColor purpleColor] colorWithAlphaComponent:0.5];
		view.lineWidth = 4;
		return [view autorelease];
	}
	
	
	return nil;
}


- (void) handlePoint: (GPXSample *) point {
		
	//NSLog(@"lat: %f lon: %f time: %@ ele: %f ",point.latitude,point.longitude,point.time,point.elevation);
	//NSLog(@"handle point: %@",point.time);
	
}

- (void)mapViewDidFailLoadingMap:(MKMapView *)mapView withError:(NSError *)error {

	NSLog(@"failed to load map: %@",[error userInfo]);
	
}

#pragma mark -
#pragma mark Memory Issues

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
