//
//  PlannerMainView.h
//  Nodazi
//
//  Created by STCube1 on 11. 5. 30..
//  Copyright 2011 서울대학교. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "PlaceMarker.h"
#import <CoreLocation/CoreLocation.h>


@interface FoundStore : UIViewController <MKMapViewDelegate> {
    IBOutlet MKMapView *myMapView;
    CLLocationCoordinate2D building302;
    CLLocationCoordinate2D gsmart;
    IBOutlet UILabel *distance;
    PlaceMarker *storePlace;
    NSDictionary *quiznositems;
    NSDictionary *gsmartitems;
    NSMutableDictionary *shoppingitems;
}

@property (nonatomic, retain) IBOutlet MKMapView *myMapView;
@property (nonatomic) CLLocationCoordinate2D building302;
@property (nonatomic) CLLocationCoordinate2D gsmart;
@property (nonatomic, retain) PlaceMarker *storePlace;
@property (nonatomic, retain) IBOutlet UILabel *distance;
@property (nonatomic, retain) NSMutableDictionary *shoppingitems;
- (void)displayMYMap;
- (IBAction)onClickMap:(id)sender;
@end
