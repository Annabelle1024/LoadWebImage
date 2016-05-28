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

#import "UIImageView+WebCache.h"

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
    
    // sdwebimage 异步设置图像
    NSURL *url = [NSURL URLWithString:model.icon];
    [cell.iconView sd_setImageWithURL:url];

    
    return cell;
    
}


@end
