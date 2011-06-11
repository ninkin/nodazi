//
//  AddNewRecordVIewController.h
//  Nodazi
//
//  Created by 항준 on 11. 6. 6..
//  Copyright 2011 서울대학교. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AddNewRecordVIewController : UIViewController {
    IBOutlet UIButton *buttonDate;
    UITextField *textPlace;
    
    UIButton *buttonStar1;
    UIButton *buttonStar2;
    UIButton *buttonStar3;
    UIButton *buttonStar4;
    UIButton *buttonStar5;
    int starRating;
}

@property (nonatomic, retain) IBOutlet UIButton *buttonDate;
@property (nonatomic, retain) UITextField *textPlace;
@property (nonatomic, retain) IBOutlet UIButton *buttonStar1;
@property (nonatomic, retain) IBOutlet UIButton *buttonStar2;
@property (nonatomic, retain) IBOutlet UIButton *buttonStar3;
@property (nonatomic, retain) IBOutlet UIButton *buttonStar4;
@property (nonatomic, retain) IBOutlet UIButton *buttonStar5;

- (IBAction)textPlaceReturn:(id)sender;
- (IBAction)backgroundTouched:(id)sender;
- (IBAction)star1Touched:(id)sender;
- (IBAction)star2Touched:(id)sender;
- (IBAction)star3Touched:(id)sender;
- (IBAction)star4Touched:(id)sender;
- (IBAction)star5Touched:(id)sender;

@end
