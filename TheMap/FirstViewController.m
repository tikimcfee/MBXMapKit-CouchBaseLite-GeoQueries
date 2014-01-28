//
//  FirstViewController.m
//  TheMap
//
//  Created by Ivan Lugo on 1/14/14.
//  Copyright (c) 2014 Ivan Lugo. All rights reserved.
//

#import "FirstViewController.h"
#import "PlaceObject.h"
#import "MyPoint.h"
#import "MBXMapKit.h"
#import <MapKit/MapKit.h>
#import <Mapbox/Mapbox.h>

@interface FirstViewController ()

@property (nonatomic, strong) NSMutableArray *layer_shapes;
@property (nonatomic, strong) NSMutableArray *shape_points_container;
@property (nonatomic, strong) RMCircleAnnotation *firstTouch;
@property (nonatomic, strong) RMShape *line;

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    NSString *mapID = @"sightplan.map-eth3a279";
    MBXMapView *mapView = [[MBXMapView alloc] initWithFrame:self.view.bounds mapID:mapID ];
    mapView.delegate = self;
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(28.552, -81.342) zoomLevel:20 animated:YES];
    [self.view addSubview:mapView];
    
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"buildings" ofType:@"geojson"];
    NSDictionary *buildings = [NSJSONSerialization JSONObjectWithData:[[NSData alloc] initWithContentsOfFile:jsonPath]
                                                              options:0
                                                                error:nil];
    NSMutableArray *points = [[[[buildings objectForKey:@"features"] objectAtIndex:0] valueForKeyPath:@"geometry.coordinates"] mutableCopy];
    PlaceObject *firstPlace = [[PlaceObject alloc] init];
    
    for(NSObject *point in [points objectAtIndex:0])
    {
        [firstPlace addCLPointToPlace:CLLocationCoordinate2DMake([[(NSArray*) point objectAtIndex:1] doubleValue],
                                                                 [[(NSArray*) point objectAtIndex:0] doubleValue])];
        
        NSLog(@"Have the coords %f , %f", [[(NSArray*) point objectAtIndex:1] doubleValue],
              [[(NSArray*) point objectAtIndex:0] doubleValue]);
    }
    
    /*
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(28.552, -81.342) zoomLevel:20 animated:YES];
    MyPoint *p1 = [[MyPoint alloc] Init: CLLocationCoordinate2DMake(28.5521, -81.3421)];
    MyPoint *p2 = [[MyPoint alloc] Init: CLLocationCoordinate2DMake(28.5525, -81.3425)];
    MyPoint *p3 = [[MyPoint alloc] Init: CLLocationCoordinate2DMake(28.5525, -81.3421)];
    MyPoint *p4 = [[MyPoint alloc] Init: CLLocationCoordinate2DMake(28.5521, -81.3421)];
    //MyPoint *p5 = [[MyPoint alloc] Init: CLLocationCoordinate2DMake(28.5525, -81.3425)];
    
    [firstPlace addBoundPointToPlace:p1];
    [firstPlace addBoundPointToPlace:p2];
    [firstPlace addBoundPointToPlace:p3];
    [firstPlace addBoundPointToPlace:p4];
    //[firstPlace addBoundPointToPlace:p5];
     */
    
    //MKPolyline *myFirstBuilding = [MKPolyline polylineWithCoordinates:[firstPlace getLocationBounds] count:[firstPlace getCount]];
    MKPolygon *myFirstTrue = [MKPolygon polygonWithCoordinates:[firstPlace getLocationBounds] count:[firstPlace getCount]];
    
    [mapView addOverlay:myFirstTrue];
    
    [super viewDidLoad];
    
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *lineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        lineRenderer.strokeColor = [UIColor yellowColor];
        lineRenderer.lineWidth = 2.0;
        return lineRenderer;
    }
    else if([overlay isKindOfClass:[MKPolygon class]])
    {
        MKPolygonRenderer *polyRenderer = [[MKPolygonRenderer alloc] initWithPolygon:overlay];
        polyRenderer.strokeColor = [UIColor yellowColor];
        polyRenderer.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
        polyRenderer.lineWidth = 2.0;
        return polyRenderer;
    }
        return nil;
}

/*
- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    if (annotation.isUserLocationAnnotation)
        return nil;
    
    
    self.line = [[RMShape alloc] initWithView:mapView];
    self.line.lineWidth = 3.0;
    self.line.lineColor = [UIColor blueColor];
    return self.line;
    
}

- (void)singleTapOnMap:(RMMapView *)map at:(CGPoint)point
{
    MyPoint *coord = [[MyPoint alloc] Init:CLLocationCoordinate2DMake([map pixelToCoordinate:point].latitude,
                                                                       [map pixelToCoordinate:point].longitude)];
    [self.shape_points_container addObject: coord];

    if(self.shape_points_container.count == 1)
    {
        self.firstTouch =  [[RMCircleAnnotation alloc] initWithMapView:map centerCoordinate:coord.getPoint radiusInMeters:3];
        [map addAnnotation:self.firstTouch];
    }
    else if(self.shape_points_container.count > 1 &&
            [((MyPoint*)[self.shape_points_container objectAtIndex:0]) isEqual:coord])
    {
        NSLog(@"Back to first!");
        [map removeAnnotation:self.firstTouch];
        [self.line addLineToCoordinate:((MyPoint*)[self.shape_points_container objectAtIndex:0]).getPoint];
        [self.layer_shapes addObject:self.shape_points_container];
        
        self.shape_points_container = [[NSMutableArray alloc] init];
        self.line = nil;
        RMAnnotation *annotation = [[RMAnnotation alloc] initWithMapView:map
                                                              coordinate:map.centerCoordinate
                                                                andTitle:nil];
        [map addAnnotation:annotation];
        
    }
    else
        [self.line addLineToCoordinate:coord.getPoint];
}
*/

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
