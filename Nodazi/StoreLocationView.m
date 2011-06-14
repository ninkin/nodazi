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
    
    [self.mapView.userLocation addObserver:self forKeyPath:@"location" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:NULL];
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    
    
    
    CLLocationCoordinate2D location = mapView.userLocation.coordinate;
    
    location.latitude=37.477395;
    location.longitude = 126.959553;
    
    region.span = span;
    region.center = location;
    
    
    [mapView setRegion:region animated:YES];
    [mapView regionThatFits:region];

    PlaceMarker *storePlace = [[PlaceMarker alloc] init];
    
    storePlace.title = @"GS Mart";
    storePlace.subtitle = @"02)2039-8215";
    CLLocationCoordinate2D coordi;
    coordi.latitude = 37.477006;
    coordi.longitude = 126.961366;
    storePlace.coordinate = coordi;
    
    [mapView addAnnotation:storePlace];
    mapView.showsUserLocation = YES;
    [self.view addSubview:mapView];
    
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    
    region.center = self.mapView.userLocation.coordinate;
    
    span.latitudeDelta = 1;
    span.longitudeDelta =1;
    region.span = span;
    
    [self.mapView setRegion:region animated:YES];

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
