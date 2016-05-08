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
#import <SDWebImagePrefetcher.h>
#import <DOUAudioStreamer.h>
#import <DOUAudioVisualizer.h>
#import <FMDB.h>

static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;

@interface PlayingMusicViewController ()

@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) DOUAudioStreamer *streamer;
@property (strong, nonatomic) UIVisualEffectView *visualEffectView;

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
        //给一个初始值，防止默认为0，影响后续的判断：第一次进入，点击第0个歌曲后没有播放的icon 
        _currentTrackIndex = -1;
        _fromTabbarItem = -1;
    }
    return self;
}

- (void)viewDidLoad {
    NSLog(@"viewDidLoad");
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
//    self.view.clipsToBounds = YES;
    
    self.playingMusicView = [[PlayingMusicView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.playingMusicView];
    [self configureClickEvent];
    [self configureDatas];
    [self _resetStreamer];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(_timerAction:) userInfo:nil repeats:YES];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_timer invalidate];
//    [_streamer stop];
//    [self _cancelStreamer];
    
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"themeColor"] forBarMetrics:UIBarMetricsDefault];
}

- (void)_cancelStreamer
{
    if (_streamer != nil) {
        [_streamer pause];
        [_streamer removeObserver:self forKeyPath:@"status"];
        [_streamer removeObserver:self forKeyPath:@"duration"];
        _streamer = nil;
    }
}

