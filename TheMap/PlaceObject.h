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

@interface PlaceObject: CBLModel <MKMapViewDelegate>
{
    NSMutableArray *bound_points;
    MBXMapView *placeMapView;
    
    UIColor *bound_color;
    UIColor *fill_color;
    UIColor *default_fill;
    double bound_line_width;
    
    CLLocationCoordinate2D *placeBounds;
    
    NSDictionary *place_data;
    NSData *place_properties;
    
    MKPolygon *my_polygon;
}

- (id) init;
- (void) setMapView:(MBXMapView *) mapView;
- (void) addCLPointToPlace:(CLLocationCoordinate2D) bound;
- (void) addBoundPointToPlace:(MyPoint*) bound;
- (void) setBoundColor:(UIColor *) color;
- (void) setBoundWidth:(double) width;
- (void) setFillColor:(UIColor*) color;
- (void) setPlaceData:(NSDictionary*) description;
- (void) setPolygon:toThis;
- (UIColor*) getFillColor;
- (UIColor*) getDefaultFill;
- (UIColor*) getBoundColor;
- (NSDictionary*) getPlaceData;
- (double) getWidth;

- (NSInteger) getCount;
- (CLLocationCoordinate2D*) getLocationBounds;

- (void) drawSelfToScreen;
- (MKPolygon *) getPolygonRepresentation;
- (MKPolygon *) getPolyReference;
- (MKOverlayRenderer *) mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay;

@end