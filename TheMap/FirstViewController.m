//
//  FirstViewController.m
//  TheMap
//
//  Created by Ivan Lugo on 1/14/14.
//  Copyright (c) 2014 Ivan Lugo. All rights reserved.
//


#import "FirstViewController.h"

@interface FirstViewController ()
@property (nonatomic, strong) MBXMapView *mapView;
@property (strong, nonatomic) CBLDatabase *database;
@property (strong, nonatomic) CBLManager *manager;


@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Constructing the Map, setting delegates, centering
    //NSString *mapID = @"sightplan.map-eth3a279";
    NSString *mapID = @"mozilla-webprod.e91ef8b3";
    self.mapView = [[MBXMapView alloc] initWithFrame:self.view.bounds mapID:mapID ];
    self.mapView.delegate = self;
    [self loadCouchbase];
    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(28.552, -81.342) zoomLevel:19 animated:YES];
    
    
    //================================================================================================================
    UIButton *ammenities_button = [[UIButton alloc] initWithFrame: CGRectMake(10, 470, 100, 30)];
    [ammenities_button addTarget:nil
                          action:@selector(pressed:)
                forControlEvents:UIControlEventTouchDown];
    
    [ammenities_button setTitle:@"Ammenities" forState: UIControlStateNormal];

    [ammenities_button setBackgroundColor:[UIColor colorWithRed:0/255.0f
                                                    green:106/255.0f
                                                     blue:166/255.0f
                                                    alpha:1.0]];
    [ammenities_button setTitleColor:[UIColor colorWithRed:166/255.0f
                                               green:60/255.0f
                                                blue:0/255.0f
                                               alpha:1.0]
                                            forState:UIControlStateNormal];
    
    UIButton *resident_button = [[UIButton alloc] initWithFrame: CGRectMake(120, 470, 100, 30)];
    [resident_button addTarget:nil
                        action:@selector(pressed:)
              forControlEvents:UIControlEventTouchDown];
    
    [resident_button setTitle:@"Residents" forState: UIControlStateNormal];
    
    [resident_button setBackgroundColor:[UIColor colorWithRed:0/255.0f
                                                          green:106/255.0f
                                                           blue:166/255.0f
                                                            alpha:1.0]];
    
    [resident_button setTitleColor:[UIColor colorWithRed:166/255.0f
                                                     green:60/255.0f
                                                      blue:0/255.0f
                                                     alpha:1.0]
                          forState:UIControlStateNormal];

    [self.view addSubview:self.mapView];
    [self.view addSubview:ammenities_button];
    [self.view addSubview:resident_button];
    //================================================================================================================
    
//    
//    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"buildingsNew" ofType:@"geojson"];
//    NSDictionary *buildings = [NSJSONSerialization JSONObjectWithData:[[NSData alloc] initWithContentsOfFile:jsonPath]
//                                                              options:0
//                                                                error:nil];
    
    /* Iterate through the features described in the JSON file and create PlaceObject's to represent them, drawing them
    // as we go.
    // 
    // This is the future home of the code that will tag the modified PlaceObjects with their properties, as well as store
    // them in their respective floors, layers, etc.
     */
    //    NSMutableArray *places = [[buildings valueForKey:@"features"] mutableCopy];
    //    NSMutableArray *objects = [[NSMutableArray alloc] init];
    //[self placesToDraw:places containerForNewPlaces:objects];
    
}

- (void) placesToDraw:(NSMutableArray*)places containerForNewPlaces:(NSMutableArray*)objects //mapCanvas:(MBXMapView*)mapView
{
    NSMutableArray *temp_place_pointer = nil;
    for(NSObject *place in places)
    {
        NSLog(@"The place is: %@", place);
        PlaceObject *newPlace = [[PlaceObject alloc] init];
        [objects addObject:newPlace];
        
        temp_place_pointer = [place valueForKeyPath:@"geometry.coordinates"];
        
        double boundR = [[place valueForKeyPath:@"properties.bound_color_R"] doubleValue];
        double boundG = [[place valueForKeyPath:@"properties.bound_color_G"] doubleValue];
        double boundB = [[place valueForKeyPath:@"properties.bound_color_B"] doubleValue];
        double fillR = [[place valueForKeyPath:@"properties.fill_color_R"] doubleValue];
        double fillG = [[place valueForKeyPath:@"properties.fill_color_G"] doubleValue];
        double fillB = [[place valueForKeyPath:@"properties.fill_color_B"] doubleValue];
        
        [newPlace setBoundColor: [UIColor colorWithRed:boundR green:boundG blue:boundB alpha:.5]];
        [newPlace setFillColor: [UIColor colorWithRed:fillR green:fillG blue:fillB alpha:.5]];
        [newPlace setBoundWidth: 3.0];
        [newPlace setMapView:self.mapView];
        
        for(NSObject *point in [temp_place_pointer objectAtIndex:0])
        {
            [newPlace addCLPointToPlace:CLLocationCoordinate2DMake([[(NSArray*) point objectAtIndex:1] doubleValue],
                                                                   [[(NSArray*) point objectAtIndex:0] doubleValue])];
        }
        
        [newPlace drawSelfToScreen];
    }
}