- (void)_resetStreamer
{
    [self _cancelStreamer];
    MusicEntity *musicEntity = [self.musicEntityArray objectAtIndex:self.currentTrackIndex];
    
    _streamer = [DOUAudioStreamer streamerWithAudioFile:musicEntity];
    [_streamer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
    [_streamer addObserver:self forKeyPath:@"duration" options:NSKeyValueObservingOptionNew context:kDurationKVOKey];
    
    [_streamer play];
    
    [self _setupHintForStreamer];
}

- (void)_setupHintForStreamer
{
    NSUInteger nextIndex = self.currentTrackIndex + 1;
    if (nextIndex >= [self.musicEntityArray count]) {
        nextIndex = 0;
    }
    
    [DOUAudioStreamer setHintWithAudioFile:[self.musicEntityArray objectAtIndex:nextIndex]];
}

- (void)_timerAction:(id)timer
{
    if ([_streamer duration] == 0.0) {
        [self.playingMusicView.progressSlider setValue:0.0f animated:NO];
    }
    else {
        [self.playingMusicView.progressSlider setValue:[_streamer currentTime] / [_streamer duration] animated:YES];
    }
}

- (void)_updateStatus
{
    NSLog(@"_updateStatus");
    switch ([_streamer status]) {
        case DOUAudioStreamerPlaying:
            NSLog(@"DOUAudioStreamerPlaying");
            [self.playingMusicView.pasueButton setImage:[UIImage imageNamed:@"big_pause_button"] forState:UIControlStateNormal];
            break;
            
        case DOUAudioStreamerPaused:
            NSLog(@"DOUAudioStreamerPaused");
            [self.playingMusicView.pasueButton setImage:[UIImage imageNamed:@"big_play_button"] forState:UIControlStateNormal];
            break;
            
        case DOUAudioStreamerIdle:
            NSLog(@"DOUAudioStreamerIdle");
            [self.playingMusicView.pasueButton setImage:[UIImage imageNamed:@"big_play_button"] forState:UIControlStateNormal];
            break;
            
        case DOUAudioStreamerFinished:
            NSLog(@"DOUAudioStreamerFinished");
            if (self.playStyle == PSCStyleSingleCycle) {
                [self actionSingleCycle];
            }else {
                [self.playingMusicView.nextButton sendActionsForControlEvents:UIControlEventTouchUpInside];
            }
            
            break;
            
        case DOUAudioStreamerBuffering:
            NSLog(@"DOUAudioStreamerBuffering");
            break;
            
        case DOUAudioStreamerError:
            NSLog(@"DOUAudioStreamerError");
            break;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kStatusKVOKey) {
        [self performSelector:@selector(_updateStatus)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else if (context == kDurationKVOKey) {
        [self performSelector:@selector(_timerAction:)
                     onThread:[NSThread mainThread]
                   withObject:nil
                waitUntilDone:NO];
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

- (void)viewDidLayoutSubviews {
    NSLog(@"viewDidLayoutSubviews");
    UIEdgeInsets padding = UIEdgeInsetsMake(0, 0, 0, 0);
    [self.playingMusicView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view).with.insets(padding);
    }];
}

- (void)configureDatas {
    MusicEntity *musicEntity = [self.musicEntityArray objectAtIndex:self.currentTrackIndex];
    NSLog(@"%@",musicEntity.title);
    self.playingMusicView.titleLabel.text = musicEntity.title;
    self.playingMusicView.artistLabel.text = musicEntity.artist;
    
    if (musicEntity.isFavorite) {
        [self.playingMusicView.isLikeButton setImage:[UIImage imageNamed:@"red_heart"] forState:UIControlStateNormal];
    }else{
        [self.playingMusicView.isLikeButton setImage:[UIImage imageNamed:@"empty_heart"] forState:UIControlStateNormal];
    }
    
    [self.playingMusicView.coverImageView sd_setImageWithURL:musicEntity.cover placeholderImage:[UIImage imageNamed:@"music_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        CATransition *transition = [CATransition animation];
        transition.duration = 1.0f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade;
        
        [self.playingMusicView.coverImageView.layer addAnimation:transition forKey:nil];
    }];
    
    [_playingMusicView.backgroundImageView sd_setImageWithURL:musicEntity.cover placeholderImage:[UIImage imageNamed:@"music_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if(![_visualEffectView isDescendantOfView:_playingMusicView.backgroundView]) {
            UIVisualEffect *blurEffect;
            blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
            _visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            _visualEffectView.frame = self.view.bounds;
            [_playingMusicView.backgroundView addSubview:_visualEffectView];
        }
        CATransition *transition = [CATransition animation];
        transition.duration = 1.0f;
        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        transition.type = kCATransitionFade;
        
        [self.playingMusicView.backgroundImageView.layer addAnimation:transition forKey:nil];
    }];
    
    switch (self.playStyle) {
        case PSCStyleInOrder:
            [_playingMusicView.playStyleButton setImage:[UIImage imageNamed:@"loop_all_icon"] forState:UIControlStateNormal];
            break;
        case PSCStyleSingleCycle:
            [_playingMusicView.playStyleButton setImage:[UIImage imageNamed:@"loop_single_icon"] forState:UIControlStateNormal];
            break;
        case PSCStyleRandom:
            [_playingMusicView.playStyleButton setImage:[UIImage imageNamed:@"shuffle_icon"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
    
    
    NSInteger preEntityIndex = _currentTrackIndex <= 0 ? self.musicEntityArray.count - 1 : _currentTrackIndex - 1;
    NSInteger nextEntityIndex = _currentTrackIndex >= self.musicEntityArray.count - 1 ? 0 :_currentTrackIndex + 1;
    MusicEntity *preEntity = [self.musicEntityArray objectAtIndex:preEntityIndex];
    MusicEntity *nextEntity = [self.musicEntityArray objectAtIndex:nextEntityIndex];

    [[SDWebImagePrefetcher sharedImagePrefetcher] prefetchURLs:@[preEntity.cover, nextEntity.cover]];
}

- (void)configureClickEvent {
    [self.playingMusicView.isLikeButton addTarget:self action:@selector(actionLike:) forControlEvents:UIControlEventTouchUpInside];
    [self.playingMusicView.downloadButton addTarget:self action:@selector(actionDownload:) forControlEvents:UIControlEventTouchUpInside];
    [self.playingMusicView.playStyleButton addTarget:self action:@selector(actionPlayStyle:) forControlEvents:UIControlEventTouchUpInside];
    [self.playingMusicView.previousButton addTarget:self action:@selector(actionPrevious:) forControlEvents:UIControlEventTouchUpInside];
    [self.playingMusicView.pasueButton addTarget:self action:@selector(actionPasue:) forControlEvents:UIControlEventTouchUpInside];
    [self.playingMusicView.nextButton addTarget:self action:@selector(actionNext:) forControlEvents:UIControlEventTouchUpInside];
    [self.playingMusicView.shareButton addTarget:self action:@selector(actionShare:) forControlEvents:UIControlEventTouchUpInside];
    [self.playingMusicView.progressSlider addTarget:self action:@selector(actionProgressValueChange:) forControlEvents:UIControlEventValueChanged];
}

- (void)actionLike:(id)sender {
    NSLog(@"isLikeButtonClicked");
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"DouFM.sqlite"];
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    MusicEntity *musicEntity = [self.musicEntityArray objectAtIndex:_currentTrackIndex];
    FMResultSet *result = [database executeQuery:@"select * from favorite where key = ?",musicEntity.key];
    
    if ([result next]) {
        BOOL success = [database executeUpdate:@"delete from favorite where key = ?",musicEntity.key];
        if (success) {
            [self.playingMusicView.isLikeButton setImage:[UIImage imageNamed:@"empty_heart"] forState:UIControlStateNormal];
            musicEntity.isFavorite = NO;
        }
    }else{
        BOOL success = [database executeUpdate:@"insert into favorite (key, title, artist, album, company, coverURL, publicTime, audioFileURL) values (?, ?, ?, ?, ?, ?, ?, ?)",musicEntity.key, musicEntity.title, musicEntity.artist, musicEntity.album, musicEntity.company, [musicEntity.cover absoluteString], musicEntity.publicTime, [musicEntity.audioFileURL absoluteString]];
        if (success) {
            [self.playingMusicView.isLikeButton setImage:[UIImage imageNamed:@"red_heart"] forState:UIControlStateNormal];
            musicEntity.isFavorite = YES;
        }
    }
    [database close];
}

- (void)actionDownload:(id)sender {
    NSLog(@"downloadButtonClicked");
}

- (void)actionPlayStyle:(id)sender {
    NSLog(@"playStyleButtonClicked");
    switch (self.playStyle) {
        case PSCStyleInOrder:
            self.playStyle = PSCStyleSingleCycle;
            [[NSUserDefaults standardUserDefaults] setInteger:PSCStyleSingleCycle forKey:@"playStyle"];
            [self.playingMusicView.playStyleButton setImage:[UIImage imageNamed:@"loop_single_icon"] forState:UIControlStateNormal];
            break;
        case PSCStyleSingleCycle:
            self.playStyle = PSCStyleRandom;
            [[NSUserDefaults standardUserDefaults] setInteger:PSCStyleRandom forKey:@"playStyle"];
            [self.playingMusicView.playStyleButton setImage:[UIImage imageNamed:@"shuffle_icon"] forState:UIControlStateNormal];
            break;
        case PSCStyleRandom:
            self.playStyle = PSCStyleInOrder;
            [[NSUserDefaults standardUserDefaults] setInteger:PSCStyleInOrder forKey:@"playStyle"];
            [self.playingMusicView.playStyleButton setImage:[UIImage imageNamed:@"loop_all_icon"] forState:UIControlStateNormal];
            break;
        default:
            break;
    }
}

- (void)actionPrevious:(id)sender {
    NSLog(@"previousButtonClicked");
    if (self.playStyle == PSCStyleInOrder || self.playStyle == PSCStyleSingleCycle) {
        if (_currentTrackIndex <= [@0 integerValue]) {
            self.currentTrackIndex = [self.musicEntityArray count] - 1;
        }else{
            self.currentTrackIndex--;
        }
    }else{
        self.currentTrackIndex = (_currentTrackIndex + [self getRandomDigital])%[self.musicEntityArray count];
    }
}

- (void)actionPasue:(id)sender {
    NSLog(@"pasueButtonClicked");
    if ([_streamer status] == DOUAudioStreamerPaused ||
        [_streamer status] == DOUAudioStreamerIdle) {
        [_streamer play];
        [self.playingMusicView.pasueButton setImage:[UIImage imageNamed:@"big_pause_button"] forState:UIControlStateNormal];
    }
    else {
        [_streamer pause];
        [self.playingMusicView.pasueButton setImage:[UIImage imageNamed:@"big_play_button"] forState:UIControlStateNormal];
    }
}

- (void)actionSingleCycle {
    self.currentTrackIndex = _currentTrackIndex;
}

- (void)actionNext:(id)sender {
    NSLog(@"nextButtonClicked");
    self.currentTrackIndex = (_currentTrackIndex + [self getRandomDigital])%[self.musicEntityArray count];
}

- (void)actionShare:(id)sender {
    NSLog(@"shareButtonClicked");
}

- (void)actionProgressValueChange:(id)sender {
    NSLog(@"actionProgressValueChange");
    [self.streamer setCurrentTime:self.streamer.duration * self.playingMusicView.progressSlider.value];
}

- (void)setCurrentTrackIndex:(NSInteger)currentTrackIndex {
    NSLog(@"setCurrentTrackIndex-------%lu",(unsigned long)currentTrackIndex);
    _currentTrackIndex = currentTrackIndex;
    [self configureDatas];
    [self _resetStreamer];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadExploreTableView" object:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadMyMusicTableView" object:nil];
//    [NSNotificationCenter]
}

- (NSInteger)getRandomDigital {
    NSInteger digital = 1;
    switch (self.playStyle) {
        case PSCStyleInOrder:
            digital =  1;
            break;
        case PSCStyleSingleCycle:
            digital =  1;
            break;
        case PSCStyleRandom:
            digital =  arc4random()%self.musicEntityArray.count;
            break;
        default:
            break;
    }
    return digital;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end











