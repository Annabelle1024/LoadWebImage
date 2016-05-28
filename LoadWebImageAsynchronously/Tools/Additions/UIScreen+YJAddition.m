//
//  UIScreen+YJAddition.m
//
//  Created by Annabelle on 16/5/28.
//  Copyright © 2016年 annabelle. All rights reserved.
//

#import "UIScreen+YJAddition.h"

@implementation UIScreen (YJAddition)

+ (CGFloat)yj_screenWidth {
    return [UIScreen mainScreen].bounds.size.width;
}

+ (CGFloat)yj_screenHeight {
    return [UIScreen mainScreen].bounds.size.height;
}

+ (CGFloat)yj_scale {
    return [UIScreen mainScreen].scale;
}

@end
