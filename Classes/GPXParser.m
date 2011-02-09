//
//  GPXParser.m
//  ScoutsterGPS
//
//  Created by Ben Ellingson on 8/26/10.
//  Copyright 2010 Northstar New Media. All rights reserved.
//

#import "GPXParser.h"


@implementation GPXParser

@synthesize currentSample, currentParsedCharacterData, accumulatingParsedCharacterData, dateFormatter, delegate, samples;

#pragma mark -
#pragma mark Data Methods

- (CLLocationCoordinate2D *) coords {

	int count = [samples count];
	CLLocationCoordinate2D *coords = malloc(sizeof(CLLocationCoordinate2D) * count);
	
	int x = 0;
	
	for (GPXSample *sample in samples) {
		coords[x++] = sample.coordinate;
	}
	
	//NSLog(@"coords: %d",count);
	
	return coords;
}


#pragma mark Parser Constants

static NSString * const kPointElementName = @"trkpt";
static NSString * const kLatAttrName = @"lat";
static NSString * const kLonAttrName = @"lon";
static NSString * const kEleElementName = @"ele";
static NSString * const kTimeElementName = @"time";

#pragma mark Parser Methods

- (id) init
{
	self = [super init];
	if (self != nil) {
		self.samples = [[NSMutableArray alloc] init];
		self.currentParsedCharacterData = [[NSMutableString alloc] init];
		self.dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
		[dateFormatter setTimeZone: [NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
	}
	return self;
}

- (void) parse: (NSString *) filePath {
	
	NSData *data = [NSData dataWithContentsOfFile: filePath];
	
	NSXMLParser *parser = [[NSXMLParser alloc] initWithData: data];
	parser.delegate = self;
	[parser parse];
	
	
}

- (void) parserDidStartDocument:(NSXMLParser *)parser {
	
	NSLog(@"parser did start doc");
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
	
	//NSLog(@"did start element: %@",elementName);
	
	if ([elementName isEqualToString:kPointElementName]) {
		
		GPXSample *sample = [[GPXSample alloc] init];
		[self.samples addObject:sample];
		
		sample.coordinate = (CLLocationCoordinate2D) { [[attributeDict valueForKey:kLatAttrName] doubleValue], 
									  [[attributeDict valueForKey:kLonAttrName] doubleValue] };		
		
		self.currentSample = sample;
		
	} else if ([elementName isEqualToString: kEleElementName] ||
			   [elementName isEqualToString: kTimeElementName]) {
		accumulatingParsedCharacterData = YES;
		
		[currentParsedCharacterData setString:@""];
		
		//NSLog(@"init CDATA: %@",currentParsedCharacterData);
		
	} else {
		accumulatingParsedCharacterData = NO;
	}
	
	
	
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
	
	//NSLog(@"did end element: %@",elementName);
	
	if ([elementName isEqualToString:kPointElementName]) {
		// handle end of point	
		
		GPXSample *point = self.currentSample;
		

		
		[self.delegate handlePoint:point];
		
		
		[point release];
		
	} else if ([elementName isEqualToString:kEleElementName]) {
		// hanle elevation
		
	//	NSLog(@"ele: %@",self.currentParsedCharacterData);
		
		self.currentSample.elevation = [self.currentParsedCharacterData doubleValue];
		
		
		
	} else if([elementName isEqualToString:kTimeElementName]) {
		// handle time

		self.currentSample.time = [dateFormatter dateFromString:self.currentParsedCharacterData];
		
		//NSLog(@"set time: %@ R: %@",self.currentParsedCharacterData,[dateFormatter dateFromString:self.currentParsedCharacterData]);
		
	}
	
	
	
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	
    if (accumulatingParsedCharacterData) {
		
        // If the current element is one whose content we care about, append 'string'
        // to the property that holds the content of the current element.
        //
        [self.currentParsedCharacterData appendString:string];
		
		//NSLog(@"found char: %@ NOW: %@",string,self.currentParsedCharacterData);
    }
}



- (void) parserDidEndDocument:(NSXMLParser *)parser {
	NSLog(@"parser did end doc");
}

#pragma mark -
#pragma mark Memory Methods

- (void) dealloc
{
	[currentSample release];
	[delegate release];
	[dateFormatter release];
	[currentParsedCharacterData release];
	[super dealloc];
}



@end
