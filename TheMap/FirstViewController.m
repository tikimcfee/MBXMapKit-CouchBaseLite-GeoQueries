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
#import <Mapbox/Mapbox.h>

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    // Constructing the Map, setting delegates, centering
    NSString *mapID = @"sightplan.map-eth3a279";
    MBXMapView *mapView = [[MBXMapView alloc] initWithFrame:self.view.bounds mapID:mapID ];
    mapView.delegate = self;
    //[mapView setCenterCoordinate:CLLocationCoordinate2DMake(28.552, -81.342) zoomLevel:20 animated:YES];
    [self.view addSubview:mapView];
    // XXX -- END MAP INITIALIZATION
    //  X  -- END MAP INITIALIZATION
    
    
    
    /* Start parsing 'building.geojson' to create Place objects.
    // TODO: -- find suitable name for JSON file
    // TODO: -- standardize name of object features
     */
    
    //NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"buildingsNew" ofType:@"geojson"];
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"countriesREPLACED" ofType:@"geojson"];
    NSDictionary *buildings = [NSJSONSerialization JSONObjectWithData:[[NSData alloc] initWithContentsOfFile:jsonPath]
                                                              options:0
                                                                error:nil];
    
    /* Build iterable array of points from JSON object
    // NOTE -- The current strucuture of the .geojson file has the bounding points wrapped within an object array, so
    //         they must be accessed with an 'objectAtIndex:0'. This might change when we have places within places
     
    NSMutableArray *points = [[[[buildings objectForKey:@"features"] objectAtIndex:0]
                               valueForKeyPath:@"geometry.coordinates"] mutableCopy];
    // XXX -- END JSON PARSING
    //  X  -- END JSON PARSING
    */
    
    
    /* Iterate through the features described in the JSON file and create PlaceObject's to represent them, drawing them
    // as we go.
    // 
    // This is the future home of the code that will tag the modified PlaceObjects with their properties, as well as store
    // them in their respective floors, layers, etc.
     */
    //NSMutableArray *places = [[buildings valueForKey:@"features"] mutableCopy];
    NSMutableArray *places = [[buildings valueForKey:@"features"] mutableCopy];
    NSMutableArray *temp_place_pointer = nil;
    int i = 1;
    for(NSObject *place in places)
    {
        NSLog(@"%d in place loop...", i++);
        PlaceObject *newPlace = [[PlaceObject alloc] init];
        temp_place_pointer = [[place valueForKeyPath:@"geometry.coordinates"] mutableCopy];
        
        /*
        double boundR = [[place valueForKeyPath:@"properties.bound_color_R"] doubleValue];
        double boundG = [[place valueForKeyPath:@"properties.bound_color_G"] doubleValue];
        double boundB = [[place valueForKeyPath:@"properties.bound_color_B"] doubleValue];
        double fillR = [[place valueForKeyPath:@"properties.fill_color_R"] doubleValue];
        double fillG = [[place valueForKeyPath:@"properties.fill_color_G"] doubleValue];
        double fillB = [[place valueForKeyPath:@"properties.fill_color_B"] doubleValue];
        
        */
        [newPlace setBoundColor: [UIColor colorWithRed:.5 green:.5 blue:.5 alpha:.5]];
        [newPlace setFillColor: [UIColor colorWithRed:.2 green:.2 blue:.2 alpha:.5]];
        
         [newPlace setMapView:mapView];
         
        
        for(NSObject *point in [temp_place_pointer objectAtIndex:0])
        {
            [newPlace addCLPointToPlace:CLLocationCoordinate2DMake([[(NSArray*) point objectAtIndex:1] doubleValue],
                                                                   [[(NSArray*) point objectAtIndex:0] doubleValue])];
        }
        
        [newPlace drawSelfToScreen];
        //MKPolygon *new_place_overlay = [MKPolygon polygonWithCoordinates:[newPlace getLocationBounds] count:[newPlace getCount]];
    }
    
    [super viewDidLoad];
    
}

/*
- (MKOverlayRenderer *) mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    //MKPolygonRenderer *temp = [[MKPolygonRenderer alloc] initWithPolygon:[(PlaceObject*) overlay getPolygonRepresentation]];
    
    NSLog(@"super ... %@", NSStringFromClass([overlay superclass]) );
    NSLog(@"super ... %@", NSStringFromClass([[overlay superclass] superclass]) );
    NSLog(@"super ... %@", NSStringFromClass([[[overlay superclass] superclass] superclass]) );
    NSLog(@"super ... %@", NSStringFromClass([[[[overlay superclass] superclass]superclass]superclass]) );
    
    if ([overlay isKindOfClass:[MKPolyline class]]) {
        MKPolylineRenderer *lineRenderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        lineRenderer.strokeColor = [UIColor yellowColor];
        lineRenderer.lineWidth = 2.0;
        return lineRenderer;
    }
    else if([overlay isKindOfClass:[MKPolygon class]])
    {
        if([overlay isKindOfClass:[PlaceObject class]])
        {
            MKPolygonRenderer *polyRenderer = [[MKPolygonRenderer alloc]
                                               initWithPolygon:[(PlaceObject*)overlay getPolygonRepresentation]];
            polyRenderer.strokeColor = [(PlaceObject*)overlay getBoundColor];
            polyRenderer.fillColor = [(PlaceObject*)overlay getFillColor];
            polyRenderer.lineWidth = [(PlaceObject*)overlay getWidth];
            return polyRenderer;
        }
        else
        {
            MKPolygonRenderer *polyRenderer = [[MKPolygonRenderer alloc] initWithPolygon:overlay];
            polyRenderer.strokeColor = [UIColor yellowColor];
            polyRenderer.fillColor = [[UIColor blueColor] colorWithAlphaComponent:0.2];
            polyRenderer.lineWidth = 2.0;
            return polyRenderer;
        }
    }
    
    return nil;
}
 */

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
