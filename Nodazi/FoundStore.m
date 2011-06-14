//
//  PlannerMainView.m
//  Nodazi
//
//  Created by STCube1 on 11. 5. 30..
//  Copyright 2011 서울대학교. All rights reserved.
//

#import "FoundStore.h"
#import "StoreLocationView.h"

@implementation FoundStore

@synthesize myMapView;

- (void)dealloc
{
    [myMapView release];
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
    
    [super viewDidLoad];
    myMapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    
    [NSThread detachNewThreadSelector:@selector(displayMYMap) toTarget:self withObject:nil];
    /*myMapView.showsUserLocation = FALSE;
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.2;
    span.longitudeDelta = 0.2;
    
    CLLocationCoordinate2D location = myMapView.userLocation.coordinate;
    
    location.latitude=37.514849;
    location.longitude = 126.954063;
    
    region.span = span;
    region.center = location;
    
    [myMapView setRegion:region animated:TRUE];
    [myMapView regionThatFits:region];
    */
    
    
     
    myMapView.delegate = self;
    
    //[self.view addSubview:myMapView];
    //[NSThread detachNewThreadSelector:@selector(displayMYMap) toTarget:self withObject:nil];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)displayMYMap{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    
    
    
    CLLocationCoordinate2D location = myMapView.userLocation.coordinate;
    
    location.latitude=37.477395;
    location.longitude = 126.959553;
    
    region.span = span;
    region.center = location;
    
    [myMapView setRegion:region animated:YES];
    [myMapView regionThatFits:region];
}

- (void)onClickMap:(id)sender{
    StoreLocationView *storeLocation = [[StoreLocationView alloc  ]init];
    storeLocation.title = @"Location";
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
