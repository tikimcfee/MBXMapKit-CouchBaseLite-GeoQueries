//
//  MyPoint.m
//  TheMap
//
//  Created by Ivan Lugo on 1/22/14.
//  Copyright (c) 2014 Ivan Lugo. All rights reserved.
//

#import "PlaceObject.h"
#import "FirstViewController.h"
#import <MapKit/MapKit.h>

@implementation PlaceObject 


- (id) init {
    self = [super init];
    myPoints = [[NSMutableArray alloc] init];
    return self;
}

- (void)addCLPointToPlace:(CLLocationCoordinate2D)bound {
    MyPoint *translater = [[MyPoint alloc] Init: bound];
    [myPoints addObject:translater];
}

- (void)addBoundPointToPlace:(MyPoint*) bound {
    [myPoints addObject:bound];
}

- (CLLocationCoordinate2D*) getLocationBounds
{
    CLLocationCoordinate2D *toReturn = malloc(sizeof(CLLocationCoordinate2D) * [myPoints count]);
    NSInteger i = 0;
    for(MyPoint *point in myPoints)
    {
        //NSLog(@"Got new point, %f -- %f", point.getPoint.latitude, point.getPoint.longitude);
        toReturn[i++] = point.getPoint;
    }
    return toReturn;
}

- (NSInteger) getCount{
    return [myPoints count];
}

@end
