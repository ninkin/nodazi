//
//  AddNewRecordVIewController.m
//  Nodazi
//
//  Created by 항준 on 11. 6. 6..
//  Copyright 2011 서울대학교. All rights reserved.
//

#import "AddNewRecordVIewController.h"
#import <sqlite3.h>
#import "NodaziAppDelegate.h"

@implementation AddNewRecordVIewController

@synthesize buttonDate;
@synthesize textPlace;
@synthesize buttonStar1;
@synthesize buttonStar2;
@synthesize buttonStar3;
@synthesize buttonStar4;
@synthesize buttonStar5;
@synthesize textItemName;
@synthesize textItemQty;
@synthesize textItemPrice;
@synthesize datePicker;
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
    
    starRating = 3; // default
    [buttonStar1 setImage:[UIImage imageNamed:@"star-4.png"] forState:UIControlStateNormal];
    [buttonStar2 setImage:[UIImage imageNamed:@"star-4.png"] forState:UIControlStateNormal];
    [buttonStar3 setImage:[UIImage imageNamed:@"star-4.png"] forState:UIControlStateNormal];
}
- (void)whenFieldTouched:(id)sender{
    [datePicker setHidden:FALSE];
}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void) viewDidAppear:(BOOL)animated
{
    NSDate *today = [(NodaziAppDelegate *)[[UIApplication sharedApplication] delegate] basicDate];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    strDate = [dateFormatter stringFromDate:today];
    
    [buttonDate setTitle:strDate forState:UIControlStateNormal];
    
    NSCalendar *calendarCurrent = [NSCalendar currentCalendar];
    NSDateComponents *date = [calendarCurrent components: (NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit) fromDate:today];
    day = [date day];
    month = [date month];
    year = [date year];
    NSDate *mydate = [[NSDate alloc] initWithTimeIntervalSinceNow:0];
    [datePicker setDate:mydate];
    
    int receipttype = (((NodaziAppDelegate *)[[UIApplication sharedApplication] delegate])).nReceiptType;
    (((NodaziAppDelegate *)[[UIApplication sharedApplication] delegate])).nReceiptType = 0;
    
    if (receipttype == 1)
    {
        [textPlace setText:@"GS Mart"];
        [textItemName setText:@"Choco-pie"];
        [textItemQty setText:@"1"];
        [textItemPrice setText:@"3.9"];
    }
    else if (receipttype == 2)
    {
        [textPlace setText:@"Quiznos"];
        [textItemName setText:@"Baga-chickin"];
        [textItemQty setText:@"10"];
        [textItemPrice setText:@"7.7"];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)textPlaceReturn:(id)sender
{
    [sender resignFirstResponder];
}

- (IBAction)backgroundTouched:(id)sender
{
#pragma mark - it doesn't work!
    [datePicker resignFirstResponder];
    [textItemName resignFirstResponder];
    [textItemPrice resignFirstResponder];
    [textItemQty resignFirstResponder];
    [datePicker setHidden:TRUE];
    [self.textPlace resignFirstResponder];
    
    NSDate *theday = [datePicker date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd"];
    strDate = [dateFormatter stringFromDate:theday];
    
    [buttonDate setTitle:strDate forState:UIControlStateNormal];

    NSCalendar *calendarCurrent = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendarCurrent components: (NSMonthCalendarUnit | NSDayCalendarUnit | NSYearCalendarUnit) fromDate:theday];
    year = [components year];
    month = [components month];
    day = [components day];
}

- (IBAction)star1Touched:(id)sender
{
    if(starRating > 0)
    {
        // OFF
        [buttonStar1 setImage:[UIImage imageNamed:@"star-0.png"] forState:UIControlStateNormal];
        [buttonStar2 setImage:[UIImage imageNamed:@"star-0.png"] forState:UIControlStateNormal];
        [buttonStar3 setImage:[UIImage imageNamed:@"star-0.png"] forState:UIControlStateNormal];
        [buttonStar4 setImage:[UIImage imageNamed:@"star-0.png"] forState:UIControlStateNormal];
        [buttonStar5 setImage:[UIImage imageNamed:@"star-0.png"] forState:UIControlStateNormal];
        starRating = 0;
    }
    else
    {
        // ON: 1
        [buttonStar1 setImage:[UIImage imageNamed:@"star-4.png"] forState:UIControlStateNormal];
        starRating = 1;
    }
}

- (IBAction)star2Touched:(id)sender
{
    if(starRating > 1)
    {
        // OFF
        [buttonStar1 setImage:[UIImage imageNamed:@"star-4.png"] forState:UIControlStateNormal];
        [buttonStar2 setImage:[UIImage imageNamed:@"star-0.png"] forState:UIControlStateNormal];
        [buttonStar3 setImage:[UIImage imageNamed:@"star-0.png"] forState:UIControlStateNormal];
        [buttonStar4 setImage:[UIImage imageNamed:@"star-0.png"] forState:UIControlStateNormal];
        [buttonStar5 setImage:[UIImage imageNamed:@"star-0.png"] forState:UIControlStateNormal];
        starRating = 1;
    }
    else
    {
        // ON: 2
        [buttonStar1 setImage:[UIImage imageNamed:@"star-4.png"] forState:UIControlStateNormal];
        [buttonStar2 setImage:[UIImage imageNamed:@"star-4.png"] forState:UIControlStateNormal];
        starRating = 2;
    }
}

- (IBAction)star3Touched:(id)sender
{
    if(starRating > 2)
    {
        // OFF
        [buttonStar1 setImage:[UIImage imageNamed:@"star-4.png"] forState:UIControlStateNormal];
        [buttonStar2 setImage:[UIImage imageNamed:@"star-4.png"] forState:UIControlStateNormal];
        [buttonStar3 setImage:[UIImage imageNamed:@"star-0.png"] forState:UIControlStateNormal];
        [buttonStar4 setImage:[UIImage imageNamed:@"star-0.png"] forState:UIControlStateNormal];
        [buttonStar5 setImage:[UIImage imageNamed:@"star-0.png"] forState:UIControlStateNormal];
        starRating = 2;
    }
    else
    {
        // ON: 3
        [buttonStar1 setImage:[UIImage imageNamed:@"star-4.png"] forState:UIControlStateNormal];
        [buttonStar2 setImage:[UIImage imageNamed:@"star-4.png"] forState:UIControlStateNormal];
        [buttonStar3 setImage:[UIImage imageNamed:@"star-4.png"] forState:UIControlStateNormal];
        starRating = 3;
    }
}

- (IBAction)star4Touched:(id)sender
{
    if(starRating > 3)
    {
        // OFF
        [buttonStar1 setImage:[UIImage imageNamed:@"star-4.png"] forState:UIControlStateNormal];
        [buttonStar2 setImage:[UIImage imageNamed:@"star-4.png"] forState:UIControlStateNormal];
        [buttonStar3 setImage:[UIImage imageNamed:@"star-4.png"] forState:UIControlStateNormal];
        [buttonStar4 setImage:[UIImage imageNamed:@"star-0.png"] forState:UIControlStateNormal];
        [buttonStar5 setImage:[UIImage imageNamed:@"star-0.png"] forState:UIControlStateNormal];
        starRating = 3;
    }
    else
    {
        // ON: 4
        [buttonStar1 setImage:[UIImage imageNamed:@"star-4.png"] forState:UIControlStateNormal];
        [buttonStar2 setImage:[UIImage imageNamed:@"star-4.png"] forState:UIControlStateNormal];
        [buttonStar3 setImage:[UIImage imageNamed:@"star-4.png"] forState:UIControlStateNormal];
        [buttonStar4 setImage:[UIImage imageNamed:@"star-4.png"] forState:UIControlStateNormal];
        starRating = 4;
    }
}

- (IBAction)star5Touched:(id)sender
{
    if(starRating > 4)
    {
        // OFF
        [buttonStar1 setImage:[UIImage imageNamed:@"star-4.png"] forState:UIControlStateNormal];
        [buttonStar2 setImage:[UIImage imageNamed:@"star-4.png"] forState:UIControlStateNormal];
        [buttonStar3 setImage:[UIImage imageNamed:@"star-4.png"] forState:UIControlStateNormal];
        [buttonStar4 setImage:[UIImage imageNamed:@"star-4.png"] forState:UIControlStateNormal];
        [buttonStar5 setImage:[UIImage imageNamed:@"star-0.png"] forState:UIControlStateNormal];
        starRating = 4;
    }
    else
    {
        // ON: 1
        [buttonStar1 setImage:[UIImage imageNamed:@"star-4.png"] forState:UIControlStateNormal];
        [buttonStar2 setImage:[UIImage imageNamed:@"star-4.png"] forState:UIControlStateNormal];
        [buttonStar3 setImage:[UIImage imageNamed:@"star-4.png"] forState:UIControlStateNormal];
        [buttonStar4 setImage:[UIImage imageNamed:@"star-4.png"] forState:UIControlStateNormal];
        [buttonStar5 setImage:[UIImage imageNamed:@"star-4.png"] forState:UIControlStateNormal];
        starRating = 5;
    }
}

- (IBAction)buttonAddTouched:(id)sender
{
    NSString *itemName = [textItemName text];
    NSString *itemQty = [textItemQty text];
    NSString *itemPrice = [textItemPrice text];
    
    char *error = NULL;
    
    /* 사용자가 입력한 값을 DB에 추가한다 */
    NSString *query = [NSString stringWithFormat:@"INSERT INTO mytable VALUES (%d, %d, %d, '%@', '%@', %d, %f)", year, month, day, [textPlace text], itemName, [itemQty intValue], [itemPrice floatValue]];
    int err = sqlite3_exec([((NodaziAppDelegate *)[[UIApplication sharedApplication] delegate]) getDB], [query UTF8String], NULL, NULL, &error);
    
    if (err != 0) {
        NSLog(@"sqlite3_exec error(%d).", err);
    }
}

@end
