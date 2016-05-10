//
//  MenuViewController.m
//  DouFM
//
//  Created by Pasco on 16/5/9.
//  Copyright © 2016年 Pasco. All rights reserved.
//

#import "MenuViewController.h"
#import "AboutCell.h"
#import "MenuCell.h"
#import <Masonry.h>

@interface MenuViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UITableView *menuTableView;
@property (nonatomic, strong) NSMutableArray *playlistArray;

@end

@implementation MenuViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.view.frame = CGRectMake(0, 0, kScreenWidth/3*2, kScreenHeight);
    }
    return self;
}

- (void)loadView {
    [super loadView];
    [self configureViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //获取playlist.plist文件内信息
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"playlist.plist" ofType:nil];
    self.playlistArray = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    [self.menuTableView reloadData];
}


#pragma mark - configture

- (void)configureViews {
    self.menuTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth/3*2, kScreenHeight) style:UITableViewStylePlain];
    self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.menuTableView.showsVerticalScrollIndicator = NO;
    self.menuTableView.backgroundColor= [UIColor clearColor];
    self.menuTableView.delegate = self;
    self.menuTableView.dataSource = self;
    [self.view addSubview:self.menuTableView];
    
}


#pragma mark - tableview delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.playlistArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        AboutCell *aboutCell = [tableView dequeueReusableCellWithIdentifier:@"aboutCell"];
        if (!aboutCell) {
            aboutCell = [[AboutCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"aboutCell"];
        }
        return aboutCell;
    }else{
        MenuCell *menuCell = [tableView dequeueReusableCellWithIdentifier:@"menuCell"];
        if (!menuCell) {
            menuCell = [[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"menuCell"];
        }
        NSDictionary *playlistInfo = [self.playlistArray objectAtIndex:indexPath.row-1];
        menuCell.optionLabel.text = [playlistInfo objectForKey:@"name"];
        return menuCell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 180;
    }else{
        return 56;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"About us"
                                                        message:@"feedback: pascocoder@gmail.com, thanks😃"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }else{
        [self.delegate changePlaylistTo:[NSIndexPath indexPathForRow:indexPath.row-1 inSection:0]];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
}


@end

