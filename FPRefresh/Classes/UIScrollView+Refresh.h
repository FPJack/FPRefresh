//
//  UIScrollView+Refresh.h
//  ZCJLiuBaPet
//
//  Created by fanpeng on 2019/10/15.
//  Copyright © 2019 zhichongjia. All rights reserved.
//




#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, RefreshType) {
    RefreshTypeHeader, //头部刷新
    RefreshTypeFooter//尾部刷新
};
NS_ASSUME_NONNULL_BEGIN
@protocol RefreshProtocal <NSObject>
@required
- (void)refresh_Action;
@end
NS_ASSUME_NONNULL_END

NS_ASSUME_NONNULL_BEGIN
@interface UIScrollView (Refresh)
//刷新回调可以代理&block二选择一
@property (nonatomic,assign) id<RefreshProtocal> refreshDelegate;
@property (nonatomic,copy)void (^refreshBlock)(RefreshType type);

@property (nonatomic,assign)NSInteger pageNumber;//默认1开始
@property (nonatomic,assign)NSInteger pageSize; //默认20
//当前请求的数据个数，根据外部个数控制是否加载完毕，tableView的allCount = section * item 无需再手动赋值该属性
@property (nonatomic,assign)NSInteger currentCount;
@property (nonatomic,assign,readonly)BOOL headerIsRefreshing;
@property (nonatomic,assign,readonly)BOOL footerIsRefreshing;
@property (nonatomic,assign)BOOL headerCanRefresh;
@property (nonatomic,assign)BOOL foorterCanRefresh;
- (void)begin_Refreshing;
- (void)end_Refresh;
- (void)endError_Refresh;
@end

NS_ASSUME_NONNULL_END
