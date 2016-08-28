//
//  ViewController.m
//  CHTLoopImageViewDemo
//
//  Created by mac on 16/8/28.
//  Copyright © 2016年 Roy Chan. All rights reserved.
//

#import "ViewController.h"
#import "CHTLoopImageView.h"

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

@interface ViewController ()

@property (weak, nonatomic) IBOutlet CHTLoopImageView *loopViewFromXib;

@property (nonatomic, strong) CHTLoopImageView *loopViewFromLocal;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *urlStrs = @[
                         @"http://img.mp.itc.cn/upload/20160826/9ac726cfdd3f480cb0bfaa34e6d62bf7_th.png",
                         @"http://img.mp.itc.cn/upload/20160826/440bbbaf33bd40e2b3707834ff85347e_th.jpg",
                         @"http://img.mp.itc.cn/upload/20160826/776dbf927f9c416487f1ba0378211144_th.jpg",
                         @"http://img.mp.itc.cn/upload/20160826/e5b3787c69074e86bc43a68772089c89_th.jpg"];
    
#if 0
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
#endif
    
    //xib
    _loopViewFromXib.imageUrls = urlStrs;
    _loopViewFromXib.placeholderImage = [UIImage imageNamed:@"placePhoto"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
