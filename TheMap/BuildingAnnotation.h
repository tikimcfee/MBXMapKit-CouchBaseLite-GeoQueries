//
//  BuildingAnnotation.h
//  TheMap
//
//  Created by Ivan Lugo on 1/27/14.
//  Copyright (c) 2014 Ivan Lugo. All rights reserved.
//

#import <MapKit/MapKit.h>
#import "MyPoint.h"

@interface BuildingAnnotation : NSObject <MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSMutableArray *bounds;

- (id)initWithLocation:(CLLocationCoordinate2D)coord;

- (void) setStartCoordinate:(CLLocationCoordinate2D)newCoordinate;
- (void) setBounds:(NSMutableArray *) bounds;
- (void) setBoundsByPoints:(NSMutableArray *) bounds;
- (NSMutableArray*) getBounds;



@end