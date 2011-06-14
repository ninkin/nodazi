//
//  StoreLocationView.m
//  Nodazi
//
//  Created by STCube1 on 11. 6. 13..
//  Copyright 2011 서울대학교. All rights reserved.
//

#import "StoreLocationView.h"
#import <MapKit/MapKit.h>
#import "PlaceMarker.h"

@implementation StoreLocationView
@synthesize mapView;
@synthesize gsmart;
@synthesize building302;
@synthesize storePlace;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [mapView release];
    [storePlace release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    
        
    [super viewDidLoad];
    mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    
    //CLLocationCoordinate2D building302 = mapView.userLocation.coordinate;
    //CLLocationCoordinate2D gsmart;
    CLLocationCoordinate2D middle;
    
    
    span.latitudeDelta = 2*fabs(gsmart.latitude - building302.latitude);
    span.longitudeDelta = 2*fabs(gsmart.longitude - building302.longitude);
    
    middle.latitude = (building302.latitude+gsmart.latitude)/2;
    middle.longitude = (building302.longitude+gsmart.longitude)/2;
    
    region.span = span;
    region.center = middle;
    
    //PlaceMarker *storePlace = [[PlaceMarker alloc] init];
    
    [mapView setRegion:region animated:YES];
    [mapView regionThatFits:region];

    
    [mapView addAnnotation:storePlace];
    mapView.showsUserLocation = YES;
    [self.view addSubview:mapView];
    
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
