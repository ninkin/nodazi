//
//  StoreLocationView.h
//  Nodazi
//
//  Created by STCube1 on 11. 6. 13..
//  Copyright 2011 서울대학교. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface StoreLocationView : UIViewController {
    MKMapView *mapView;
}
@property (nonatomic, retain) MKMapView *mapView;

@end
