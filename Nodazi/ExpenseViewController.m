//
//  ExpenseViewController.m
//  Nodazi
//
//  Created by 항준 on 11. 5. 26..
//  Copyright 2011 서울대학교. All rights reserved.
//

#import "ExpenseViewController.h"


@implementation ExpenseViewController

@synthesize labelMonth;
@synthesize labelDay;
@synthesize labelTotalExpense;
@synthesize listExpenses;
@synthesize listTotal;
@synthesize addNew;
@synthesize expCal;

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
    
    [labelMonth release];
    [labelDay release];
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
    // Do any additional setup after loading the view from its nib.
    
    NSCalendar *calendarCurrent = [NSCalendar currentCalendar];
    NSDate *today = [NSDate date];
    NSDateComponents *date = [calendarCurrent components: (NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:today];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM"];
    NSString *strMonth = [dateFormatter stringFromDate:today];
    
    NSInteger day = [date day];
    NSString *strDay = [NSString stringWithFormat:@"%ld", day]; 

    [labelMonth setText:strMonth];
    [labelDay setText:strDay];
    
    //
    NSDictionary *item1 = [NSDictionary dictionaryWithObjectsAndKeys:@"Baja Chicken Sandwich", @"Name", @"1", @"Qty", @"$6.99", @"Price", nil];
    NSDictionary *item2 = [NSDictionary dictionaryWithObjectsAndKeys:@"Dige Sand", @"Name", @"2", @"Qty", @"$1.49", @"Price", nil];
    NSDictionary *item3 = [NSDictionary dictionaryWithObjectsAndKeys:@"Banana Pancake", @"Name", @"1", @"Qty", @"$2.99", @"Price", nil];
    NSMutableArray *marray = [NSMutableArray arrayWithObjects:item1, item2, item3, nil];
    self.listExpenses = marray;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [[labelMonth text] release];
    [[labelDay text] release];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (NSInteger)tableView:(UITableView *)tableView 
 numberOfRowsInSection:(NSInteger)section
{
    return [self.listExpenses count];
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
    [cell.textLabel setText:[[self.listExpenses objectAtIndex:row] objectForKey:@"Name"]];
    NSString *price = [[self.listExpenses objectAtIndex:row] objectForKey:@"Price"];
    NSString *qty = [[self.listExpenses objectAtIndex:row] objectForKey:@"Qty"];
    NSString *total = [NSString stringWithFormat:@"%@*%@", qty, price];
    [cell.detailTextLabel setText:total];
    
    return cell;
}

- (IBAction)buttonAddNewPressed:(id)sender
{
    if (self.addNew == nil) {
        AddNewRecordVIewController *newCtrlr = [[AddNewRecordVIewController alloc] initWithNibName:@"AddNewRecordView" bundle:[NSBundle mainBundle]];
        newCtrlr.title = @"Add New Record";
        self.addNew = newCtrlr;
    }
    
    [self.navigationController pushViewController:addNew animated:YES];
}

- (IBAction)buttonCalendarPressed:(id)sender
{
    if (self.expCal == nil) {
        ExpenditureCalendarViewController *newCtrlr = [[ExpenditureCalendarViewController alloc] initWithNibName:@"ExpenditureCalendarView" bundle:[NSBundle mainBundle]];
        newCtrlr.title = @"Calendar";
        self.expCal = newCtrlr;
    }
    
    [self.navigationController pushViewController:expCal animated:YES];
}

@end
