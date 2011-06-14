//
//  PlannerMainView.m
//  Nodazi
//
//  Created by STCube1 on 11. 5. 30..
//  Copyright 2011 서울대학교. All rights reserved.
//

#import "FoundStore.h"
#import "StoreLocationView.h"

#import "MKMapView+ZoomLevel.h"


@implementation FoundStore

@synthesize myMapView;
@synthesize gsmart;
@synthesize building302;
@synthesize storePlace;
@synthesize distance;
@synthesize shoppingitems;
@synthesize result;
- (void)dealloc
{
    [shoppingitems release];
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

- (void)viewDidLoad
{
    
    NSArray *shoppingkeys = [shoppingitems allKeys];
    
    NSString *itemnamesprices = [[NSString alloc] initWithFormat:@"Go to GS Mart. For "];
    
    
    for(int i = 0; i < [shoppingkeys count]; i++){
        
        itemnamesprices = [[NSString alloc] initWithFormat:@"%@ %@",itemnamesprices, [shoppingkeys objectAtIndex:i]];
    }
    itemnamesprices = [[NSString alloc] initWithFormat:@"%@.\n In Total: %d $.",itemnamesprices, rand()%50 ];
    [super viewDidLoad];

    [result setText:itemnamesprices];
    storePlace = [[PlaceMarker alloc] init];
    
    
    building302.latitude = 37.448671;
    building302.longitude = 126.952445;
    gsmart.latitude = 37.477395;
    gsmart.longitude = 126.959553;
        
    
    CLLocationDistance dist = [[[CLLocation alloc] initWithLatitude:building302.latitude longitude:building302.longitude] distanceFromLocation:[[CLLocation alloc] initWithLatitude:gsmart.latitude longitude:gsmart.longitude]];
    [distance setText:[NSString stringWithFormat:@"Distance : %dkm", (int)(dist/1000)]];
    
    
    storePlace.title = @"GS Mart";
    storePlace.subtitle = @"02)2039-8215";
    storePlace.coordinate = gsmart;
    
    
    [NSThread detachNewThreadSelector:@selector(displayMYMap) toTarget:self withObject:nil];
 
     
    myMapView.delegate = self;
    
    
    //최저가 정보들 저장
    quiznositems = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:7.7], @"baga-chickin",[NSNumber numberWithFloat:1.2], @"cola", [NSNumber numberWithFloat:3.0], @"today's soup", nil];
    gsmartitems = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:3.9], @"choco-pie", [NSNumber numberWithFloat:2.1], @"day milk" , nil];
    
}

- (void)displayMYMap{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.06;
    span.longitudeDelta = 0.06;
    
    CLLocationCoordinate2D location = myMapView.userLocation.coordinate;
    
    location.latitude= (building302.latitude + gsmart.latitude)/2;
    location.longitude = (building302.longitude + gsmart.longitude)/2;
    
    region.span = span;
    region.center = location;
    
    
    [myMapView addAnnotation:storePlace];
    [myMapView setRegion:region animated:YES];
    [myMapView regionThatFits:region];
}

- (void)onClickMap:(id)sender{
    
    StoreLocationView *storeLocation = [[StoreLocationView alloc  ]init];
    storeLocation.title = @"Location";
    
    storeLocation.gsmart = gsmart;
    storeLocation.building302 = building302;
    storeLocation.storePlace = storePlace;
    
    [self.navigationController pushViewController:storeLocation animated:YES];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //CLLocationCoordinate2D centerCoord = { GEORGIA_TECH_LATITUDE, GEORGIA_TECH_LONGITUDE };
    //[myMapView setCenterCoordinate:centerCoord zoomLevel:ZOOM_LEVEL animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

@end
