//
//  SecondViewController.h
//  Nodazi
//
//  Created by 항준 on 11. 5. 26..
//  Copyright 2011 서울대학교. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SecondViewController : UIViewController {
    UITextField *productField;
    UITextField *numberField;
}

@property (nonatomic, retain) IBOutlet UITextField *productField;
@property (nonatomic, retain) IBOutlet UITextField *numberField;
- (IBAction)backgoundTouched:(id)sender;
- (IBAction)productFieldDoneEditing:(id)sender;
@end
