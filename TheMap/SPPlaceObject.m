//
//  SPPlaceObject.m
//  TheMap
//
//  Created by Ivan Lugo on 4/4/14.
//  Copyright (c) 2014 Ivan Lugo. All rights reserved.
//

#import "SPPlaceObject.h"
#import "MyPoint.h"

@implementation SPPlaceObject

@dynamic place_data, place, geometry;



- (NSString *)getMyName
{
    return self.place;
}

- (MKPolygon*) getMyPolygonFromDocID:(NSString*)doc_id inDatabase:(CBLDatabase*)database forDrawings:drawn_documents
{
    if([[database documentWithID:doc_id] propertyForKey:@"polygon"] == NULL)
    {
        NSLog(@"Inniting polygon");
       // NSMutableArray *bound_points = [[NSMutableArray alloc] init];
        
        NSDictionary *new_coordinates = [[database documentWithID:doc_id].properties mutableCopy];
        NSMutableArray *temp_read = [new_coordinates valueForKeyPath:@"geometry.coordinates"];
        
        NSInteger num_points = [[temp_read objectAtIndex:0] count];
        CLLocationCoordinate2D *place_bounds = malloc(sizeof(CLLocationCoordinate2D) * num_points);
        NSInteger place_counter = 0;
        
        for(NSObject *point in [temp_read objectAtIndex:0])
        {
            CLLocationCoordinate2D myPoint = CLLocationCoordinate2DMake([[(NSArray*) point objectAtIndex:1] doubleValue],
                                                                         [[(NSArray*) point objectAtIndex:0] doubleValue]);
            MyPoint *translater = [[MyPoint alloc] Init: myPoint];
            place_bounds[place_counter++] = translater.getPoint;
        }
        
        self.my_polygon = [MKPolygon polygonWithCoordinates:place_bounds count:num_points];
        //NSMutableDictionary *new = [[NSMutableDictionary alloc] init];
        //[new setObject:self.my_polygon forKey:@"polygon"];
        //[self setAttachmentNamed:@"polygon" withContentType:@"NON_MIME" content:new];
        
        [drawn_documents setObject:self.my_polygon forKey:[self.place_data valueForKey:@"building_name"]];
        
        NSError *error;
        [new_coordinates setValue:@"drawn" forKey:@"polygon"];
        if(![[database documentWithID:doc_id] putProperties:new_coordinates error:&error])
        {
            NSLog(@"Could not add polygon to document. Crashing now, lolz");
        }
        
    }
    else
    {
        //self.my_polygon = [(NSMutableDictionary*)[self attachmentNamed:@"polygon"] objectForKey:@"polygon"];
        self.my_polygon = [drawn_documents valueForKey:[self.place_data valueForKey:@"building_name"]];
    }

    return self.my_polygon;
}

- (MKPolygonRenderer*) getMyRenderer
{
    return NULL;
    
}

- (void) drawSelfToScreen:(MBXMapView*)withMapView fromDocument:(NSMutableDictionary*)drawnDocuments
{
    withMapView.delegate = self;
    NSString *building = [self.place_data valueForKey:@"building_name"];
    [withMapView addOverlay:[drawnDocuments valueForKey:building]];
}

- (MKOverlayRenderer *) mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolygonRenderer *polyRenderer = [[MKPolygonRenderer alloc]
                                       initWithPolygon:overlay];
    polyRenderer.strokeColor = [UIColor blackColor];
    polyRenderer.fillColor = [UIColor whiteColor];
    polyRenderer.lineWidth = 2.0;
    
    return polyRenderer;
}


@end
