# FPRefresh

[![CI Status](https://img.shields.io/travis/FPJack/FPRefresh.svg?style=flat)](https://travis-ci.org/FPJack/FPRefresh)
[![Version](https://img.shields.io/cocoapods/v/FPRefresh.svg?style=flat)](https://cocoapods.org/pods/FPRefresh)
[![License](https://img.shields.io/cocoapods/l/FPRefresh.svg?style=flat)](https://cocoapods.org/pods/FPRefresh)
[![Platform](https://img.shields.io/cocoapods/p/FPRefresh.svg?style=flat)](https://cocoapods.org/pods/FPRefresh)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

FPRefresh is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'FPRefresh'
```
## 基于MJRefresh对UIScrollView添加了一个简单的刷新分类，自动维护页码和数据是否加载完毕
 配置刷新&结束刷新
```ruby
  self.tableView.headerCanRefresh = YES;
  self.tableView.foorterCanRefresh = YES;
  self.tableView.pageSize = 2;
  self.tableView.pageNumber = 1;
  
  self.tableView.refreshBlock = ^(RefreshType type) {
      //下啦刷新&上啦加载回调
      [weakSelf loadNetData];
  };
  
  //强制下拉刷新
  [self.tableView begin_Refreshing];
  
  //网络请求正常结束刷新
  [self.tableView end_Refresh];
  
  //网络请求失败结束刷新
  [self.tableView endError_Refresh];
```


## Author

FPJack, 2551412939@qq.com

## License

FPRefresh is available under the MIT license. See the LICENSE file for more info.
