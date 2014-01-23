//
//  FirstViewController.m
//  TheMap
//
//  Created by Ivan Lugo on 1/14/14.
//  Copyright (c) 2014 Ivan Lugo. All rights reserved.
//

#import "FirstViewController.h"
#import "MyPoint.h"
#import <Mapbox/Mapbox.h>

@interface FirstViewController ()

@property (nonatomic, strong) NSMutableArray *layer_shapes;
@property (nonatomic, strong) NSMutableArray *shape_points_container;
@property (nonatomic, strong) RMShape *line;

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSString *mapID = @"ivanlugo.gp0o968d";
    RMMapboxSource *tileSource = [[RMMapboxSource alloc] initWithMapID:mapID];
    RMMapView *mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:tileSource];

    self.shape_points_container = [[NSMutableArray alloc] init];
    self.layer_shapes = [[NSMutableArray alloc] init];
    
    
    // delegate questions
    mapView.delegate = (id)self;
    [self.view addSubview:mapView];
    
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(28.552, -81.342) animated:NO];
    
    RMAnnotation *annotation = [[RMAnnotation alloc] initWithMapView:mapView
                                                          coordinate:mapView.centerCoordinate
                                                            andTitle:nil];
    [mapView addAnnotation:annotation];
    
}

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
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake([map pixelToCoordinate:point].latitude,
                                                              [map pixelToCoordinate:point].longitude);
    MyPoint *coord2 = [[MyPoint alloc] Init:coord];
    [self.shape_points_container addObject: coord2];
    
    /*
     if(self.shape_points_container.count == 1)
     {
     self.firstTouch = [[RMCircle alloc] initWithView:map radiusInMeters:.3];
     
     }
     */
    if(self.shape_points_container.count > 1 &&
       [((MyPoint*)[self.shape_points_container objectAtIndex:0]) isEqual:coord2])
    {
        NSLog(@"Back to first!");
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
        [self.line addLineToCoordinate:coord];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end