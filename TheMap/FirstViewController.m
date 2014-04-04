//
//  FirstViewController.m
//  TheMap
//
//  Created by Ivan Lugo on 1/14/14.
//  Copyright (c) 2014 Ivan Lugo. All rights reserved.
//


#import "FirstViewController.h"

@interface FirstViewController () <MKMapViewDelegate>
@property (nonatomic, strong) MBXMapView *mapView;
@property (strong, nonatomic) CBLDatabase *database;
@property (strong, nonatomic) CBLManager *manager;
@property (strong, nonatomic) NSMutableArray *drawnResidents;
@property (strong, nonatomic) NSMutableArray *drawnAmmenities;
@property (strong, nonatomic) NSMutableArray *drawnPlaces;
@property (strong, nonatomic) NSDictionary *theWebFile;
@property (strong, nonatomic) PlaceObject *currentTapObject;


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
    self.drawnAmmenities = [[NSMutableArray alloc] init];
    self.drawnResidents = [[NSMutableArray alloc] init];

    [self.mapView setCenterCoordinate:CLLocationCoordinate2DMake(28.552, -81.342) zoomLevel:18 animated:YES];
    
    
    //================================================================================================================
    UIButton *ammenities_button = [[UIButton alloc] initWithFrame: CGRectMake(10, 470, 100, 30)];
    [ammenities_button addTarget:nil
                          action:@selector(pressed:)
                forControlEvents:UIControlEventTouchDown];
    
    // Touch Recognizer
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(foundTap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    [self.mapView addGestureRecognizer:tapRecognizer];
    
    // -- Buttons --
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
    
    UIButton *resident_button = [[UIButton alloc] initWithFrame: CGRectMake(180, 470, 100, 30)];
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
    // -- End Buttons --

    [self.view addSubview:self.mapView];
    [self.view addSubview:ammenities_button];
    [self.view addSubview:resident_button];
    //===============================================================================================================
    
    
    //dispatch_queue_t queue = dispatch_get_global_queue(0,0);
    //dispatch_async(queue, ^{
    
    /*
    
        NSLog(@"Beginning download");
        NSString *stringURL = @"https://gist.githubusercontent.com/tikimcfee/9812125/raw/ab7e44a817270ac489a62fee260c619b84152117/gistfile1.txt";
        //NSString *stringURL = @"https://gist.githubusercontent.com/tikimcfee/9812220/raw/079efef70b9e73228b4a0dfcccdd9444c900c5d2/2ksource";
        NSURL  *url = [NSURL URLWithString:stringURL];
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        
        //Find a cache directory. You could consider using documenets dir instead (depends on the data you are fetching)
        NSLog(@"Got the data!");
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *path = [paths  objectAtIndex:0];
        
        //Save the data
        NSLog(@"Saving");
        NSString *dataPath = [path stringByAppendingPathComponent:@"lotsofshapes.geojson"];
        dataPath = [dataPath stringByStandardizingPath];
        [urlData writeToFile:dataPath atomically:YES];
        
        //int count;
        
     
        NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
        for (count = 0; count < (int)[directoryContent count]; count++)
        {
            NSLog(@"File %d: %@", (count + 1), [directoryContent objectAtIndex:count]);
        }
     
     */
     
     //   NSData *d = [[NSData alloc] initWithContentsOfFile:dataPath];
    //[[ NSBundle bundleWithPath:path] pathForResource:@"mapstuff" ofType:@"geojson"]
        //self.theWebFile = [NSJSONSerialization JSONObjectWithData:d
        //                                                          options:0
        //                                                            error:nil];
    
        [self loadCouchbase];
    
    //NSError *error;
    //CBLQuery* query = [[self.database viewNamed: @"places"] createQuery];
    //CBLQueryEnumerator *rowEnum = [query run: &error];
    //NSMutableArray *drawThese = [[NSMutableArray alloc] init];
    
    //for(CBLQueryRow* row in rowEnum)
    //{
    //    //NSLog(@"%@", row.value);
    //    [drawThese addObject:row.value];
    //}
    //[self placesToDraw:drawThese containerForNewPlaces:self.drawnAmmenities];

    
    //});
    
    
    

}

