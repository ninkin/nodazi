//
//  PlannerMainView.h
//  Nodazi
//
//  Created by STCube1 on 11. 5. 30..
//  Copyright 2011 서울대학교. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface FoundStore : UIViewController <MKMapViewDelegate> {
    IBOutlet MKMapView *myMapView;
}

@property (nonatomic, retain) IBOutlet MKMapView *myMapView;
- (void)displayMYMap;
- (IBAction)onClickMap:(id)sender;
@end
