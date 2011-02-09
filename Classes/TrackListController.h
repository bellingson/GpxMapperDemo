//
//  TrackListController.h
//  ScoutsterGPS
//
//  Created by Ben Ellingson on 8/27/10.
//  Copyright 2010 Northstar New Media. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EntityManager.h"
#import "Track.h"

@interface TrackListController : UITableViewController {

	
	NSArray *rowData;
	
	NSDateFormatter *dateFormat;
	
}

@property (retain, nonatomic) NSArray *rowData;
@property (retain, nonatomic) NSDateFormatter *dateFormat;

@end
