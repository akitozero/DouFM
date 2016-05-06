//
//  AppDelegate.m
//  DouFM
//
//  Created by Pasco on 16/4/29.
//  Copyright © 2016年 Pasco. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "ExploreTableViewController.h"
#import "MyMusicTableViewController.h"
#import <FMDB.h>

@interface AppDelegate ()

@property (strong, nonatomic) UITabBarController *tabBarController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    //检查是不是第一次启动
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        NSLog(@"this is the first launch of DouFM");
        //创建数据库
        NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [docPaths objectAtIndex:0];
        NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"DouFM.sqlite"];
        FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        [database executeUpdate:@"CREATE TABLE favorite (id INTEGER PRIMARY KEY DEFAULT NULL,key TEXT DEFAULT NULL,title TEXT DEFAULT NULL,artist TEXT DEFAULT NULL,album TEXT DEFAULT NULL,company TEXT DEFAULT NULL,coverURL TEXT DEFAULT NULL,publicTime TEXT DEFAULT NULL,audioFileURL TEXT DEFAULT NULL)"];
        [database close];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self setupTabBarController];
    [self customAppearance];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)setupTabBarController {
    ExploreTableViewController *exploreViewController = [[ExploreTableViewController alloc] init];
    exploreViewController.tabBarItem.image = [[UIImage imageNamed:@"icon_tabbar_music"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    exploreViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_tabbar_music_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    exploreViewController.title = @"发现音乐";
    UINavigationController *exploreNavigationController = [[UINavigationController alloc] initWithRootViewController:exploreViewController];
    
    MyMusicTableViewController *myMusicViewController = [[MyMusicTableViewController alloc] init];
    myMusicViewController.tabBarItem.image = [[UIImage imageNamed:@"icon_tabbar_favorite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myMusicViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_tabbar_favorite_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    myMusicViewController.title = @"我的音乐";
    UINavigationController *myMusicNavigationController = [[UINavigationController alloc] initWithRootViewController:myMusicViewController];
    
    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.tabBar.translucent = NO;
    self.tabBarController.viewControllers = @[exploreNavigationController,myMusicNavigationController];
    
}

- (void)customAppearance {
    [UITabBar appearance].tintColor = HEXCOLOR(0xdf3031);
    [UITabBar appearance].barTintColor = HEXCOLOR(0xf5f5f5);
    
    [UINavigationBar appearance].tintColor = [UIColor blackColor];
//    [UINavigationBar appearance].barTintColor = HEXCOLOR(0xdf3031);
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"themeColor"] forBarMetrics: UIBarMetricsDefault];
    [[UINavigationBar appearance] setTranslucent:YES];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
//    self.navigationController.navigationBar.shadowImage = [UIImage new];
//    self.navigationController.navigationBar.translucent = YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
