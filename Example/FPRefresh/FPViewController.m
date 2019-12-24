//
//  FPViewController.m
//  FPRefresh
//
//  Created by FPJack on 12/24/2019.
//  Copyright (c) 2019 FPJack. All rights reserved.
//

#import "FPViewController.h"
#import <UIScrollView+Refresh.h>
#import <MJRefresh.h>
@interface FPViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *datas;

@end

@implementation FPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    MJWeakSelf
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //配置刷新行为
    self.tableView.headerCanRefresh = YES;
    self.tableView.foorterCanRefresh = YES;
    self.tableView.pageSize = 10;
    self.tableView.pageNumber = 1;
    
    self.tableView.refreshBlock = ^(RefreshType type) {
        //下啦刷新&上啦加载回调
        [weakSelf loadNetData];
    };
    
    //强制下拉刷新
    [self.tableView begin_Refreshing];
    
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
}
- (void)loadNetData{
    
    NSDictionary *parmars = @{
        @"pageSize":[NSString stringWithFormat:@"%ld",self.tableView.pageSize],
        @"pageNumber":[NSString stringWithFormat:@"%ld",self.tableView.pageNumber]};
    [parmars enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        NSLog(@"%@=%@\r\n",key,obj);
    }];
    
    MJWeakSelf
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSMutableArray *datas = [NSMutableArray array];
        if (self.tableView.pageNumber < 4) {
            for (int i = 0; i < weakSelf.tableView.pageSize ; i ++) {
                [datas addObject:@""];
            }
        }else{
            for (int i = 0; i < weakSelf.tableView.pageSize - 1; i ++) {
                [datas addObject:@""];
            }
        }
        
        if (self.tableView.headerIsRefreshing) {
            self.datas = datas;
        }else if(self.tableView.footerIsRefreshing){
            [self.datas addObjectsFromArray:datas];
        }
        [self.tableView reloadData];
        //如果网络请求不成功需调用[self.tableView endError_Refresh]结束刷新
        [self.tableView end_Refresh];
    });
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.datas.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return  cell;
}

@end
