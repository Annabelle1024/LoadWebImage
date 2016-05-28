//
//  YJAppInfoModel.h
//  LoadWebImageAsynchronously
//
//  Created by Annabelle on 16/5/28.
//  Copyright © 2016年 annabelle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YJAppInfoModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *download;
@property (nonatomic, copy) NSString *icon;

/*!
 *  保存网络下载的图像
 */
@property (nonatomic, strong) UIImage *image;
@end
