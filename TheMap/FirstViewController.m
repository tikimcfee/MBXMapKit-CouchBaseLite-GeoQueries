//
//  FirstViewController.m
//  TheMap
//
//  Created by Ivan Lugo on 1/14/14.
//  Copyright (c) 2014 Ivan Lugo. All rights reserved.
//


#import "FirstViewController.h"

@interface FirstViewController ()
@property (nonatomic, weak) MBXMapView *mapView;
@property (strong, nonatomic) CBLDatabase *database;
@property (strong, nonatomic) CBLManager *manager;


@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Constructing the Map, setting delegates, centering
    NSString *mapID = @"sightplan.map-eth3a279";
    MBXMapView *mapView = [[MBXMapView alloc] initWithFrame:self.view.bounds mapID:mapID ];
    mapView.delegate = self;
    [self loadCoachbase];
    [mapView setCenterCoordinate:CLLocationCoordinate2DMake(28.552, -81.342) zoomLevel:20 animated:YES];
    
    
    //================================================================================================================
    UIButton *leftButton = [[UIButton alloc] initWithFrame: CGRectMake(10, 470, 100, 30)];
    [leftButton addTarget:nil
                   action:@selector(pressed)
         forControlEvents:UIControlEventTouchDown];
    
    [leftButton setTitle:@"Ammenities" forState: UIControlStateNormal];

    [leftButton setBackgroundColor:[UIColor colorWithRed:0/255.0f
                                                    green:106/255.0f
                                                     blue:166/255.0f
                                                    alpha:1.0]];
    [leftButton setTitleColor:[UIColor colorWithRed:166/255.0f
                                               green:60/255.0f
                                                blue:0/255.0f
                                               alpha:1.0]
                                            forState:UIControlStateNormal];

    [self.view addSubview:mapView];
    self.mapView = mapView;
    [self.view addSubview:leftButton];
    //================================================================================================================
    
    
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"buildingsNew" ofType:@"geojson"];
    NSDictionary *buildings = [NSJSONSerialization JSONObjectWithData:[[NSData alloc] initWithContentsOfFile:jsonPath]
                                                              options:0
                                                                error:nil];
    
    /* Iterate through the features described in the JSON file and create PlaceObject's to represent them, drawing them
    // as we go.
    // 
    // This is the future home of the code that will tag the modified PlaceObjects with their properties, as well as store
    // them in their respective floors, layers, etc.
     */
    NSMutableArray *places = [[buildings valueForKey:@"features"] mutableCopy];
    NSMutableArray *objects = [[NSMutableArray alloc] init];
    [self placesToDraw:places containerForNewPlaces:objects];
    
}

- (void) placesToDraw:(NSMutableArray*)places containerForNewPlaces:(NSMutableArray*)objects
{
    NSMutableArray *temp_place_pointer = nil;
    for(NSObject *place in places)
    {
        PlaceObject *newPlace = [[PlaceObject alloc] init];
        [objects addObject:newPlace];
        
        temp_place_pointer = [[place valueForKeyPath:@"geometry.coordinates"] mutableCopy];
        
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

- (void)loadCoachbase
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
//    NSDictionary *myDictionary =[NSDictionary dictionaryWithObjectsAndKeys:@"Hello Couchbase Lite!", @"message", [[NSDate date] description], @"timestamp",
//     nil];
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"buildingsNew" ofType:@"geojson"];
    NSDictionary *buildings = [NSJSONSerialization JSONObjectWithData:[[NSData alloc] initWithContentsOfFile:jsonPath]
                                                              options:0
                                                                error:nil];
    
    // display the data for the new document
    NSLog (@"This is the data for the document: %@", buildings);
    
    // create an empty document
    CBLDocument* doc = [self.database createDocument];
    
    // write the document to the database
    CBLRevision *newRevision = [doc putProperties: buildings error: &error];
    if (!newRevision) {
        NSLog (@"Cannot write document to database. Error message: %@", error.localizedDescription);
    }
    
    // save the ID of the new document
    NSString *docID = doc.documentID;
    
    // retrieve the document from the database
    CBLDocument *retrievedDoc = [self.database documentWithID: docID];
    
    // display the retrieved document
    NSLog(@"The retrieved document contains: %@", retrievedDoc.properties);
    
    return YES;
    
}

- (void)pressed
{
    NSLog(@"AW YEAH!!");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
