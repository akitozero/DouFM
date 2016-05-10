//
//  TabBarViewController.m
//  DouFM
//
//  Created by Pasco on 16/5/9.
//  Copyright © 2016年 Pasco. All rights reserved.
//

#import "TabBarViewController.h"
#import "ExploreTableViewController.h"
#import "MyMusicTableViewController.h"

@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.exploreViewController = [[ExploreTableViewController alloc] init];
    self.exploreViewController.tabBarItem.image = [[UIImage imageNamed:@"icon_tabbar_music"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.exploreViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_tabbar_music_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.exploreViewController.title = @"发现音乐";
    UINavigationController *exploreNavigationController = [[UINavigationController alloc] initWithRootViewController:self.exploreViewController];
    
    self.myMusicViewController = [[MyMusicTableViewController alloc] init];
    self.myMusicViewController.tabBarItem.image = [[UIImage imageNamed:@"icon_tabbar_favorite"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.myMusicViewController.tabBarItem.selectedImage = [[UIImage imageNamed:@"icon_tabbar_favorite_on"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.myMusicViewController.title = @"我的音乐";
    UINavigationController *myMusicNavigationController = [[UINavigationController alloc] initWithRootViewController:self.myMusicViewController];
    
    self.tabBar.translucent = NO;
    self.viewControllers = @[exploreNavigationController,myMusicNavigationController];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
