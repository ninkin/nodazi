//
//  ExpenseViewController.h
//  Nodazi
//
//  Created by 항준 on 11. 5. 26..
//  Copyright 2011 서울대학교. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddNewRecordVIewController.h"
#import "ExpenditureCalendarViewController.h"

@interface ExpenseViewController : UIViewController 
<UITableViewDelegate, UITableViewDataSource>
{
    UILabel *labelMonth;
    UILabel *labelDay;
    UILabel *labelTotalExpense;
    
    // for list of expenses
    NSArray *listExpenses;
    
    // for showing total expenses
    NSArray *listTotal;
    
    AddNewRecordVIewController *addNew;
    ExpenditureCalendarViewController *expCal;
}

@property (nonatomic, retain) IBOutlet UILabel *labelMonth;
@property (nonatomic, retain) IBOutlet UILabel *labelDay;
@property (nonatomic, retain) IBOutlet UILabel *labelTotalExpense;
@property (nonatomic, retain) NSArray *listExpenses;
@property (nonatomic, retain) NSArray *listTotal;
@property (nonatomic, retain) AddNewRecordVIewController *addNew;
@property (nonatomic, retain) ExpenditureCalendarViewController *expCal;

- (IBAction)buttonAddNewPressed:(id)sender;
- (IBAction)buttonCalendarPressed:(id)sender;

@end
