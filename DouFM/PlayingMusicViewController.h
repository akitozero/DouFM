//
//  PlayingMusicViewController.h
//  DouFM
//
//  Created by Pasco on 16/5/1.
//  Copyright © 2016年 Pasco. All rights reserved.
//

#import "ViewController.h"
@class MusicEntity;
@class PlayingMusicView;

@interface PlayingMusicViewController : UIViewController

@property (copy, nonatomic) NSArray *musicEntityArray;
@property (assign, nonatomic) NSInteger currentTrackIndex;
@property (strong, nonatomic) PlayingMusicView *playingMusicView;
//@property (strong, nonatomic) MusicEntity *musicEntity;

+ (instancetype)sharedInstance;

@end
