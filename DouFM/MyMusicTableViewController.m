//
//  MyMusicTableViewController.m
//  DouFM
//
//  Created by Pasco on 16/4/30.
//  Copyright © 2016年 Pasco. All rights reserved.
//

#import "MyMusicTableViewController.h"
#import "PlayingMusicViewController.h"
#import "MusicEntity.h"
#import "MusicListCell.h"
#import <FMDB.h>
#import <MJRefresh.h>

@interface MyMusicTableViewController ()

@property (strong, nonatomic) NSMutableArray *myMusicArray;

@end

@implementation MyMusicTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.myMusicArray = [[NSMutableArray alloc] init];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        NSLog(@"shuaxingzhong");
        [self refreshTableView];
    }];
    [self.tableView.mj_header beginRefreshing];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadTableView) name:@"reloadMyMusicTableView" object:nil];
}

- (void)refreshTableView {
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"DouFM.sqlite"];
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    
    FMResultSet *result = [database executeQuery:@"select * from favorite"];
    [self.myMusicArray removeAllObjects];
    while ([result next]) {
        MusicEntity *musicEntity = [[MusicEntity alloc] init];
        musicEntity.album = [result stringForColumn:@"album"];
        musicEntity.artist = [result stringForColumn:@"artist"];
        musicEntity.audioFileURL = [NSURL URLWithString:[result stringForColumn:@"audioFileURL"]];
        musicEntity.company = [result stringForColumn:@"company"];
        musicEntity.cover = [NSURL URLWithString:[result stringForColumn:@"coverURL"]];
        musicEntity.key = [result stringForColumn:@"key"];
        musicEntity.publicTime = [result stringForColumn:@"publicTime"];
        musicEntity.title = [result stringForColumn:@"title"];
        musicEntity.isFavorite = YES;
        [self.myMusicArray addObject:musicEntity];
    }
    [database close];
    [self.tableView.mj_header endRefreshing];
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"MyMusicTableViewController+++++++++++++++++++");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"MyMusicTableViewController-------------------");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.myMusicArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0*kHeightScale;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicListCell *musicListCell = (MusicListCell *)[tableView dequeueReusableCellWithIdentifier:@"MusicListCell"];
    if (!musicListCell) {
        musicListCell = [[MusicListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MusicListCell"];
    }
    
    MusicEntity *musicEntity = [self.myMusicArray objectAtIndex:indexPath.row];
    
    // Configure the cell...
    musicListCell.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    musicListCell.titleLabel.text = musicEntity.title;
    musicListCell.artistLabel.text = musicEntity.artist;
    
    if (self.playingMusicViewController) {
        if (self.playingMusicViewController.currentTrackIndex == indexPath.row && self.playingMusicViewController.fromTabbarItem == PSCItemFavorite) {
            musicListCell.playingImageView.hidden = NO;
        }else{
            musicListCell.playingImageView.hidden = YES;
        }
    }else{
        musicListCell.playingImageView.hidden = YES;
    }
    
    return musicListCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.playingMusicViewController = [PlayingMusicViewController sharedInstance];
    self.playingMusicViewController.musicEntityArray = [self.myMusicArray copy];
    
    //再次进入歌曲时，继续播放，而不是不从第0秒重新开始
    if (self.playingMusicViewController.currentTrackIndex != indexPath.row || self.playingMusicViewController.fromTabbarItem != PSCItemFavorite) {
        self.playingMusicViewController.currentTrackIndex = indexPath.row;
        self.playingMusicViewController.fromTabbarItem = PSCItemFavorite;
    }
    
    self.playingMusicViewController.playStyle = (NSInteger)[[NSUserDefaults standardUserDefaults] integerForKey:@"playStyle"];
    [self.playingMusicViewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:self.playingMusicViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - CurrentPlayingIndexDelegate

- (void)reloadTableView {
    [self.tableView reloadData];
}

- (void)dealloc {
    NSLog(@"my music table view controller is deallocing");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadMyMusicTableView" object:nil];
}

@end
