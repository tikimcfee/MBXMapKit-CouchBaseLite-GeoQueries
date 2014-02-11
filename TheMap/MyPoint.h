//
//  MyPoint.h
//  TheMap
//
//  Created by Ivan Lugo on 1/22/14.
//  Copyright (c) 2014 Ivan Lugo. All rights reserved.
//

#ifndef TheMap_MyPoint_h
#define TheMap_MyPoint_h
#endif
#import <MapKit/MapKit.h>

@interface MyPoint:NSObject
{
    CLLocationCoordinate2D myPoint;
}

- (CLLocationCoordinate2D) getPoint;
- (id) init;
- (id) Init:(CLLocationCoordinate2D) point;
- (BOOL)isEqual:(id)anObject;

@end