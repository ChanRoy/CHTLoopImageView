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
