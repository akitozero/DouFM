//
//  ExploreTableViewController.m
//  DouFM
//
//  Created by Pasco on 16/4/30.
//  Copyright © 2016年 Pasco. All rights reserved.
//

#import "ExploreTableViewController.h"
#import "MusicListCell.h"
#import "MusicEntity.h"
#import "PlayingMusicViewController.h"
#import <YYModel.h>
#import <AFNetworking/AFNetworking.h>
#import <FMDB.h>

@interface ExploreTableViewController () <CurrentPlayingIndexDelegate>

@property (strong, nonatomic) NSMutableArray *exploreMutableArray;


@end

@implementation ExploreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.exploreMutableArray = [[NSMutableArray alloc] init];
      
    
#pragma mark - get data from server
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"http://doufm.info/api/playlist/52f8ca1d1d41c851663fcba7/?num=10" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSArray *responseArray = (NSArray *)responseObject;
        [responseArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *dict = obj;
//            NSLog(@"dict----%@",dict);
            MusicEntity *musicEntity = [[MusicEntity alloc] init];
            musicEntity.album = [dict objectForKey:@"album"];
            musicEntity.artist = [dict objectForKey:@"artist"];
            musicEntity.audioFileURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APIBaseURL,[dict objectForKey:@"audio"]]];
            musicEntity.company = [dict objectForKey:@"company"];
            musicEntity.cover = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",APIBaseURL,[dict objectForKey:@"cover"]]];
            musicEntity.key = [dict objectForKey:@"key"];
            musicEntity.publicTime = [dict objectForKey:@"public_time"];
            musicEntity.title = [dict objectForKey:@"title"];
            musicEntity.isFavorite = [self checkIsFavorite:musicEntity.key];
            
//            NSLog(@"%@",musicEntity.audioFileURL);
            [self.exploreMutableArray addObject:musicEntity];
        }];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    self.tableView
//}

- (BOOL)checkIsFavorite:(NSString *)key{
    BOOL flag = NO;
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"DouFM.sqlite"];
//    NSLog(@"%@+++++++",dbPath);
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    FMResultSet *result = [database executeQuery:@"select * from favorite where key = ?",key];
    
    if ([result next]) {
        flag = YES;
    }else{
        flag = NO;
    }
    [database close];
    return flag;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0*kHeightScale;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.exploreMutableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSLog(@"%ld+++++++%ld",(long)indexPath.section,(long)indexPath.row);
    MusicListCell *musicListCell = (MusicListCell *)[tableView dequeueReusableCellWithIdentifier:@"MusicListCell"];
    if (!musicListCell) {
        musicListCell = [[MusicListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MusicListCell"];
    }
    
    MusicEntity *musicEntity = [self.exploreMutableArray objectAtIndex:indexPath.row];
    
    // Configure the cell...
    musicListCell.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    musicListCell.titleLabel.text = musicEntity.title;
    musicListCell.artistLabel.text = musicEntity.artist;
   
    if (self.playingMusicViewController) {
        if (self.playingMusicViewController.currentTrackIndex == indexPath.row) {
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
    self.playingMusicViewController.musicEntityArray = [self.exploreMutableArray copy];
    self.playingMusicViewController.delegate = self;
    
    //再次进入歌曲时，继续播放，而不是不从第0秒重新开始
    if (self.playingMusicViewController.currentTrackIndex != indexPath.row) {
        self.playingMusicViewController.currentTrackIndex = indexPath.row;
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


@end