- (void)loadCouchbase
{
    // Creates a shared instance of CBLManager
    self.manager = [CBLManager sharedInstance];
    
    // Create a database!
    NSError *error;
    self.database = [self.manager databaseNamed:@"place-data" error: &error];
    
    
    BOOL result = [self sayHello];
    NSLog(@"This instance was %@.", (result ? @"a total success." : @"a failure that may bring upon us the destruction of man."));
}

// creates a database, and then creates, stores, and retrieves a document
- (BOOL) sayHello {
    
    // holds error error messages from unsuccessful calls
    NSError *error;
    
    if (!self.manager) {
        NSLog (@"Cannot create shared instance of CBLManager");
        return NO;
    }
    
    // create a name for the database and make sure the name is legal
    NSString *dbname = @"my_place_database";
    if (![CBLManager isValidDatabaseName: dbname]) {
        NSLog (@"Bad database name");
        return NO;
    }
    
    // create a new database
    self.database = [self.manager databaseNamed: dbname error: &error];
    if (!self.database) {
        NSLog (@"Cannot create database. Error message: %@", error.localizedDescription);
        return NO;
    }
    
    // create an object that contains data for the new document
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"buildingsNew" ofType:@"geojson"];
    NSDictionary *buildings = [NSJSONSerialization JSONObjectWithData:[[NSData alloc] initWithContentsOfFile:jsonPath]
                                                              options:0
                                                                error:nil];

    NSDictionary *places = [buildings valueForKey:@"features"];
    for(NSObject *place in places)
    {
        //NSLog(@"The dictionary string is %@", place);
        CBLDocument* doc = [self.database createDocument];
        //[doc putProperties:(NSDictionary*) place error:&error];
        CBLRevision *newRevision = [doc putProperties:(NSDictionary*)place error: &error];
        if (!newRevision) {
            NSLog (@"Already found the entry in the database. Error message: %@", error.localizedDescription);
         
        }
    }
    
    
    // create a view so we can define a map function that will find every
    // instance of a document that contains a key specified, and emit that
    // into the view, where it can be queried in the code below
    CBLView *view = [self.database viewNamed:@"places"];
    
    [view setMapBlock: MAPBLOCK({
        id place = [doc objectForKey:@"place"];
        if (place)
        {
            NSLog(@"The place found is %@", place);
            emit(place, doc);
        }
    }) version: @"1.0"];
    
    // we generate a new query object from the database with the same name
    // as the view we defined above. We then create an enumerator from that
    // querry after it has run, which contains a set of rows that contain a
    // key / value pair.
    CBLQuery* query = [[self.database viewNamed: @"places"] createQuery];
    CBLQueryEnumerator *rowEnum = [query run: &error];
    for (CBLQueryRow* row in rowEnum)
    {
        // WARNING - THIS WILL DELETE ALL THE DOCUMENTS IN THE LOCAL DATABASE!!
        // Use this to clear out the database
        
        //if(![row.document deleteDocument:&error])
        //    NSLog(@"Why not? -- %@", error.localizedDescription);
        
        //NSLog(@"The place type is : %@", row.key);
        //NSLog(@"The place value is : %@", row.value);
    }
    
    
    // an array MUST be read as a 'property' by Couchbase, NOT a value!!
    //NSMutableArray *places = [retrievedDoc propertyForKey:@"features"];
    
    //NSMutableArray *objects = [[NSMutableArray alloc] init];
    //[self placesToDraw:places containerForNewPlaces:objects];
    
    return YES;
    
}

- (void)pressed:(UIButton*)tapped
{
    NSError *error;
    CBLQuery* query = [[self.database viewNamed: @"places"] createQuery];
    CBLQueryEnumerator *rowEnum = [query run: &error];
    NSMutableArray *drawThese = [[NSMutableArray alloc] init];
    
    if( [[tapped currentTitle] isEqualToString:@"Ammenities"])
    {
        for (CBLQueryRow* row in rowEnum)
        {
            if([row.key isEqualToString:@"amenity"])
            {
                [drawThese addObject:row.value];
            }
        }
    }
    else if( [[tapped currentTitle] isEqualToString:@"Residents"])
    {
        for (CBLQueryRow* row in rowEnum)
        {
            if([row.key isEqualToString:@"resident"])
            {
                [drawThese addObject:row.value];
            }
        }
    }
    
    NSMutableArray *here = [[NSMutableArray alloc] init];
    [self placesToDraw:drawThese containerForNewPlaces:here];
    

    NSLog(@"The button tapped is named: %@", [tapped currentTitle]);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
