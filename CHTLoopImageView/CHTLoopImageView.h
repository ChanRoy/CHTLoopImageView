//
//  CHTLoopImageView.h
//  CHTLoopImageViewDemo
//
//  Created by mac on 16/8/28.
//  Copyright © 2016年 Roy Chan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CHTLoopImageView;

@protocol CHTLoopImageViewDelegate <NSObject>

@optional

- (void)loopImageView:(CHTLoopImageView *)loopImageView didSelectItemAtIndex:(NSInteger)index;

- (void)loopImageView:(CHTLoopImageView *)loopImageView didScrollToIndex:(NSInteger)index;

@end

/**
 *  loop images with three imageViews
 */
@interface CHTLoopImageView : UIView

@property (nonatomic, assign) BOOL autoScroll;

@property (nonatomic, assign) BOOL showPageControl;

@property (nonatomic, assign) CGFloat autoScollTimeInterval;

@property (nonatomic, strong) NSArray *imageUrls;

@property (nonatomic, strong) NSArray *images;

@property (nonatomic, strong) UIImage *placeholderImage;

@property (nonatomic, assign) id<CHTLoopImageViewDelegate> delegate;

/**
 *  init method
 *
 *  @param frame            frame
 *  @param images           images array to display
 *
 *  @return instancetype
 */
- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images;

/**
 *  init method
 *
 *  @param frame            frame
 *  @param imageUrls        imageUrls array to display
 *  @param placeholderImage placeholderImage
 *
 *  @return instancetype
 */
- (instancetype)initWithFrame:(CGRect)frame imageUrls:(NSArray *)imageUrls placeholderImage:(UIImage *)placeholderImage;

/**
 *  this method should be called when the viewController 'will disappear', or it may cause leak.
 */
- (void)stopTimer;

@end
