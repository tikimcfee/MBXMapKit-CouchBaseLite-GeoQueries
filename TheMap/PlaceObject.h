//
//  MyPoint.h
//  TheMap
//
//  Created by Ivan Lugo on 1/22/14.
//  Copyright (c) 2014 Ivan Lugo. All rights reserved.
//

#ifndef TheMap_MyPoint_h
#define TheMap_MyPoint_h
#endif
#import <MapKit/MapKit.h>
#import "MyPoint.h"


// Trying to make PlaceObject an MKOverlay.. dunno if it will work
@interface PlaceObject:NSObject
{
    NSMutableArray *myPoints;
}

- (id) init;
- (void) addCLPointToPlace:(CLLocationCoordinate2D) bound;
- (void) addBoundPointToPlace:(MyPoint*) bound;
- (NSInteger) getCount;
- (CLLocationCoordinate2D*) getLocationBounds;
- (MKPolygon *) getPolygonRepresentation;



@end