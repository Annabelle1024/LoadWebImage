//
//  YJAppInfoCell.h
//  LoadWebImageAsynchronously
//
//  Created by Annabelle on 16/5/28.
//  Copyright © 2016年 annabelle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJAppInfoCell : UITableViewCell

// 应用图像
@property (weak, nonatomic) IBOutlet UIImageView *iconView;

// 应用名称
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

// 下载数量
@property (weak, nonatomic) IBOutlet UILabel *downloadLabel;

@end
