//
//  ExpenseViewController.m
//  Nodazi
//
//  Created by 항준 on 11. 5. 26..
//  Copyright 2011 서울대학교. All rights reserved.
//

#import "ExpenseViewController.h"
#import "NodaziAppDelegate.h"


@implementation ExpenseViewController

@synthesize labelMonth;
@synthesize labelDay;
@synthesize labelTotalExpense;
@synthesize labelTotalDay;
@synthesize listExpenses;
@synthesize listTotal;
@synthesize tableBuyRecord;
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
    basicDate = [NSDate date];
    date = [calendarCurrent components: (NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit) fromDate:basicDate];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM"];
    NSString *strMonth = [dateFormatter stringFromDate:basicDate];
    
    NSString *strDay = [NSString stringWithFormat:@"%ld", [date day]]; 

    [labelMonth setText:strMonth];
    [labelDay setText:strDay];
    
    // Monthly expense
    NSString *query = [NSString stringWithFormat:@"SELECT sum(qty * price) FROM mytable WHERE year = %d AND month = %d", [date year], [date month]];
    sqlite3_stmt *statement;
    double monthlyTotal = 0.0;
    
    int sqlite3_err = sqlite3_prepare_v2([((NodaziAppDelegate *)[[UIApplication sharedApplication] delegate]) getDB], [query UTF8String], -1, &statement, NULL);
    
    if(sqlite3_err == SQLITE_OK)
    {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            monthlyTotal = sqlite3_column_double(statement, 0);
        }
    }
    sqlite3_finalize(statement);
    
    NSString *monthly = [NSString stringWithFormat:@"$%.2f", monthlyTotal];
    labelTotalExpense.text = monthly;
    
    // Buy record
    self.listExpenses = [[NSMutableArray alloc]initWithCapacity:10];
    
    NSString *query2 = [NSString stringWithFormat:@"SELECT name, qty, price FROM mytable WHERE year = %d AND month = %d AND day = %d", [date year], [date month], [date day]];
    sqlite3_stmt *statement2;
    
    double dTotalDay = 0.0;
    
    sqlite3_err = sqlite3_prepare_v2([((NodaziAppDelegate *)[[UIApplication sharedApplication] delegate]) getDB], [query2 UTF8String], -1, &statement2, NULL);
    
    if(sqlite3_err == SQLITE_OK)
    {
        while (sqlite3_step(statement2) == SQLITE_ROW) {
            NSString *itemName = [[NSString alloc] initWithUTF8String:(char *)sqlite3_column_text(statement2, 0)];
            int itemQty = sqlite3_column_int(statement2, 1);
            double itemPrice = sqlite3_column_double(statement2, 2);
            
            dTotalDay += itemQty * itemPrice;
            
            NSDictionary *item = [NSDictionary dictionaryWithObjectsAndKeys:
                                  itemName, @"Name",
                                  [NSString stringWithFormat:@"%i", itemQty], @"Qty", 
                                  [NSString stringWithFormat:@"%.2f", itemPrice], @"Price", 
                                  nil];
            
            [self.listExpenses addObject:item];
        }
    }
    sqlite3_finalize(statement2);
    
    NSString *totalDay = [NSString stringWithFormat:@"Today's expenditure: $%.2f", dTotalDay];
    labelTotalDay.text = totalDay;
    [totalDay release];
    
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
    [cell.textLabel setText:
                              ([[[self.listExpenses objectAtIndex:row] objectForKey:@"Name"] substringToIndex:15])
    ];
    [cell.textLabel setFont:[UIFont fontWithName:@"Helvetica" size:14]];
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
