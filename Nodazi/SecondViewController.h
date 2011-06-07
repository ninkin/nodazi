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
    UILabel *milkname;
    UILabel *milkqt;
}

@property (nonatomic, retain) IBOutlet UITextField *productField;
@property (nonatomic, retain) IBOutlet UITextField *numberField;
@property (nonatomic, retain) IBOutlet UILabel *milkname;
@property (nonatomic, retain) IBOutlet UILabel *milkqt;

- (IBAction)backgoundTouched:(id)sender;
- (IBAction)productFieldDoneEditing:(id)sender;
- (IBAction)findStorePushed:(id)sender;
- (IBAction)showFakeItem:(id)sender;
@end
