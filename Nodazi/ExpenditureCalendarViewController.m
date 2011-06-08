//
//  ExpenditureCalendarViewController.m
//  Nodazi
//
//  Created by 항준 on 11. 6. 8..
//  Copyright 2011 서울대학교. All rights reserved.
//

#import "ExpenditureCalendarViewController.h"
#import <QuartzCore/QuartzCore.h>


@implementation ExpenditureCalendarViewController

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
    
    NSUInteger count = 0;
    for (UIButton *button in calendarDays) {
        button.layer.borderColor = [UIColor grayColor].CGColor;
        button.layer.borderWidth = 0.5f;
        button.layer.cornerRadius = 0.0f;
        
        if(count++ < 25)
            button.backgroundColor = [UIColor colorWithRed:1.0f green:0.0f blue:0.0f alpha:(rand()%100*0.85f/100.0f)];
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
