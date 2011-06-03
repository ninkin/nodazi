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
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
}
- (IBAction)findStorePushed:(id)sender{
    PlannerMainView *plannerMain = [[PlannerMainView alloc  ]init];
    [self.navigationController pushViewController:plannerMain animated:YES];
    
}
- (IBAction)productFieldDoneEditing:(id)sender{
    [sender resignFirstResponder];
}

- (IBAction)backgoundTouched:(id)sender{
    [numberField resignFirstResponder];
    [productField resignFirstResponder];
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

@end
