//
//  LyricsView.h
//  全民歌星歌词渲染demo
//
//  Created by liuyang on 16/3/14.
//  Copyright © 2016年 ly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LyricsView : UIView

@property (strong, nonatomic)  UILabel *textLable;

@property (strong, nonatomic)  UILabel *maskLable;

@property (nonatomic, strong) CALayer *maskLayer;//用来控制maskLabel渲染的layer

- (void)setFont:(UIFont *)font;

- (void)setText:(NSString *)text;

- (void)setTextAlignment:(NSTextAlignment)textAlignment;

/**
 *  根据设置显示动画
 *
 *  @param timeArray     数组的内容是各个时间点，第一个必须是0，最后一个必须是总时间
 *  @param locationArray 对应各个时间点的位置，值从0~1，第一个必须是0，最后一个必须是1
 */
- (void)startLyricsAnimationWithTimeArray:(NSArray *)timeArray andLocationArray:(NSArray *)locationArray;

- (void)stopAnimation;

- (void)reAnimation;

- (void)setupDefault;

@end
