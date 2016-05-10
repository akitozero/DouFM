//
//  ExploreTableViewController.h
//  DouFM
//
//  Created by Pasco on 16/4/30.
//  Copyright © 2016年 Pasco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuViewController.h"
@class PlayingMusicViewController;

@protocol CloseSideMenuDelegate <NSObject>

- (void)closeSideMenu;

@end

@interface ExploreTableViewController : UITableViewController <ChangePlaylistDelegate>

@property (strong, nonatomic) PlayingMusicViewController *playingMusicViewController;
@property (weak, nonatomic) id<CloseSideMenuDelegate> delegate;

- (void)changePlaylistTo:(NSIndexPath *)indexPath;

@end
