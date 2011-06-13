//
//  NodaziAppDelegate.m
//  Nodazi
//
//  Created by 항준 on 11. 5. 26..
//  Copyright 2011 서울대학교. All rights reserved.
//

#import "NodaziAppDelegate.h"


@implementation NodaziAppDelegate


@synthesize window=_window;
@synthesize navController;
@synthesize _expenseNavCtrlr = expenseNavCtrlr;
@synthesize tabBarController=_tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Add the tab bar controller's current view as a subview of the window
    self.window.rootViewController = self.tabBarController;
    //[self.window addSubview:_expenseNavCtrlr.view];
    [self.window makeKeyAndVisible];
    
    [self.tabBarController setSelectedIndex:2];
    
    // SQLite3
    // 어플리케이션 패스를 구한다
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"nodazi.db"];
    
    /* 데이터베이스를 오픈한다 */
    if(sqlite3_open([path UTF8String], &db) == SQLITE_OK) 
    {
        char *error = NULL;
        NSString *query = [NSString stringWithFormat:@"SELECT count(*) from mytable"];
        
        /* mytable을 쿼리해보고 오류가 있으면 mytable을 생성한다. */
        if (sqlite3_exec(db, [query UTF8String], NULL, 0, &error) != SQLITE_OK) {
            sqlite3_free(error);
            
            /* 테이블 생성 */
            if (sqlite3_exec(
                             db, 
                             "CREATE TABLE mytable ('year' INT not null, 'month' INT not null, 'day' INT not null, 'place' VARCHAR(255), 'name' VARCHAR(255), 'qty' INT, 'price' REAL not null)",
                             NULL, 
                             0, 
                             &error
                             ) != SQLITE_OK)
            {
                NSLog(@"TABLE CREATE ERROR: %s", error);
                sqlite3_free(error);
            }    
        }
    }
    else 
    {
        /* DB 오픈 에러 */
        sqlite3_close(db);
        db = NULL;
        
        NSLog(@"DB OPEN ERROR: '%s'", sqlite3_errmsg(db));    
    }

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
    if(db)
    {
        sqlite3_close(db);
    }

}

- (void)dealloc
{
    [_tabBarController release];
    [_expenseNavCtrlr release];
    [navController release];
    [_window release];
    [super dealloc];
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

- (sqlite3 *)getDB
{
    return db;
}

@end
