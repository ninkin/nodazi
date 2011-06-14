//
//  ExpenditureCalendarViewController.m
//  Nodazi
//
//  Created by 항준 on 11. 6. 8..
//  Copyright 2011 서울대학교. All rights reserved.
//

#import "ExpenditureCalendarViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <sqlite3.h>
#import "NodaziAppDelegate.h"

@implementation ExpenditureCalendarViewController

@synthesize buttonYearMonth;
@synthesize calendarDays;

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
    
    basicDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY MMMM"];
    NSString *strYearMonth = [dateFormatter stringFromDate:basicDate];
    [buttonYearMonth setTitle:strYearMonth forState:UIControlStateNormal];
    
    NSCalendar *calendarCurrent = [NSCalendar currentCalendar];
    NSDateComponents *date = [calendarCurrent components: (NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit | NSWeekdayCalendarUnit) fromDate:basicDate];
    [date setDay:1];
    NSDate *firstDay = [calendarCurrent dateFromComponents:date];
    NSDateComponents *firstDayComponents = [calendarCurrent components:NSWeekdayCalendarUnit fromDate:firstDay];
    NSInteger offset = [firstDayComponents weekday];
    
    NSRange daysInMonth = [calendarCurrent rangeOfUnit:NSDayCalendarUnit inUnit:NSMonthCalendarUnit forDate:basicDate];
    
    for (UIButton *button in calendarDays)
    {
        if (button.tag < offset || button.tag >= offset + daysInMonth.length) {
            [button setHidden:YES];
        }
        else
        {
            [button setHidden:NO];
            
            button.layer.borderColor = [UIColor grayColor].CGColor;
            button.layer.borderWidth = 1.0f;
            button.layer.cornerRadius = 0.0f;
            
            NSString *query = [NSString stringWithFormat:@"SELECT sum(price * qty) FROM mytable WHERE year = %d AND month = %d AND day = %d", [date year], [date month], button.tag - offset + 1];
            sqlite3_stmt *statement;
            
            int sqlite3_err = sqlite3_prepare_v2([((NodaziAppDelegate *)[[UIApplication sharedApplication] delegate]) getDB], [query UTF8String], -1, &statement, NULL);
            
            double itemPrice;
            if(sqlite3_err == SQLITE_OK)
            {
                while (sqlite3_step(statement) == SQLITE_ROW) {
                    itemPrice = sqlite3_column_double(statement, 0);
                }
            }
            sqlite3_finalize(statement);
            
            button.backgroundColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f 
                                                     alpha:(itemPrice/300.0*0.85f/100.0f)];
        }
    }
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
