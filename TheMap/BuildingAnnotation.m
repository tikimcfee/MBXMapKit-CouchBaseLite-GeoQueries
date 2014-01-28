//
//  BuildingAnnotation.m
//  TheMap
//
//  Created by Ivan Lugo on 1/27/14.
//  Copyright (c) 2014 Ivan Lugo. All rights reserved.
//

#import "BuildingAnnotation.h"

@implementation BuildingAnnotation
@synthesize coordinate;

- (id)initWithLocation:(CLLocationCoordinate2D)coord {
    self = [super init];
    if (self) {
        coordinate = coord;
    }
    return self;
}

- (void) setStartCoordinate:(CLLocationCoordinate2D)newCoordinate {
    coordinate = newCoordinate;
}

- (void) setBounds:(NSMutableArray *) bounds{
    _bounds = bounds;
}

- (void) setBoundsByPoints:(NSMutableArray *) bounds{
    
    for(MyPoint *point in bounds)
    {
        NSLog(@"Got a point, hooray!");
    }
}

- (NSMutableArray *) getBounds{
    return _bounds;
}




@end
