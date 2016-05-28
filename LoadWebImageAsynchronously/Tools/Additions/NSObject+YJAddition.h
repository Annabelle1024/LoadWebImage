//
//  NSObject+YJAddition.h
//
//  Created by Annabelle on 16/5/28.
//  Copyright © 2016年 annabelle. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSObject (YJAddition)

/// 使用字典创建模型对象
///
/// @param dict 字典
///
/// @return 模型对象
+ (instancetype)yj_objectWithDict:(NSDictionary *)dict;

@end
