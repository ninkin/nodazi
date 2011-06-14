//
//  SettingStartUp.m
//  Nodazi
//
//  Created by STCube1 on 11. 6. 14..
//  Copyright 2011 서울대학교. All rights reserved.
//

#import "SettingStartUp.h"
#import "SettingCell.h"

@implementation SettingStartUp
@synthesize listStartup;
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
    self.listStartup = [[[NSArray alloc] initWithObjects:@"Cemera", @"Planner", @"Expenditure", @"Settings", nil] autorelease];
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
- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
    return [self.listStartup count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *SettingCellIdentifier = @"SettingCellIdentifier";
    
    SettingCell *cell = (SettingCell *)[tableView
                                        dequeueReusableCellWithIdentifier:SettingCellIdentifier];
    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:[self.listStartup objectAtIndex:indexPath.row]
                                                     owner:self options:nil];
        for (id oneObject in nib) {
            if ([oneObject isKindOfClass: [SettingCell class]])
                cell = (SettingCell *) oneObject;
        }
    }
    
    return cell;
}


@end
