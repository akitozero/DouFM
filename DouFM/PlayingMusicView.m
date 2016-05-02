//
//  PlayingMusicView.m
//  DouFM
//
//  Created by Pasco on 16/5/2.
//  Copyright © 2016年 Pasco. All rights reserved.
//

#import "PlayingMusicView.h"
#import <Masonry.h>

@implementation PlayingMusicView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
//        self.clipsToBounds = YES;
        [self configureSubviews];
    }
    return self;
}

- (void)layoutSubviews {
    [self configureSubviewsLayout];
}

- (void)configureSubviews {
    self.backgroundImageView = [[UIImageView alloc] init];
    self.coverImageView = [[UIImageView alloc] init];
    self.isLikeButton = [[UIButton alloc] init];
    self.downloadButton = [[UIButton alloc] init];
    self.playStyleButton = [[UIButton alloc] init];
    self.previousButton = [[UIButton alloc] init];
    self.pasueButton = [[UIButton alloc] init];
    self.nextButton = [[UIButton alloc] init];
    self.shareButton = [[UIButton alloc] init];
    
    self.titleLabel = [[UILabel alloc] init];
    self.artistLabel = [[UILabel alloc] init];
    
    self.progressSlider = [[UISlider alloc] init];
    
    //add views to self.view
    [self addSubview:self.backgroundImageView];
    [self addSubview:self.coverImageView];
    [self addSubview:self.isLikeButton];
    [self addSubview:self.downloadButton];
    [self addSubview:self.playStyleButton];
    [self addSubview:self.previousButton];
    [self addSubview:self.pasueButton];
    [self addSubview:self.nextButton];
    [self addSubview:self.shareButton];
    [self addSubview:self.titleLabel];
    [self addSubview:self.artistLabel];
    [self addSubview:self.progressSlider];
    
    //set
    UIImage *cover = [UIImage imageNamed:@"music_placeholder"];
    [self.coverImageView setContentMode:UIViewContentModeScaleAspectFill];
    self.coverImageView.clipsToBounds = YES;
    [self.coverImageView setImage:cover];
    //    self.coverImageView.layer.borderWidth = 1.0;
    //    self.coverImageView.layer.borderColor = [[UIColor redColor] CGColor];
    
    [self.backgroundImageView setContentMode:UIViewContentModeScaleToFill];
    [self.backgroundImageView setImage:cover];
    
    self.visualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    [self.backgroundImageView addSubview:self.visualEffectView];
    [self.backgroundImageView addSubview:self.visualEffectView];
    
    [self.isLikeButton setImage:[UIImage imageNamed:@"empty_heart"] forState:UIControlStateNormal];
    
    [self.downloadButton setImage:[UIImage imageNamed:@"download"] forState:UIControlStateNormal];
    
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
//    [self.titleLabel setText:self.musicEntity.title];
    [self.titleLabel setFont:kPlayingTitle];
    [self.titleLabel setTextColor:[UIColor whiteColor]];
    
    [self.artistLabel setTextAlignment:NSTextAlignmentCenter];
//    [self.artistLabel setText:self.musicEntity.artist];
    [self.artistLabel setFont:kPlayingArtist];
    [self.artistLabel setTextColor:[UIColor whiteColor]];
    
//    [self.progressSlider setMaximumValue:1.0];
//    [self.progressSlider setMinimumValue:0.0];
//    [self.progressSlider setValue:0.5];
    [self.progressSlider setThumbTintColor:HEXCOLOR(0xdf3031)];
    [self.progressSlider setMinimumTrackTintColor:HEXCOLOR(0xdf3031)];
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"music_slider_circle"] forState:UIControlStateHighlighted];
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"music_slider_circle"] forState:UIControlStateNormal];
    //    self.progressSlider.layer.borderColor = [[UIColor redColor] CGColor];
    //    self.progressSlider.layer.borderWidth = 1.0;
    
    [self.pasueButton setImage:[UIImage imageNamed:@"big_pause_button"] forState:UIControlStateNormal];
    
    [self.playStyleButton setImage:[UIImage imageNamed:@"loop_all_icon"] forState:UIControlStateNormal];
    
    [self.previousButton setImage:[UIImage imageNamed:@"prev_song"] forState:UIControlStateNormal];
    
    [self.nextButton setImage:[UIImage imageNamed:@"next_song"] forState:UIControlStateNormal];
    
    [self.shareButton setImage:[UIImage imageNamed:@"more_icon"] forState:UIControlStateNormal];
}

- (void)configureSubviewsLayout {
    [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top).with.offset(40);
        make.centerX.equalTo(self.mas_centerX).with.offset(0);
        make.width.equalTo(@250);
        make.height.equalTo(@250);
    }];
    
    UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).with.insets(padding);
    }];
    
    
    self.visualEffectView.frame = self.bounds;
    NSLog(@"%f---%f---%f---%f",self.frame.origin.x,self.frame.origin.y,self.frame.size.width,self.frame.size.height);
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.coverImageView.mas_bottom).with.offset(20);
        make.centerX.equalTo(self.mas_centerX).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.equalTo(@30);
    }];
    
    [self.artistLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(3);
        make.centerX.equalTo(self.mas_centerX).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(0);
        make.height.equalTo(@20);
    }];
    
    [self.isLikeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_top).with.offset(18);
        make.right.equalTo(self.mas_right).with.offset(-30);
    }];
    
    [self.downloadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_top).with.offset(18);
        make.left.equalTo(self.mas_left).with.offset(30);
    }];
    
    [self.progressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.artistLabel.mas_bottom).with.offset(10);
        make.left.equalTo(self.mas_left).with.offset(50);
        make.right.equalTo(self.mas_right).with.offset(-50);
        make.height.equalTo(@30);
        
    }];
    
    [self.pasueButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX).with.offset(0);
        make.bottom.equalTo(self.mas_bottom).with.offset(-20);
        
    }];
    
    [self.playStyleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.pasueButton.mas_centerY).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(20);
    }];
    
    [self.previousButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.pasueButton.mas_centerY).with.offset(0);
        make.right.equalTo(self.pasueButton.mas_left).with.offset(-30);
    }];
    
    [self.nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.pasueButton.mas_centerY).with.offset(0);
        make.left.equalTo(self.pasueButton.mas_right).with.offset(30);
    }];
    
    [self.shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.pasueButton.mas_centerY).with.offset(0);
        make.right.equalTo(self.mas_right).with.offset(-20);
    }];
    
}


@end
