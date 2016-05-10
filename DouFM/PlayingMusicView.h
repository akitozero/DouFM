//
//  PlayingMusicView.h
//  DouFM
//
//  Created by Pasco on 16/5/2.
//  Copyright © 2016年 Pasco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingMusicView : UIView

@property (strong, nonatomic) UIImageView *coverImageView;
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIButton *isLikeButton;
//@property (strong, nonatomic) UIButton *downloadButton;
@property (strong, nonatomic) UIButton *playStyleButton;
@property (strong, nonatomic) UIButton *previousButton;
@property (strong, nonatomic) UIButton *pasueButton;
@property (strong, nonatomic) UIButton *nextButton;
@property (strong, nonatomic) UIButton *shareButton;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *artistLabel;
@property (strong, nonatomic) UISlider *progressSlider;

@end
