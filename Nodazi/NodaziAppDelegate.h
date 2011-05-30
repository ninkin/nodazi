//
//  NodaziAppDelegate.h
//  Nodazi
//
//  Created by 항준 on 11. 5. 26..
//  Copyright 2011 서울대학교. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NodaziAppDelegate : NSObject <UIApplicationDelegate, UITabBarControllerDelegate> {

    IBOutlet UINavigationController *navController;
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navController;
@property (nonatomic, retain) IBOutlet UITabBarController *tabBarController;
@end
