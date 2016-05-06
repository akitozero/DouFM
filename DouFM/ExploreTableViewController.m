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

@interface ExploreTableViewController ()

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
            NSLog(@"dict----%@",dict);
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
            
            NSLog(@"%@",musicEntity.audioFileURL);
            [self.exploreMutableArray addObject:musicEntity];
        }];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (BOOL)checkIsFavorite:(NSString *)key{
    NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDir = [docPaths objectAtIndex:0];
    NSString *dbPath = [documentsDir   stringByAppendingPathComponent:@"DouFM.sqlite"];
    NSLog(@"%@+++++++",dbPath);
    FMDatabase *database = [FMDatabase databaseWithPath:dbPath];
    [database open];
    FMResultSet *result = [database executeQuery:@"select * from favorite where key = ?",key];
    
    [database close];
    if ([result next]) {
        return YES;
    }else{
        return NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.exploreMutableArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicListCell *musicListCell = (MusicListCell *)[tableView dequeueReusableCellWithIdentifier:@"MusicListCell"];
    if (!musicListCell) {
        musicListCell = [[MusicListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MusicListCell"];
    }
    
    MusicEntity *musicEntity = [self.exploreMutableArray objectAtIndex:indexPath.row];
    
    // Configure the cell...
    musicListCell.numberLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    musicListCell.titleLabel.text = musicEntity.title;
    musicListCell.artistLabel.text = musicEntity.artist;
    
    return musicListCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PlayingMusicViewController *playingMusicViewController = [PlayingMusicViewController sharedInstance];
//    MusicEntity *musicEntity = [self.exploreMutableArray objectAtIndex:indexPath.row];
    playingMusicViewController.musicEntityArray = [self.exploreMutableArray copy];
    NSLog(@"%ld-------",(long)indexPath.row);
    playingMusicViewController.currentTrackIndex = indexPath.row;
//    NSLog(@"%@--------",playingMusicViewController.musicEntity.title);
//    playingMusicViewController.navigationItem.title = musicEntity.title;
    [playingMusicViewController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:playingMusicViewController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
