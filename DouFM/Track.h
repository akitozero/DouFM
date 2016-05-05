//
//  Track.h
//  DouFM
//
//  Created by Pasco on 16/5/4.
//  Copyright © 2016年 Pasco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DOUAudioFile.h>

@interface Track : NSObject <DOUAudioFile>

@property (nonatomic, strong) NSURL *audioFileURL;
@property (nonatomic, strong) NSString *artist;
@property (nonatomic, strong) NSString *title;

@end
