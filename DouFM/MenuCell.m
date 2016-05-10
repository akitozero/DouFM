//
//  MenuCell.m
//  DouFM
//
//  Created by Pasco on 16/5/9.
//  Copyright © 2016年 Pasco. All rights reserved.
//

#import "MenuCell.h"
#import <Masonry.h>

@interface MenuCell ()

@property (nonatomic, strong) UIView *foundationView;

@end

@implementation MenuCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        [self configureViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self configureSubviewsFrame];
}

- (void)configureViews {
    self.foundationView = [[UIView alloc] init];
    self.optionLabel = [[UILabel alloc] init];
    
    self.foundationView.backgroundColor = RGBA(255, 255, 255, 0.24);
    self.optionLabel.text = @"options";
    self.optionLabel.textAlignment = NSTextAlignmentCenter;
    
    [self.contentView addSubview:self.foundationView];
//    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.optionLabel];
}

- (void)configureSubviewsFrame {
    [self.foundationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(0);
        make.left.equalTo(self.contentView.mas_left).with.offset(0);
        make.right.equalTo(self.contentView.mas_right).with.offset(0);
        make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-1);
    }];
    
    [self.optionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.foundationView.mas_centerY).with.offset(0);
        make.left.equalTo(self.foundationView.mas_left).with.offset(50);
    }];
}

@end