//
//  TabBarViewController.h
//  DouFM
//
//  Created by Pasco on 16/5/9.
//  Copyright © 2016年 Pasco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
@class ExploreTableViewController;
@class MyMusicTableViewController;

@interface TabBarViewController : UITabBarController

@property (strong, nonatomic) ExploreTableViewController<ChangePlaylistDelegate> *exploreViewController;
@property (strong, nonatomic) MyMusicTableViewController *myMusicViewController;

@end
