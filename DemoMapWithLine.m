@implementation MyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    RMMapboxSource *tileSource = [[RMMapboxSource alloc] initWithMapID:@"examples.map-z2effxa8"];
    RMMapView *mapView = [[RMMapView alloc] initWithFrame:self.view.bounds andTilesource:tileSource];

    // delegate questions
    mapView.delegate = self;

    // does this 'draw' the map to the screen?
    [self.view addSubview:mapView];

    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"shape" ofType:@"geojson"];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[[NSData alloc] initWithContentsOfFile:jsonPath] 
                                                        options:0
                                                        error:nil];

    // creates an array from the json file of points
    self.points = [[[[json objectForKey:@"features"] objectAtIndex:0] valueForKeyPath:@"geometry.coordinates"] mutableCopy];

    
    // iterate through the points?
    for (NSUInteger i = 0; i < [self.points count]; i++)
        [self.points replaceObjectAtIndex:i
                               withObject:[[CLLocation alloc] initWithLatitude:[[[self.points objectAtIndex:i] objectAtIndex:1] doubleValue]
                                                                     longitude:[[[self.points objectAtIndex:i] objectAtIndex:0] doubleValue]]];

    RMAnnotation *annotation = [[RMAnnotation alloc] initWithMapView:mapView
                                                          coordinate:mapView.centerCoordinate
                                                            andTitle:@"My Path"];

    [mapView addAnnotation:annotation];

    [annotation setBoundingBoxFromLocations:self.points];

    mapView.centerCoordinate = CLLocationCoordinate2DMake(45.526795, -122.682953);

    mapView.zoom = 12;
}

- (RMMapLayer *)mapView:(RMMapView *)mapView layerForAnnotation:(RMAnnotation *)annotation
{
    if (annotation.isUserLocationAnnotation)
        return nil;

    RMShape *shape = [[RMShape alloc] initWithView:mapView];

    shape.lineColor = [UIColor purpleColor];
    shape.lineWidth = 5.0;

    for (CLLocation *point in self.points)
        [shape addLineToCoordinate:point.coordinate];

    return shape;
}

@end