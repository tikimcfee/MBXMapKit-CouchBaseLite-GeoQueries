//
//  MyPoint.m
//  TheMap
//
//  Created by Ivan Lugo on 1/22/14.
//  Copyright (c) 2014 Ivan Lugo. All rights reserved.
//

#import "PlaceObject.h"

@implementation PlaceObject

- (id) init
{
    self = [super init];
    bound_points = [[NSMutableArray alloc] init];
    
    bound_color = [UIColor blackColor];
    bound_line_width = 1.0;
    fill_color = [UIColor whiteColor];

    placeMapView = nil;
    my_polygon = nil;
    
    return self;
}

- (void) setMapView:(MBXMapView *)mapView
{
    placeMapView = mapView;
    placeMapView.delegate = self;
}

- (void) setBoundColor:(UIColor *)color
{
    bound_color = color;
}

- (void) setFillColor:(UIColor*)color
{
    if(default_fill == NULL)
        default_fill = color;
    fill_color = color;
}

- (void) setBoundWidth:(double)width
{
    bound_line_width = width;
}

- (double) getWidth
{
    return bound_line_width;
}

- (UIColor*) getBoundColor
{
    return bound_color;
}

- (UIColor*) getFillColor
{
    return fill_color;
}

- (UIColor*) getDefaultFill
{
    return default_fill;
}

- (void)addCLPointToPlace:(CLLocationCoordinate2D)bound
{
    MyPoint *translater = [[MyPoint alloc] Init: bound];
    [bound_points addObject:translater];
}

- (void)addBoundPointToPlace:(MyPoint*) bound
{
    [bound_points addObject:bound];
}

- (void)setPlaceData:(NSDictionary *)description
{
    place_data = description;
}

- (NSDictionary *)getPlaceData
{
    return place_data;
}

- (CLLocationCoordinate2D*) getLocationBounds
{
    if(placeBounds != NULL)
        free(placeBounds);
    
    placeBounds = malloc(sizeof(CLLocationCoordinate2D) * [bound_points count]);
    NSInteger i = 0;
    for(MyPoint *point in bound_points)
    {
        //NSLog(@"Got new point, %f -- %f", point.getPoint.latitude, point.getPoint.longitude);
        placeBounds[i++] = point.getPoint;
    }
    return placeBounds;
}

- (NSInteger) getCount{
    return [bound_points count];
}

- (MKPolygon *) getPolygonRepresentation
{
    placeMapView.delegate = self;
    my_polygon = [MKPolygon polygonWithCoordinates:self.getLocationBounds count:self.getCount];
    return my_polygon;
}

- (MKPolygon *) getPolyReference
{
    return my_polygon;
}

- (void) drawSelfToScreen
{
    placeMapView.delegate = self;
    [placeMapView addOverlay:self.getPolygonRepresentation];
}

- (MKOverlayRenderer *) mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolygonRenderer *polyRenderer = [[MKPolygonRenderer alloc]
                                       initWithPolygon:overlay];
    polyRenderer.strokeColor = self.getBoundColor;
    polyRenderer.fillColor = self.getFillColor;
    polyRenderer.lineWidth = self.getWidth;
    
    return polyRenderer;
}


@end
