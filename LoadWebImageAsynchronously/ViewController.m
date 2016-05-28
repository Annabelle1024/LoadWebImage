//
//  ViewController.m
//  LoadWebImageAsynchronously
//
//  Created by Annabelle on 16/5/28.
//  Copyright © 2016年 annabelle. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadData {
    
    // 1. 获取 http 请求管理器
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2. 使用 GET 方法，获取网络数据
    NSString *urlName = @"https://raw.githubusercontent.com/Annabelle1024/LoadWebImageAsynchronously/master/appsInfo.json";
    
    [manager GET:urlName
            parameters:nil
            progress:nil
            success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
                // 服务器返回的字典或者数组(AFN 已经做好了－可以直接字典转模型即可！)
                NSLog(@"%@, %@", responseObject, [responseObject class]);
        
        
        
            }
            failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
                NSLog(@"请求失败: %@", error);
    
            }];
    
    
}

@end
