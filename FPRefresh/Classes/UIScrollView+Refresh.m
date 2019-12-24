//
//  UIScrollView+Refresh.m
//  ZCJLiuBaPet
//
//  Created by fanpeng on 2019/10/15.
//  Copyright © 2019 zhichongjia. All rights reserved.
//

#import "UIScrollView+Refresh.h"
#import <MJRefresh/MJRefresh.h>
NS_ASSUME_NONNULL_BEGIN
@interface UIScrollView ()
@property(nonatomic,assign)NSInteger total_count;
@end
NS_ASSUME_NONNULL_END
@implementation UIScrollView (Refresh)
#pragma mark - refreshBlock
static const char FPRefreshBlockKey = '\0';
- (void)setRefreshBlock:(void (^)(RefreshType))refreshBlock{
    objc_setAssociatedObject(self, &FPRefreshBlockKey,
                             refreshBlock, OBJC_ASSOCIATION_COPY);
}
- (void (^)(RefreshType))refreshBlock{
    return objc_getAssociatedObject(self, &FPRefreshBlockKey);
}
#pragma mark - refreshDelegate
static const char FPRefreshDelegateKey = '\0';
- (void)setRefreshDelegate:(id<RefreshProtocal>)refreshDelegate{
    objc_setAssociatedObject(self, &FPRefreshDelegateKey,
                             refreshDelegate, OBJC_ASSOCIATION_RETAIN);
}
- (id<RefreshProtocal>)refreshDelegate{
    return objc_getAssociatedObject(self, &FPRefreshDelegateKey);
}
#pragma mark - headerCanRefresh
static const char FPHeaderCanRefreshKey = '\0';
- (void)setHeaderCanRefresh:(BOOL)headerCanRefresh{
    if (headerCanRefresh) {
        MJRefreshNormalHeader *mjHeader = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(header_Refresh)];
        self.mj_header = mjHeader;
    }
    objc_setAssociatedObject(self, &FPHeaderCanRefreshKey,
                             @(headerCanRefresh), OBJC_ASSOCIATION_RETAIN);
}
- (BOOL)headerCanRefresh{
    NSNumber *canRefresh = (NSNumber*)objc_getAssociatedObject(self, &FPHeaderCanRefreshKey);
    return canRefresh.boolValue;
}
#pragma mark - FooterCanRefresh
static const char FPFooterCanRefreshKey = '\0';
- (void)setFoorterCanRefresh:(BOOL)foorterCanRefresh{
    if (foorterCanRefresh) {
        self.currentCount = - 100;
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footer_Refresh)];
        footer.stateLabel.font = [UIFont systemFontOfSize:12];
        [footer setTitle:@"没有更多啦" forState:MJRefreshStateNoMoreData];
        self.mj_footer = footer;
    }
    
    objc_setAssociatedObject(self, &FPFooterCanRefreshKey,
                             @(foorterCanRefresh), OBJC_ASSOCIATION_RETAIN);
}
- (BOOL)foorterCanRefresh{
    NSNumber *canRefresh = (NSNumber*)objc_getAssociatedObject(self, &FPFooterCanRefreshKey);
    return canRefresh.boolValue;
}
#pragma mark - pageSize
static const char FPPageSizeKey = '\0';
- (void)setPageSize:(NSInteger)pageSize{
    objc_setAssociatedObject(self, &FPPageSizeKey,
                             @(pageSize), OBJC_ASSOCIATION_RETAIN);
}
- (NSInteger)pageSize{
    NSNumber *pageSize = (NSNumber*)objc_getAssociatedObject(self, &FPPageSizeKey);
    return pageSize.integerValue == 0 ? 20 : pageSize.integerValue;
}
#pragma mark - currentCount
static const char FPCurrentCountKey = '\0';
- (void)setCurrentCount:(NSInteger)currentCount{
    objc_setAssociatedObject(self, &FPCurrentCountKey,
                             @(currentCount), OBJC_ASSOCIATION_RETAIN);
}
- (NSInteger)currentCount{
    NSNumber *currentCount = (NSNumber*)objc_getAssociatedObject(self, &FPCurrentCountKey);
    return currentCount.integerValue;
}

#pragma mark - page_number
static const char FPPageNumberKey = '\0';
- (void)setPageNumber:(NSInteger)pageNumber{
    objc_setAssociatedObject(self, &FPPageNumberKey,
                             @(pageNumber), OBJC_ASSOCIATION_RETAIN);
}
- (NSInteger)pageNumber{
    NSNumber *pageNumber = (NSNumber*)objc_getAssociatedObject(self, &FPPageNumberKey);
    return pageNumber.integerValue ==0 ? 1 : pageNumber.integerValue;
}
#pragma mark - totalCount
static const char FPTotalCount = '\0';
- (void)setTotal_count:(NSInteger)total_count{
    objc_setAssociatedObject(self, &FPTotalCount,
                             @(total_count), OBJC_ASSOCIATION_RETAIN);
}
- (NSInteger)total_count{
    NSNumber *count = (NSNumber*)objc_getAssociatedObject(self, &FPTotalCount);
    return count.integerValue;
}
#pragma mark - isRefreshing
- (BOOL)headerIsRefreshing{return self.mj_header.refreshing;}
- (BOOL)footerIsRefreshing{return self.mj_footer.refreshing;}
- (void)begin_Refreshing{[self.mj_header beginRefreshing];}

- (void)header_Refresh{
    self.pageNumber = 1;
    if (self.refreshDelegate) {
        [self.refreshDelegate refresh_Action];
    }else if (self.refreshBlock){
        self.refreshBlock(RefreshTypeHeader);
    }
}
- (void)footer_Refresh{
    self.pageNumber += 1;
    if (self.refreshDelegate) {
        [self.refreshDelegate refresh_Action];
    }else if (self.refreshBlock){
        self.refreshBlock(RefreshTypeFooter);
    }
}
- (void)end_Refresh{
    if (self.headerIsRefreshing) {
        [self.mj_header endRefreshing];
        self.total_count = 0;
        if (self.foorterCanRefresh && self.mj_footer.state == MJRefreshStateNoMoreData) {
            [self.mj_footer resetNoMoreData];
        }
    }
    
    if (self.foorterCanRefresh) {
        NSInteger currentCount = self.currentCount != -100 ? self.currentCount : [self fp_totalDataCount] - self.total_count;
        if (currentCount < self.pageSize) {
            [self.mj_footer endRefreshingWithNoMoreData];
        }else{
            [self.mj_footer endRefreshing];
        }
        self.total_count = self.total_count + currentCount;
        
        self.mj_footer.hidden = !(self.total_count > 0);
    }
}
- (void)endError_Refresh{
    if (self.headerIsRefreshing) [self end_Refresh];
    if (self.footerIsRefreshing) {
        self.pageNumber -= 1;
        [self.mj_footer endRefreshing];
    }
}
#pragma mark - other
- (NSInteger)fp_totalDataCount
{
    NSInteger totalCount = 0;
    if ([self isKindOfClass:[UITableView class]]) {
        UITableView *tableView = (UITableView *)self;
        for (NSInteger section = 0; section < tableView.numberOfSections; section++) {totalCount += [tableView numberOfRowsInSection:section];}
    } else if ([self isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)self;
        for (NSInteger section = 0; section < collectionView.numberOfSections; section++) {
            totalCount += [collectionView numberOfItemsInSection:section];
        }
    }
    return totalCount;
}
@end
