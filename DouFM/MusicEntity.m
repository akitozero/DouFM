//
//  MusicEntity.m
//  DouFM
//
//  Created by Pasco on 16/4/30.
//  Copyright © 2016年 Pasco. All rights reserved.
//

#import "MusicEntity.h"

@implementation MusicEntity

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"publicTime" : @"public_time"
             };
}

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