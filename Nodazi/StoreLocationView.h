//
//  StoreLocationView.h
//  Nodazi
//
//  Created by STCube1 on 11. 6. 13..
//  Copyright 2011 서울대학교. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PlaceMarker.h"

@interface StoreLocationView : UIViewController {
    MKMapView *mapView;
    CLLocationCoordinate2D building302;
    CLLocationCoordinate2D gsmart;
    PlaceMarker *storePlace;
}
@property (nonatomic, retain) MKMapView *mapView;
@property (nonatomic) CLLocationCoordinate2D building302;
@property (nonatomic) CLLocationCoordinate2D gsmart;
@property (nonatomic, retain) PlaceMarker *storePlace;
@end
