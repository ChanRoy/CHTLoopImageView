//
//  CHTLoopImageView.m
//  CHTLoopImageViewDemo
//
//  Created by mac on 16/8/28.
//  Copyright © 2016年 Roy Chan. All rights reserved.
//

#import "CHTLoopImageView.h"
#import "UIImageView+WebCache.h"


#define VIEW_WIDTH  CGRectGetWidth(self.frame)
#define VIEW_HEIGHT CGRectGetHeight(self.frame)
#define START_TAG   100

typedef enum : NSUInteger {
    
    CHTImageTypeLocal   = 0,
    CHTImageTypeFromNet = 1,
} CHTImageType;

static BOOL     const kDefaultAutoScroll = YES;
static BOOL     const kDefaultShowPageControl = YES;
static CGFloat  const kDefaultScollTimeInterval = 3.0f;

@interface CHTLoopImageView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation CHTLoopImageView{
    
    NSMutableArray<UIImageView *> *_imageViews;
    CHTImageType _imageType;
    NSInteger _imageCount;
    UIImageView *_tempView;
    UIView *_contentView;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialization];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [self initialization];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageType = CHTImageTypeLocal;
        _imageCount = images.count;
        _images = images;
        
        [self initialization];
        [self configUI];
        [self startTimer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame imageUrls:(NSArray *)imageUrls placeholderImage:(UIImage *)placeholderImage{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageType = CHTImageTypeFromNet;
        _imageCount = imageUrls.count;
        _placeholderImage = placeholderImage;
        _imageUrls = imageUrls;
        
        [self initialization];
        [self configUI];
        [self startTimer];
    }
    return self;
}

#pragma mark - Setters

- (void)setImageUrls:(NSArray *)imageUrls{
    
    if (_imageUrls == imageUrls) {
        return;
    }
    _imageUrls = imageUrls;
    
    _imageType = CHTImageTypeFromNet;
    _imageCount = imageUrls.count;
    
    [self initialization];
    [self configUI];
    [self startTimer];
}

- (void)setImages:(NSArray *)images{
    
    if (_images == images) {
        return;
    }
    _images = images;
    _imageType = CHTImageTypeLocal;
    _imageCount = images.count;
    
    [self initialization];
    [self configUI];
    [self startTimer];
}

- (void)setAutoScroll:(BOOL)autoScroll{
    
    if (_autoScroll == autoScroll) {
        return;
    }
    _autoScroll = autoScroll;
    [self stopTimer];
    [self startTimer];
}

- (void)setShowPageControl:(BOOL)showPageControl{
    
    if (_showPageControl == showPageControl) {
        return;
    }
    _showPageControl = showPageControl;
    _pageControl.hidden = !showPageControl;
}

- (void)setAutoScollTimeInterval:(CGFloat)autoScollTimeInterval{
    
    if (_autoScollTimeInterval == autoScollTimeInterval) {
        return;
    }
    _autoScollTimeInterval = autoScollTimeInterval;
    [self stopTimer];
    [self startTimer];
}

