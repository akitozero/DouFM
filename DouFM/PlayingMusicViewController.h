//
//  PlayingMusicViewController.h
//  DouFM
//
//  Created by Pasco on 16/5/1.
//  Copyright © 2016年 Pasco. All rights reserved.
//
#import <UIKit/UIKit.h>
@class MusicEntity;
@class PlayingMusicView;

@interface PlayingMusicViewController : UIViewController

@property (copy, nonatomic) NSArray *musicEntityArray;
@property (assign, nonatomic) NSInteger currentTrackIndex;
@property (strong, nonatomic) NSString *musicKey;
@property (strong, nonatomic) PlayingMusicView *playingMusicView;
@property (assign, nonatomic) NSInteger playStyle;
@property (assign, nonatomic) NSInteger fromTabbarItem;

+ (instancetype)sharedInstance;

@end
