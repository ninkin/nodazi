//
//  SettingStartUp.h
//  Nodazi
//
//  Created by STCube1 on 11. 6. 14..
//  Copyright 2011 서울대학교. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingStartUp : UIViewController
<UITableViewDelegate, UITableViewDataSource>
{
    NSArray *listStartup;
}

@property (nonatomic, retain) NSArray *listStartup;

@end
