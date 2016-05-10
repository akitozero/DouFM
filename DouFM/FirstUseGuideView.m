//
//  FirstUseGuideView.m
//  DouFM
//
//  Created by Pasco on 16/5/11.
//  Copyright © 2016年 Pasco. All rights reserved.
//

#import "FirstUseGuideView.h"
#import <Masonry.h>

@interface FirstUseGuideView ()

@property (strong, nonatomic) UIImageView *guideImageView;
@property (strong, nonatomic) UIImageView *iKnowImageView;

@end

@implementation FirstUseGuideView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.5;
        [self configureSubviews];
    }
    return self;
}

- (void)layoutSubviews {
    [self configureSubviewsLayout];
}

- (void)configureSubviews {
    self.guideImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"guide"]];
    self.iKnowImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iknow"]];
    [self addSubview:self.guideImageView];
    [self addSubview:self.iKnowImageView];
    
}

- (void)configureSubviewsLayout {
    [self.guideImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY).with.offset(0);
        make.left.equalTo(self.mas_left).with.offset(0);
//        make.width.equalTo(@(250*kWidthScale));
//        make.height.equalTo(@(250*kWidthScale));
    }];
    
    [self.iKnowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).with.offset(-50);
        make.centerX.equalTo(self.mas_centerX).with.offset(0);
//        make.width.equalTo(@(250*kWidthScale));
//        make.height.equalTo(@(250*kWidthScale));
    }];
}

@end
