//
//  SettingCell.h
//  Nodazi
//
//  Created by 항준 on 11. 5. 26..
//  Copyright 2011 서울대학교. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingCell : UITableViewCell {
    UILabel *nameLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *nameLabel;

@end