- (void) placesToDraw:(NSMutableArray*)places containerForNewPlaces:(NSMutableArray*)objects //mapCanvas:(MBXMapView*)mapView
{
    NSMutableArray *temp_place_pointer = nil;
    for(NSObject *place in places)
    {
        NSLog(@"The place is: %@", place);
        PlaceObject *newPlace = [[PlaceObject alloc] init];
        
        temp_place_pointer = [place valueForKeyPath:@"geometry.coordinates"];
        
        double boundR = [[place valueForKeyPath:@"properties.bound_color_R"] doubleValue];
        double boundG = [[place valueForKeyPath:@"properties.bound_color_G"] doubleValue];
        double boundB = [[place valueForKeyPath:@"properties.bound_color_B"] doubleValue];
        double fillR = [[place valueForKeyPath:@"properties.fill_color_R"] doubleValue];
        double fillG = [[place valueForKeyPath:@"properties.fill_color_G"] doubleValue];
        double fillB = [[place valueForKeyPath:@"properties.fill_color_B"] doubleValue];
        
        [newPlace setBoundColor: [UIColor colorWithRed:boundR green:boundG blue:boundB alpha:.5]];
        [newPlace setFillColor: [UIColor colorWithRed:fillR green:fillG blue:fillB alpha:.5]];
        
        //[newPlace setBoundColor: [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:.5]];
        //[newPlace setFillColor: [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:.5]];
        [newPlace setBoundWidth: 3.0];
        [newPlace setMapView:self.mapView];
        
        [newPlace setPlaceData:[place valueForKeyPath:@"place_data"]];
        
        for(NSObject *point in [temp_place_pointer objectAtIndex:0])
        {
            [newPlace addCLPointToPlace:CLLocationCoordinate2DMake([[(NSArray*) point objectAtIndex:1] doubleValue],
                                                                   [[(NSArray*) point objectAtIndex:0] doubleValue])];
        }
        
        [newPlace drawSelfToScreen];
        [objects addObject:newPlace];
        
        // GOT IT GOT IT GOT IT!!
        self.mapView.delegate = self;
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
- (BOOL) sayHello
{
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
    //NSDictionary *places = [self.theWebFile valueForKey:@"features"];
    for(NSObject *place in places)
    {
        NSLog(@"The dictionary string is %@", place);
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
    
    // REMOVE THIS TO KEEP VERSIONS!
    //int vers = 1;
    //vers = arc4random() % 100000;
    //NSString *thisV = [NSString stringWithFormat:@"%d", vers];
    
    [view setMapBlock: MAPBLOCK({
        id place = [doc objectForKey:@"place"];
        if (place)
        {
            //NSLog(@"The place found is %@", place);
            emit(place, doc);
        }
    }) version: @"0.15"];
     
    
    // we generate a new query object from the database with the same name
    // as the view we defined above. We then create an enumerator from that
    // querry after it has run, which contains a set of rows that contain a
    // key / value pair.
    CBLQuery* query = [[self.database viewNamed: @"places"] createQuery];
    CBLQueryEnumerator *rowEnum = [query run: &error];
    for (CBLQueryRow* row in rowEnum)
    {
        // WARNING - THIS WILL DELETE ALL THE DOCUMENTS IN THE LOCAL DATABASE!!
        // ** with a tag of 'places'
        // Use this to clear out the database
        
        //if(![row.document deleteDocument:&error])
        //    NSLog(@"Why not? -- %@", error.localizedDescription);
        
        //NSLog(@"The place type is : %@", row.key);
        //NSLog(@"The place value is : %@", row.value);
    }
    
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
        if([self.drawnAmmenities count] > 0)
        {
            for(PlaceObject *place in self.drawnAmmenities)
            {
                [self.mapView removeOverlay:place.getPolyReference];
            }
            self.drawnAmmenities = [[NSMutableArray alloc] init];
            self.currentTapObject = NULL;
        }
        else
        {
            for (CBLQueryRow* row in rowEnum)
            {
                if([row.key isEqualToString:@"amenity"])
                {
                    [drawThese addObject:row.value];
                }
            }
            
            [self placesToDraw:drawThese containerForNewPlaces:self.drawnAmmenities];
        }
    }
    else if( [[tapped currentTitle] isEqualToString:@"Residents"])
    { 
        if([self.drawnResidents count] > 0)
        {
            for(PlaceObject *place in self.drawnResidents)
            {
                [self.mapView removeOverlay:place.getPolyReference];
            }
            self.drawnResidents = [[NSMutableArray alloc] init];
            self.currentTapObject = NULL;
        }
        else
        {
            for (CBLQueryRow* row in rowEnum)
            {
                NSLog(@"%@", row.key);
                if([row.key isEqualToString:@"resident"])
                {
                    [drawThese addObject:row.value];
                }
            }
            
            [self placesToDraw:drawThese containerForNewPlaces:self.drawnResidents];
        }
    }

    NSLog(@"The button tapped is named: %@", [tapped currentTitle]);
    
}

-(IBAction)foundTap:(UITapGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:self.mapView];
    CLLocationCoordinate2D tapPoint = [self.mapView convertPoint:point toCoordinateFromView:self.view];
    NSError *error;
    
    CBLView *view = [self.database viewNamed:@"taps"];
    [view setMapBlock: MAPBLOCK({
        id place = [doc objectForKey:@"geometry"];
        if(place)
        {
            NSDictionary* temp = [doc valueForKeyPath:@"geometry"];
            NSDictionary* data = [doc valueForKeyPath:@"place_data"];
            NSLog(@"Added a new object to the TAPS view in foundTap");
            emit(CBLGeoJSONKey(temp), data);
        }
    }) version: @"1.6"];

    
    CBLQuery* query = [[self.database viewNamed: @"taps"] createQuery];
    query.boundingBox = (CBLGeoRect){{tapPoint.longitude - .000001, tapPoint.latitude - .000001}, {tapPoint.longitude + .000001, tapPoint.latitude + .000001} };
    //NSLog(@"{%f, %f}, {%f, %f}", query.boundingBox.min.x, query.boundingBox.min.y, query.boundingBox.max.x, query.boundingBox.max.y);
    CBLQueryEnumerator *rowEnum = [query run: &error];
    
    for (CBLGeoQueryRow* row in rowEnum)
    {
        //NSLog(@"Got the row val: %@", row.value);
        
        //NSLog(@"Found place with value %@", row.value);
        for(NSObject *place in self.drawnResidents)
        {
            if([[[(PlaceObject*)place getPlaceData] valueForKeyPath:@"building_name"] isEqualToString:[row.value valueForKeyPath:@"building_name"]])
            {
                if(self.currentTapObject != NULL)
                {
                    [self.mapView removeOverlay:[self.currentTapObject getPolyReference]];
                    [self.currentTapObject setFillColor:[self.currentTapObject getDefaultFill]];
                    [self.currentTapObject drawSelfToScreen];
                    self.mapView.delegate = self;
                }
                self.currentTapObject = (PlaceObject*)place;
                [self.mapView removeOverlay:[(PlaceObject*)place getPolyReference]];
                [self.currentTapObject setFillColor:[UIColor blackColor]];
                [self.currentTapObject drawSelfToScreen];
                self.mapView.delegate = self;
                [self popUpPlaceInformation:[(PlaceObject*)place getPlaceData]];
            }
        }
        for(NSObject *place in self.drawnAmmenities)
        {
            if([[[(PlaceObject*)place getPlaceData] valueForKeyPath:@"building_name"] isEqualToString:[row.value valueForKeyPath:@"building_name"]])
            {
                if(self.currentTapObject != NULL)
                {
                    [self.mapView removeOverlay:[self.currentTapObject getPolyReference]];
                    [self.currentTapObject setFillColor:[self.currentTapObject getDefaultFill]];
                    [self.currentTapObject drawSelfToScreen];
                    self.mapView.delegate = self;
                }
                self.currentTapObject = (PlaceObject*)place;
                [self.mapView removeOverlay:[(PlaceObject*)place getPolyReference]];
                [self.currentTapObject setFillColor:[UIColor blackColor]];
                [self.currentTapObject drawSelfToScreen];
                self.mapView.delegate = self;
                [self popUpPlaceInformation:[(PlaceObject*)place getPlaceData]];
            }
        }
    }
    NSLog(@"End this find");
    
    
    //MKPointAnnotation *point1 = [[MKPointAnnotation alloc] init];
    //point1.coordinate = tapPoint;
    
    //[self.mapView addAnnotation:point1];
}

- (void)popUpPlaceInformation:(NSDictionary*)place_data
{
    NSInteger x = 30;
    NSInteger y = 300;
    NSInteger width = 200;
    NSInteger height = 200;
    UIView *viewPopup = [[UIView alloc] initWithFrame:CGRectMake(x, y, width, height)];
    viewPopup.tag = 8675309;
    if([self.view viewWithTag:8675309] != NULL)
    {
        [[self.view viewWithTag:8675309]removeFromSuperview];
    }
    [self.view addSubview:viewPopup];
    
    // create Image View with image back (your blue cloud)
    /*
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(x, 0, width, 200)];
    UIImage *image =  [UIImage imageNamed:@"myimage"];
    [imageView setImage:image];
    [viewPopup addSubview:imageView];
     */
    
    UITextView *place = [[UITextView alloc] initWithFrame:CGRectMake(x, 0, width, 175)];
    [place setTextColor:[UIColor redColor]];
    place.editable = NO;
    NSMutableString *theFocus = [[NSMutableString alloc] init];
    [theFocus appendFormat:@"Name:\n\t%@\n", [place_data valueForKey:@"building_name"]];
    [theFocus appendFormat:@"Type:\n\t%@\n", [place_data valueForKey:@"building_type"]];
    [theFocus appendFormat:@"Tasks:\n\t%@\n", [place_data valueForKey:@"number_tasks"]];
    [theFocus appendFormat:@"Dance Party?\n\t%@\n", [place_data valueForKey:@"dance_party"]];
    [place setText:theFocus];
    [viewPopup addSubview:place];
    
    // create button into viewPopup
    UIButton *dismissPopUp = [[UIButton alloc] initWithFrame:CGRectMake(30, 125, width, 50)];
    [viewPopup addSubview: dismissPopUp];
    [dismissPopUp setTitle:@"Cool data, bro" forState:UIControlStateNormal];
    [dismissPopUp addTarget:self action:@selector(dismissInfo) forControlEvents:UIControlEventTouchDown];
    [dismissPopUp setTitleColor:[UIColor colorWithRed:166/255.0f
                                                     green:60/255.0f
                                                      blue:0/255.0f
                                                     alpha:1.0]
                            forState:UIControlStateNormal];
    [viewPopup addSubview:dismissPopUp];
}

- (void)dismissInfo
{
    [[self.view viewWithTag:8675309]removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
