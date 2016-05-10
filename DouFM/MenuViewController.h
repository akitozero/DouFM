//
//  MenuViewController.h
//  DouFM
//
//  Created by Pasco on 16/5/9.
//  Copyright © 2016年 Pasco. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChangePlaylistDelegate <NSObject>

- (void)changePlaylistTo:(NSIndexPath *)indexPath;

@end

@interface MenuViewController : UIViewController

@property (weak, nonatomic) id<ChangePlaylistDelegate> delegate;

@end
