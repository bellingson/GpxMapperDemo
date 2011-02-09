//
//  GPXParser.h
//  ScoutsterGPS
//
//  Created by Ben Ellingson on 8/26/10.
//  Copyright 2010 Northstar New Media. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "GPXSample.h"

@protocol GPXParserDelegate

- (void) handlePoint: (GPXSample *) point;

@end


@interface GPXParser : NSObject <NSXMLParserDelegate> {
	
	GPXSample *currentSample;
	NSMutableString *currentParsedCharacterData;
	BOOL accumulatingParsedCharacterData;
	
	NSDateFormatter *dateFormatter;
	
	id delegate;
	
	NSMutableArray *samples;
	
}

@property (retain, nonatomic) GPXSample *currentSample;
@property (retain, nonatomic) NSMutableArray *samples;

@property (retain, nonatomic) NSMutableString *currentParsedCharacterData;

@property BOOL accumulatingParsedCharacterData;

@property (retain, nonatomic) NSDateFormatter *dateFormatter;
@property (retain, nonatomic) id delegate;

- (void) parse: (NSString *) filePath;
- (CLLocationCoordinate2D *) coords;


@end