#pragma mark - UI
- (void)configUI{
    
    if (_scrollView) {
        [_scrollView removeFromSuperview];
        _imageViews = nil;
        _tempView = nil;
    }
    
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:_scrollView
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_scrollView
                                                        attribute:NSLayoutAttributeTop
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeTop
                                                       multiplier:1
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_scrollView
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_scrollView
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1
                                                         constant:0]
                           ]];
    
    _contentView = [UIView new];
    _contentView.backgroundColor = [UIColor clearColor];
    [_scrollView addSubview:_contentView];
    _contentView.translatesAutoresizingMaskIntoConstraints = NO;
    [_scrollView addConstraints:@[
                                  [NSLayoutConstraint constraintWithItem:_contentView
                                                               attribute:NSLayoutAttributeLeft
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:_scrollView
                                                               attribute:NSLayoutAttributeLeft
                                                              multiplier:1
                                                                constant:0],
                                  [NSLayoutConstraint constraintWithItem:_contentView
                                                               attribute:NSLayoutAttributeWidth
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:_scrollView
                                                               attribute:NSLayoutAttributeWidth
                                                              multiplier:3
                                                                constant:0],
                                  [NSLayoutConstraint constraintWithItem:_contentView
                                                               attribute:NSLayoutAttributeRight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:_scrollView
                                                               attribute:NSLayoutAttributeRight
                                                              multiplier:1
                                                                constant:0],
                                  [NSLayoutConstraint constraintWithItem:_contentView
                                                               attribute:NSLayoutAttributeTop
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:_scrollView
                                                               attribute:NSLayoutAttributeTop
                                                              multiplier:1
                                                                constant:0],
                                  [NSLayoutConstraint constraintWithItem:_contentView
                                                               attribute:NSLayoutAttributeHeight
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:_scrollView
                                                               attribute:NSLayoutAttributeHeight
                                                              multiplier:1
                                                                constant:0],
                                  [NSLayoutConstraint constraintWithItem:_contentView
                                                               attribute:NSLayoutAttributeBottom
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:_scrollView
                                                               attribute:NSLayoutAttributeBottom
                                                              multiplier:1
                                                                constant:0]
                                  ]];
    
    
    _imageViews = [NSMutableArray new];
    
    //setup three imageViews in the _scrollView
    for (NSInteger i = 0; i < 3; i ++) {
        
        UIImageView *imageView = [[UIImageView alloc]init];
        
        NSInteger index = 0;
        if (i == 0) index = _imageCount - 1;
        if (i == 1) index = 0;
        if (i == 2) index = _imageCount == 1 ? 0 : 1;
        
        imageView.tag = index + START_TAG;
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapEvent:)];
        [imageView addGestureRecognizer:tap];
        
        [self setimageView:imageView atIndex:index];
        [_imageViews addObject:imageView];
        [_contentView addSubview:imageView];
        
        imageView.translatesAutoresizingMaskIntoConstraints = NO;
        
        NSLayoutConstraint *leftConstraint;
        if (_tempView) {
            leftConstraint = [NSLayoutConstraint constraintWithItem:imageView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_tempView
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:0];
        }else{
            leftConstraint = [NSLayoutConstraint constraintWithItem:imageView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:_contentView attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:0];
        }
        
        [_contentView addConstraints:@[
                                       leftConstraint,
                                       [NSLayoutConstraint constraintWithItem:imageView
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_contentView
                                                                    attribute:NSLayoutAttributeWidth
                                                                   multiplier:1.0 / 3.0
                                                                     constant:0],
                                       [NSLayoutConstraint constraintWithItem:imageView
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_contentView
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1
                                                                     constant:0],
                                       [NSLayoutConstraint constraintWithItem:imageView
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_contentView
                                                                    attribute:NSLayoutAttributeHeight
                                                                   multiplier:1
                                                                     constant:0]
                                       ]];
        
        _tempView = imageView;
    }
    
    _scrollView.contentOffset = CGPointMake(CGRectGetWidth(_scrollView.frame), 0);
    
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, VIEW_HEIGHT - 30, VIEW_WIDTH, 30)];
    _pageControl.numberOfPages = _imageCount;
    _pageControl.currentPage = 0;
    _pageControl.hidesForSinglePage = YES;
    [self addSubview:_pageControl];
    
    _pageControl.translatesAutoresizingMaskIntoConstraints = NO;
    [self addConstraints:@[
                           [NSLayoutConstraint constraintWithItem:_pageControl
                                                        attribute:NSLayoutAttributeBottom
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeBottom
                                                       multiplier:1
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_pageControl
                                                        attribute:NSLayoutAttributeLeft
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeLeft
                                                       multiplier:1
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_pageControl
                                                        attribute:NSLayoutAttributeRight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:self
                                                        attribute:NSLayoutAttributeRight
                                                       multiplier:1
                                                         constant:0],
                           [NSLayoutConstraint constraintWithItem:_pageControl
                                                        attribute:NSLayoutAttributeHeight
                                                        relatedBy:NSLayoutRelationEqual
                                                           toItem:nil
                                                        attribute:NSLayoutAttributeNotAnAttribute
                                                       multiplier:1
                                                         constant:30]]];
    if (_imageCount == 1) {
        _scrollView.scrollEnabled = NO;
        _autoScroll = NO;
    }
}

