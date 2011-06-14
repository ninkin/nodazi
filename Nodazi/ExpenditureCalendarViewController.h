//
//  ExpenditureCalendarViewController.h
//  Nodazi
//
//  Created by 항준 on 11. 6. 8..
//  Copyright 2011 서울대학교. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ExpenditureCalendarViewController : UIViewController {    
    NSDateComponents *basicDateComponents;
    int startingDayOffset;
    int selectedDay;
    UIButton *buttonSelectedDay;
    NSMutableDictionary *dailyExpenditure;
    
    UIButton *buttonYearMonth;
    NSArray *calendarDays;
}

@property (nonatomic, retain) IBOutlet UIButton *buttonYearMonth;
@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *calendarDays;
@property (nonatomic, assign) int selectedDay;

- (IBAction)buttonDayTouched:(id)sender;

@end
