//
//  PlaceMarker.m
//  Nodazi
//
//  Created by STCube1 on 11. 6. 14..
//  Copyright 2011 서울대학교. All rights reserved.
//

#import "PlaceMarker.h"
#import <MapKit/MapKit.h>

@implementation PlaceMarker
@synthesize coordinate;
@synthesize title;
@synthesize subtitle;
- (CLLocationCoordinate2D)coordinate;
{
    return coordinate;
}
- (void)dealloc{
    [super dealloc];
    
}
- (NSString *)title
{
    return title;
}
- (NSString *)subtitle
{
    return subtitle;
}
@end
