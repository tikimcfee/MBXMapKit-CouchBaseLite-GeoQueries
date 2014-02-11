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
#import "MBXMapKit.h"
#import "MyPoint.h"

@interface PlaceObject: MKPolygon <MKMapViewDelegate>
{
    NSMutableArray *bound_points;
    NSData *place_properties;
    MBXMapView *placeMapView;
    
    UIColor *bound_color;
    UIColor *fill_color;
    double bound_line_width;
    
    CLLocationCoordinate2D *placeBounds;
}

- (id) init;
- (void) setMapView:(MBXMapView *) mapView;
- (void) addCLPointToPlace:(CLLocationCoordinate2D) bound;
- (void) addBoundPointToPlace:(MyPoint*) bound;
- (void) setBoundColor:(UIColor *) color;
- (void) setBoundWidth:(double) width;
- (void) setFillColor:(UIColor*) color;
- (UIColor*) getFillColor;
- (UIColor*) getBoundColor;
- (double) getWidth;

- (NSInteger) getCount;
- (CLLocationCoordinate2D*) getLocationBounds;

- (void) drawSelfToScreen;
- (MKPolygon *) getPolygonRepresentation;
- (MKOverlayRenderer *) mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay;

@end