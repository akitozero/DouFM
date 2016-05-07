//
//  MusicListCell.m
//  DouFM
//
//  Created by Pasco on 16/4/29.
//  Copyright © 2016年 Pasco. All rights reserved.
//

#import "MusicListCell.h"
#import <Masonry.h>

@implementation MusicListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = HEXCOLOR(0xfbfcfd);
        [self configureSubViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self configureSubViewsFrame];
}

- (void)configureSubViews {
    
    self.numberLabel = [[UILabel alloc] init];
    self.titleLabel = [[UILabel alloc] init];
    self.artistLabel = [[UILabel alloc] init];
    self.playingImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"playing"]];
    
    [self.numberLabel setFont:kNumberFont];
    [self.titleLabel setFont:kTitleFont];
    [self.artistLabel setFont:kArtistFont];
    
    [self.numberLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self.numberLabel setTextColor:HEXCOLOR(0x999999)];
    [self.titleLabel setTextColor:HEXCOLOR(0x333333)];
    [self.artistLabel setTextColor:HEXCOLOR(0x999999)];
    
    [self.contentView addSubview:self.numberLabel];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.artistLabel];
    [self.contentView addSubview:self.playingImageView];
}

- (void)configureSubViewsFrame {
    UIView *superView = self.contentView;
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).with.offset(0);
        make.left.equalTo(superView.mas_left).with.offset(0);
        make.width.equalTo(@(40*kWidthScale));
        make.bottom.equalTo(superView.mas_bottom).with.offset(0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).with.offset(10*kHeightScale);
        make.left.equalTo(self.numberLabel.mas_right).with.offset(0);
        make.right.equalTo(superView.mas_right).with.offset(0);
        make.height.equalTo(@(20*kHeightScale));
    }];
    
    [self.artistLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).with.offset(0);
        make.left.equalTo(self.numberLabel.mas_right).with.offset(0);
        make.right.equalTo(superView.mas_right).with.offset(0);
        make.bottom.equalTo(superView.mas_bottom).with.offset(-9*kHeightScale);
    }];
    
    [self.playingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(superView.mas_centerY).with.offset(0);
        make.right.equalTo(superView.mas_right).with.offset(-10*kWidthScale);
        make.width.equalTo(@(20*kWidthScale));
        
    }];
}


@end
