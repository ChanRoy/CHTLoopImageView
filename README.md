# CHTLoopImageView

图片轮播视图，支持手写代码布局和AutoLayout。

![Flipboard playing multiple GIFs](https://github.com/ChanRoy/CHTLoopImageView/blob/master/CHTLoopImageView.gif)

## 简介

* 图片轮播视图，支持手写代码布局和AutoLayout

## 使用

### 属性

    //是否自动轮播
    @property (nonatomic, assign) BOOL autoScroll;

    //是否显示pageControl
    @property (nonatomic, assign) BOOL showPageControl;

    //自动轮播时间间隔
    @property (nonatomic, assign) CGFloat autoScollTimeInterval;

    //imageViews url str 数组
    @property (nonatomic, strong) NSArray *imageUrls;

    //本地图片数组
    @property (nonatomic, strong) NSArray *images;

    //请求失败的占位图片
    @property (nonatomic, strong) UIImage *placeholderImage;

### init

#### 本地图片轮播

    - (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images;

#### 网络图片轮播

    - (instancetype)initWithFrame:(CGRect)frame imageUrls:(NSArray *)imageUrls placeholderImage:(UIImage *)placeholderImage;

#### 支持xib

    //xib
    _loopViewFromXib.imageUrls = urlStrs;
    _loopViewFromXib.placeholderImage = [UIImage imageNamed:@"placePhoto"];

### CHTLoopImageViewDelegate

#### optional

    - (void)loopImageView:(CHTLoopImageView *)loopImageView didSelectItemAtIndex:(NSInteger)index;

    - (void)loopImageView:(CHTLoopImageView *)loopImageView didScrollToIndex:(NSInteger)index;
    
## Demo

    NSArray *urlStrs = @[
                         @"http://img.mp.itc.cn/upload/20160826/9ac726cfdd3f480cb0bfaa34e6d62bf7_th.png",
                         @"http://img.mp.itc.cn/upload/20160826/440bbbaf33bd40e2b3707834ff85347e_th.jpg",
                         @"http://img.mp.itc.cn/upload/20160826/776dbf927f9c416487f1ba0378211144_th.jpg",
                         @"http://img.mp.itc.cn/upload/20160826/e5b3787c69074e86bc43a68772089c89_th.jpg"];
    
    NSArray *localImages = @[
                             [UIImage imageNamed:@"111.jpg"],
                             [UIImage imageNamed:@"111.jpg"],
                             [UIImage imageNamed:@"111.jpg"],
                             [UIImage imageNamed:@"111.jpg"]];
    
    //images from loacl
    _loopViewFromLocal = [[CHTLoopImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_loopViewFromXib.frame) + 10, SCREEN_WIDTH, 150) images:localImages];
    [self.view addSubview:_loopViewFromLocal];
    
    //images from net
    CHTLoopImageView *loopViewFromNet = [[CHTLoopImageView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_loopViewFromLocal.frame) + 10, SCREEN_WIDTH, 150) imageUrls:urlStrs placeholderImage:[UIImage imageNamed:@"placePhoto"]];
    [self.view addSubview:loopViewFromNet];
    
    //xib
    _loopViewFromXib.imageUrls = urlStrs;
    _loopViewFromXib.placeholderImage = [UIImage imageNamed:@"placePhoto"];
