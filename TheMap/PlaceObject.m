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
    placeMapView = nil;
    fill_color = [UIColor whiteColor];
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

- (void)addCLPointToPlace:(CLLocationCoordinate2D)bound {
    MyPoint *translater = [[MyPoint alloc] Init: bound];
    [bound_points addObject:translater];
}

- (void)addBoundPointToPlace:(MyPoint*) bound {
    [bound_points addObject:bound];
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
    return [MKPolygon polygonWithCoordinates:self.getLocationBounds count:self.getCount];
}

- (void) drawSelfToScreen
{
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
