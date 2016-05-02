//
//  PlayingMusicViewController.m
//  DouFM
//
//  Created by Pasco on 16/5/1.
//  Copyright © 2016年 Pasco. All rights reserved.
//

#import "PlayingMusicViewController.h"
#import "PlayingMusicView.h"
#import "MusicEntity.h"
#import <Masonry.h>
#import <SDWebImage/UIImageView+WebCache.h>

@interface PlayingMusicViewController ()

@end

@implementation PlayingMusicViewController

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[super alloc] initPrivate];
    });
    return sharedInstance;
}

- (instancetype)init {
    @throw [NSException exceptionWithName:@"singleTon" reason:@"This is a singleton,please use sharedInstance instead." userInfo:nil];
}

- (instancetype)initPrivate {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad");
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
//    self.view.clipsToBounds = YES;
    
    self.playingMusicView = [[PlayingMusicView alloc] init];
    [self.view addSubview:self.playingMusicView];
    [self configureClickEvent];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self configureDatas];
}

- (void)viewDidLayoutSubviews {
    NSLog(@"viewDidLayoutSubviews");
    UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.playingMusicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(padding);
    }];
}

- (void)configureDatas {
    NSLog(@"%@",self.musicEntity.title);
    self.playingMusicView.titleLabel.text = self.musicEntity.title;
    self.playingMusicView.artistLabel.text = self.musicEntity.artist;
    NSString *coverURLString = [NSString stringWithFormat:@"%@%@",APIBaseURL,self.musicEntity.cover];
//    UIImage *placeHolderImage = [UIImage imageNamed:@"music_placeholder"];
    
    [UIView transitionWithView:self.playingMusicView.coverImageView
                      duration:1.0f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self.playingMusicView.coverImageView sd_setImageWithURL:[NSURL URLWithString:coverURLString]];
                    }
                    completion:nil];
    
    [UIView transitionWithView:self.playingMusicView.backgroundImageView
                      duration:1.0f
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        [self.playingMusicView.backgroundImageView sd_setImageWithURL:[NSURL URLWithString:coverURLString]];
                    }
                    completion:nil];
}

- (void)configureClickEvent {
    [self.playingMusicView.isLikeButton addTarget:self action:@selector(isLikeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.playingMusicView.downloadButton addTarget:self action:@selector(downloadButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.playingMusicView.playStyleButton addTarget:self action:@selector(playStyleButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.playingMusicView.previousButton addTarget:self action:@selector(previousButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.playingMusicView.pasueButton addTarget:self action:@selector(pasueButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.playingMusicView.nextButton addTarget:self action:@selector(nextButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.playingMusicView.shareButton addTarget:self action:@selector(shareButtonClicked) forControlEvents:UIControlEventTouchUpInside];
}

//@property (strong, nonatomic) UIButton *isLikeButton;
//@property (strong, nonatomic) UIButton *downloadButton;
//@property (strong, nonatomic) UIButton *playStyleButton;
//@property (strong, nonatomic) UIButton *previousButton;
//@property (strong, nonatomic) UIButton *pasueButton;
//@property (strong, nonatomic) UIButton *nextButton;
//@property (strong, nonatomic) UIButton *shareButton;

- (void)isLikeButtonClicked {
    NSLog(@"isLikeButtonClicked");
}

- (void)downloadButtonClicked {
    NSLog(@"downloadButtonClicked");
}

- (void)playStyleButtonClicked {
    NSLog(@"playStyleButtonClicked");
}

- (void)previousButtonClicked {
    NSLog(@"previousButtonClicked");
}

- (void)pasueButtonClicked {
    NSLog(@"pasueButtonClicked");
}

- (void)nextButtonClicked {
    NSLog(@"nextButtonClicked");
}

- (void)shareButtonClicked {
    NSLog(@"shareButtonClicked");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end











