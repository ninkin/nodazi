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
    
}

@property (nonatomic, retain) IBOutlet UIButton *buttonDate;
@property (nonatomic, retain) UITextField *textPlace;

- (IBAction)textPlaceReturn:(id)sender;
- (IBAction)backgroundTouched:(id)sender;

@end
