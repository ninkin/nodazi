//
//  SecondViewController.m
//  Nodazi
//
//  Created by 항준 on 11. 5. 26..
//  Copyright 2011 서울대학교. All rights reserved.
//

#import "SecondViewController.h"
#import "PlannerMainView.h"

@implementation SecondViewController
@synthesize numberField;
@synthesize productField;
@synthesize listToBuy;
@synthesize tableToBuy;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    NSDictionary *item = [NSDictionary dictionaryWithObjectsAndKeys:@"Banana Pancake", @"Name", @"2", @"Qty", nil];
    NSMutableArray *marray = [NSMutableArray arrayWithObjects:item, nil];
    self.listToBuy = marray;
    
}

- (IBAction)findStorePushed:(id)sender{
    PlannerMainView *plannerMain = [[PlannerMainView alloc  ]init];
    plannerMain.title = @"Result";
    [self.navigationController pushViewController:plannerMain animated:YES];
    
}
- (IBAction)productFieldDoneEditing:(id)sender{
    [sender resignFirstResponder];
}

- (IBAction)backgoundTouched:(id)sender{
    [numberField resignFirstResponder];
    [productField resignFirstResponder];
}

- (IBAction)showFakeItem:(id)sender
{
    NSDictionary *item = [NSDictionary dictionaryWithObjectsAndKeys:
                          [productField text],
                          @"Name",
                          [numberField text],
                          @"Qty",
                          nil];
    [self.listToBuy addObject:item];
    [self.tableToBuy reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload
{
    [super viewDidUnload];

    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc
{
    [productField release];
    [numberField release];
    [super dealloc];
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
    return [self.listToBuy count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView 
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                       reuseIdentifier:cellIdentifier]
                autorelease];
    }
    
    NSUInteger row = [indexPath row];
    [cell.textLabel setText:[[self.listToBuy objectAtIndex:row] objectForKey:@"Name"]];
    [cell.detailTextLabel setText:[[self.listToBuy objectAtIndex:row] objectForKey:@"Qty"]];
    
    return cell;
}

@end
