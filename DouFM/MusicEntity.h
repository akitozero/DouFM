//
//  MusicEntity.h
//  DouFM
//
//  Created by Pasco on 16/4/30.
//  Copyright © 2016年 Pasco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DOUAudioFile.h>

//设置歌曲播放顺序：顺序，单曲，随机
typedef NS_ENUM(NSUInteger, playStyle) {
    PSCStyleInOrder,
    PSCStyleSingleCycle,
    PSCStyleRandom,
};

typedef NS_ENUM(NSInteger, fromTabbarItem) {
    PSCItemExplore,
    PSCItemRecommand,
    PSCItemFavorite,
};

@interface MusicEntity : NSObject <DOUAudioFile>

@property (strong, nonatomic) NSString *album;
@property (assign, nonatomic) BOOL isFavorite;
@property (strong, nonatomic) NSString *artist;
@property (strong, nonatomic) NSURL *audioFileURL;
@property (strong, nonatomic) NSString *company;
@property (strong, nonatomic) NSURL *cover;
@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *publicTime;
@property (strong, nonatomic) NSString *title;
//
//+ (NSDictionary *)modelCustomPropertyMapper;
//
@end

//"album": "掌心",
//"artist": "无印良品",
//"audio": "/api/fs/52fd7ea51d41c82a2e66d0e8/",
//"company": "滚石",
//"cover": "/api/fs/52fd7ea51d41c82a2e66d0e6/",
//"kbps": "64",
//"key": "52fd7eab1d41c82a2e66d0f0",
//"public_time": "1996",
//"title": "等你的心",
//"upload_date": "Fri, 14 Feb 2014 10:25:47 -0000"