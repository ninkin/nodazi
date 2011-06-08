//
//  ExpenditureCalendarViewController.h
//  Nodazi
//
//  Created by 항준 on 11. 6. 8..
//  Copyright 2011 서울대학교. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ExpenditureCalendarViewController : UIViewController {
    NSArray *calendarDays;
}

@property (nonatomic, retain) IBOutletCollection(UIButton) NSArray *calendarDays;

@end
