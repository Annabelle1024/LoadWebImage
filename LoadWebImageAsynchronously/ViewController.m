//
//  ViewController.m
//  LoadWebImageAsynchronously
//
//  Created by Annabelle on 16/5/28.
//  Copyright © 2016年 annabelle. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "YJAppInfoModel.h"
#import "YJAppInfoCell.h"


static NSString *cellId = @"cellId";

@interface ViewController () <UITableViewDataSource>

/*!
 *  应用程序信息列表数组
 */
@property (nonatomic, strong) NSArray <YJAppInfoModel *> *appInfoList;

/*!
 *  表格视图
 */
@property (nonatomic, strong) UITableView *tableView;

/*!
 *  下载列队
 */
@property (nonatomic, strong) NSOperationQueue *downloadQueue;

@end

@implementation ViewController

// 根视图设置为 tableView
- (void)loadView {
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    _tableView.rowHeight = 100;
    
    // 注册原型cell
//    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:cellId];
    
    // 用xib注册原型cell
    [_tableView registerNib:[UINib nibWithNibName:@"YJAppInfoCell" bundle:nil] forCellReuseIdentifier:cellId];
    
    // 设置数据源
    _tableView.dataSource = self;
    
    self.view = _tableView;
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 实例化下载列队
    _downloadQueue = [[NSOperationQueue alloc] init];
    
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
            success:^(NSURLSessionDataTask * _Nonnull task, NSArray *responseObject) {
        
                // 服务器返回的字典或者数组(AFN 已经做好了－可以直接字典转模型即可！)
                NSLog(@"%@, %@", responseObject, [responseObject class]);
                
                // 遍历数组字典转模型
                NSMutableArray *arrayM = [NSMutableArray array];
                
                for (NSDictionary *dict in responseObject) {
                    
                    YJAppInfoModel *model = [[YJAppInfoModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [arrayM addObject:model];
                    
                }
                
                // 使用属性记录
                self.appInfoList = arrayM;
                
                // 刷新表格数据
                // 因为是异步加载的数据，表格的数据源方法已经执行过！
                // 加载完成数据之后，需要刷新表格数据，重新执行数据源方法
                [self.tableView reloadData];
    
            }
            failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
                NSLog(@"请求失败: %@", error);
    
            }];
   
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _appInfoList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YJAppInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId forIndexPath:indexPath];
    
    YJAppInfoModel *model = _appInfoList[indexPath.row];
    
    cell.nameLabel.text = model.name;
    cell.downloadLabel.text = model.download;
    
    // 判断模型中是否有 image 属性, 如果有, 直接返回该image, 如果没有, 启用占位图像
    if (model.image != nil) {
        
        NSLog(@"此时返回的是内存缓存的图片");
        
        cell.iconView.image = model.image;
        
        return cell;
        
    }
    
    // 增加占位图像
    UIImage *placeholderImage = [UIImage imageNamed:@"user_default"];
    cell.iconView.image = placeholderImage;
    
    // 异步设置图像
    NSURL *url = [NSURL URLWithString:model.icon];
    
    // 异步加载图像
    // 1> 创建下载操作
    NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:^{
        
        // **** 模拟延时, 让占位图像发挥作用
        [NSThread sleepForTimeInterval:1.0];
        
        // a> 根据 url 加载二进制数据
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        // b> 将二进制数据转换成 image
        UIImage *image = [UIImage imageWithData:data];
        
        // *** 记录图像属性
        model.image = image;
        
        // c> 主线程更新 UI
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            cell.iconView.image = image;
            
        }];
        
    }];
    
    // 将图像添加到队列
    [_downloadQueue addOperation:op];
    
    
    return cell;
    
}


@end
