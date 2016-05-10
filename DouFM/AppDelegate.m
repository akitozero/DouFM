//
//  AppDelegate.m
//  DouFM
//
//  Created by Pasco on 16/4/29.
//  Copyright © 2016年 Pasco. All rights reserved.
//

#import "AppDelegate.h"
#import "MusicEntity.h"
#import "RootViewController.h"
#import "TabBarViewController.h"
#import <FMDB.h>
#import <SVProgressHUD.h>
#import <AFNetworking.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [NSThread sleepForTimeInterval:0.1];
    //检查是不是第一次启动
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"HasLaunchedOnce"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        //创建数据库
        NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDir = [docPaths objectAtIndex:0];
        NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"DouFM.sqlite"];
        FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
        [database open];
        [database executeUpdate:@"CREATE TABLE favorite (id INTEGER PRIMARY KEY DEFAULT NULL,key TEXT DEFAULT NULL,title TEXT DEFAULT NULL,artist TEXT DEFAULT NULL,album TEXT DEFAULT NULL,company TEXT DEFAULT NULL,coverURL TEXT DEFAULT NULL,publicTime TEXT DEFAULT NULL,audioFileURL TEXT DEFAULT NULL)"];
        [database close];
        
        //设置歌曲播放顺序：顺序，单曲，随机
        [[NSUserDefaults standardUserDefaults] setInteger:PSCStyleInOrder forKey:@"playStyle"];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self customAppearance];
    self.window.rootViewController = [[RootViewController alloc] init];
    [self.window makeKeyAndVisible];
    return YES;
}


- (void)customAppearance {
    [UITabBar appearance].tintColor = HEXCOLOR(0xdf3031);
    [UITabBar appearance].barTintColor = HEXCOLOR(0xf5f5f5);
    
    [UINavigationBar appearance].tintColor = [UIColor blackColor];
    [UINavigationBar appearance].titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"themeColor"] forBarMetrics: UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[UIImage new]];
    
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [SVProgressHUD setMinimumDismissTimeInterval:1];
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