#pragma mark - action

- (void)tapEvent:(UITapGestureRecognizer *)tap{
    
    if (_delegate && [_delegate respondsToSelector:@selector(loopImageView:didSelectItemAtIndex:)]) {
        
        [_delegate loopImageView:self didSelectItemAtIndex:tap.view.tag - START_TAG];
    }
}

- (void)initialization{
    
    _autoScroll             = kDefaultAutoScroll;
    _showPageControl        = kDefaultShowPageControl;
    _autoScollTimeInterval  = kDefaultScollTimeInterval;
}

- (void)setimageView:(UIImageView *)imageView atIndex:(NSInteger)index{
    
    if (_imageType == CHTImageTypeLocal) {
        
        if (_images.count > index) {
            
            UIImage *image = _images[index];
            imageView.image = image;
        }
    }
    else{
        
        if (_imageUrls.count > index) {
            
            NSURL *url = [NSURL URLWithString:_imageUrls[index]];
            [imageView sd_setImageWithURL:url placeholderImage:_placeholderImage];
        }
    }
    
}

- (void)updateUI{
    
    int flag = 0;
    //slide to right
    if (_scrollView.contentOffset.x > VIEW_WIDTH) {
        flag = 1;
    }
    //slide to left
    else if (_scrollView.contentOffset.x == 0){
        flag = -1;
    }
    //no moving
    else{
        return;
    }
    
    //change the image in imageViews
    for (UIImageView *imageView in _imageViews) {
        
        NSInteger index = imageView.tag - START_TAG + flag;
        
        if (index < 0) {
            index = _imageCount - 1;
        }else if (index >= _imageCount){
            index = 0;
        }
        
        imageView.tag = index + START_TAG;
        
        [self setimageView:imageView atIndex:index];
        
        //the imageView in the middel should be always in the middle
        self.scrollView.contentOffset = CGPointMake(VIEW_WIDTH, 0);
        
        
    }
    _pageControl.currentPage = _imageViews[1].tag - START_TAG;
    
    if (_delegate && [_delegate respondsToSelector:@selector(loopImageView:didScrollToIndex:)]) {
        
        [_delegate loopImageView:self didScrollToIndex:_imageViews[1].tag - START_TAG];
    }
}

#pragma mark - timer
- (void)startTimer{
    
    if (_autoScroll) {
        
        if (_timer) {
            [self stopTimer];
        }
        _timer = [NSTimer scheduledTimerWithTimeInterval:_autoScollTimeInterval target:self selector:@selector(timerRefresh) userInfo:nil repeats:YES];
        
        //timer add to runLoop
        //NSRunLoopCommonModes: timer will not stop when scrollView is scrolling
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }
}

- (void)stopTimer{
    
    if (_timer) {
        [_timer invalidate];
    }
    _timer = nil;
}

- (void)timerRefresh{
    
    //the normal contentOffset is (VIEW_WIDTH, 0), set the x of contentOffset to (VIEW_WIDTH * 2) means slide to left for one page.
    [_scrollView setContentOffset:CGPointMake(VIEW_WIDTH * 2, 0) animated:YES];
}

#pragma mark - scrollview delegate

//when user drags the scrollView, the two methods below will be called. (by user)
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self stopTimer];
}
//(by user)
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [self startTimer];
}

//when scrollView end decelerating, this method wiil be called. (by user)
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    [self updateUI];
}

//when call 'setContentOffset', this method will be called. (by system)
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    
    [self updateUI];
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame) * 3, 0);
    _scrollView.contentOffset = CGPointMake(CGRectGetWidth(_scrollView.frame), 0);
}

@end
