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

@end
