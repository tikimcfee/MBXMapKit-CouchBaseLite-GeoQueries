//
//  MyPoint.m
//  TheMap
//
//  Created by Ivan Lugo on 1/22/14.
//  Copyright (c) 2014 Ivan Lugo. All rights reserved.
//

#import "MyPoint.h"

@implementation MyPoint

- (id) init
{
    self = [super init];
    myPoint = CLLocationCoordinate2DMake(0, 0);;
    return self;
}

- (id) Init:(CLLocationCoordinate2D) point{
    myPoint.latitude = point.latitude;
    myPoint.longitude = point.longitude;
    return self;
}

- (CLLocationCoordinate2D) getPoint
{
    return myPoint;
}

- (BOOL)isEqual:(id)anObject
{
    double delta = 0.00005;
    MyPoint *point = (MyPoint*) anObject;
    double deltaLatNeg = fabs(point->myPoint.latitude - myPoint.latitude);
    double deltaLongNeg = fabs(point->myPoint.longitude - myPoint.longitude);
    
    if(deltaLatNeg < delta && deltaLongNeg < delta)
    {
        return YES;
    }
    
    
    return NO;
}

@end

