//
//  AboutCell.m
//  DouFM
//
//  Created by Pasco on 16/5/11.
//  Copyright © 2016年 Pasco. All rights reserved.
//

#import "AboutCell.h"
#import <Masonry.h>

@interface AboutCell ()

@property (nonatomic, strong) UIImageView *aboutImageView;

@end

@implementation AboutCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configureViews];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self configureSubviewsFrame];
}

- (void)configureViews {
    self.aboutImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about_image"]];
    [self.contentView addSubview:self.aboutImageView];
}

- (void)configureSubviewsFrame {
    [self.aboutImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(40);
        make.centerX.equalTo(self.contentView.mas_centerX).with.offset(0);
    }];
}

@end