//
//  SecondViewController.h
//  Nodazi
//
//  Created by 항준 on 11. 5. 26..
//  Copyright 2011 서울대학교. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SecondViewController : UIViewController
<UITableViewDelegate, UITableViewDataSource>
{
    UITextField *productField;
    UITextField *numberField;
    
    NSMutableArray *listToBuy;
    
    UITableView *tableToBuy;
}

@property (nonatomic, retain) IBOutlet UITextField *productField;
@property (nonatomic, retain) IBOutlet UITextField *numberField;
@property (nonatomic, retain) IBOutlet NSMutableArray *listToBuy;
@property (nonatomic, retain) IBOutlet UITableView *tableToBuy;

- (IBAction)backgoundTouched:(id)sender;
- (IBAction)productFieldDoneEditing:(id)sender;
- (IBAction)findStorePushed:(id)sender;
- (IBAction)showFakeItem:(id)sender;

@end
