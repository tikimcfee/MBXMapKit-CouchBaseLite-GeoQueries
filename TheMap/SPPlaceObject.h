//
//  SPPlaceObject.h
//  TheMap
//
//  Created by Ivan Lugo on 4/4/14.
//  Copyright (c) 2014 Ivan Lugo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBXMapKit.h"
#import "MyPoint.h"

@interface SPPlaceObject : CBLModel  <MKMapViewDelegate>

@property (strong, nonatomic) NSString *place;
@property (strong, nonatomic) NSDictionary *place_data;
@property (strong, nonatomic) NSDictionary *geometry;
@property (strong, nonatomic) MKPolygon *my_polygon;
@property (strong, nonatomic) MKPolygonRenderer *my_renderer;

- (NSString*) getMyName;
- (MKPolygon*) getMyPolygonFromDocID:doc_id inDatabase:database forDrawings:drawnDocuments;

- (MKPolygonRenderer*) getMyRenderer;
- (void) drawSelfToScreen:withMapView fromDocument:drawnDocuments;
- (MKOverlayRenderer *) mapView:mapView rendererForOverlay:overlay;

@end
