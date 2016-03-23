//
//  LyricsView.m
//  全民歌星歌词渲染demo
//
//  Created by liuyang on 16/3/14.
//  Copyright © 2016年 ly. All rights reserved.
//

#import "LyricsView.h"

@interface LyricsView ()

@end

@implementation LyricsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.textLable];
        [self addSubview:self.maskLable];
        
        [self setupDefault];
    }
    return self;
}

- (void)setupDefault {
    
    //self.textLable.backgroundColor = [UIColor redColor];
    self.textLable.textColor = [UIColor whiteColor];
    
    self.maskLable.textColor = [UIColor greenColor];
    self.maskLable.backgroundColor = [UIColor clearColor];
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.anchorPoint = CGPointZero;//注意，按默认的anchorPoint，width动画是同时像左右扩展的
    
    //每次变色的位置，换行一次这个也要变
    maskLayer.position = CGPointMake(0,0);
    maskLayer.bounds = CGRectMake(0, 0, 0, 25);
    maskLayer.backgroundColor = [UIColor whiteColor].CGColor;
    self.maskLable.layer.mask = maskLayer;
    self.maskLayer = maskLayer;
    
    
}

- (void)setFont:(UIFont *)font {
    self.textLable.font = font;
    self.maskLable.font = font;
}

///定义两个lab的内容
- (void)setText:(NSString *)text {
    self.textLable.text = text;
    self.maskLable.text = text;
}

//定义lab的字体的位置
- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    self.textLable.textAlignment = textAlignment;
    self.maskLable.textAlignment = textAlignment;
}

- (void)startLyricsAnimationWithTimeArray:(NSArray *)timeArray andLocationArray:(NSArray *)locationArray {
    //每行歌词的时间总长
    CGFloat totalDuration = [timeArray.lastObject floatValue]*1.0/1000;
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"bounds.size.width"];
    NSMutableArray *keyTimeArray = [NSMutableArray array];
    NSMutableArray *widthArray = [NSMutableArray array];
    for (int i = 0 ; i < timeArray.count; i++) {
        CGFloat tempTime = [timeArray[i] floatValue] *1.0/1000/totalDuration;
        [keyTimeArray addObject:@(tempTime)];
        CGFloat tempWidth = [locationArray[i] floatValue] * CGRectGetWidth(self.maskLable.frame);
        [widthArray addObject:@(tempWidth)];
    }
    animation.values = widthArray;
    animation.keyTimes = keyTimeArray;
    animation.duration = totalDuration;
    animation.calculationMode = kCAAnimationLinear;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [self.maskLayer addAnimation:animation forKey:@"MaskAnimation"];
}


- (void)stopAnimation {
    //[self pauseLayer:self.maskLayer];
    
    [self.maskLayer removeAllAnimations];
    
    self.maskLayer=nil;
}

//暂停
-(void)pauseLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    
    // 让CALayer的时间停止走动
    layer.speed = 0.0;
    // 让CALayer的时间停留在pausedTime这个时刻
    layer.timeOffset = pausedTime;
}

- (void)reAnimation
{
    [self resumeLayer:self.maskLayer];
}

//恢复
-(void)resumeLayer:(CALayer*)layer
{
    CFTimeInterval pausedTime = layer.timeOffset;
    // 1. 让CALayer的时间继续行走
    layer.speed = 1.0;
    // 2. 取消上次记录的停留时刻
    layer.timeOffset = 0.0;
    // 3. 取消上次设置的时间
    layer.beginTime = 0.0;
    // 4. 计算暂停的时间(这里也可以用CACurrentMediaTime()-pausedTime)
    CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    // 5. 设置相对于父坐标系的开始时间(往后退timeSincePause)
    layer.beginTime = timeSincePause;
}

#pragma mark - property

- (UILabel *)textLable {
    if (!_textLable) {
        _textLable = [[UILabel alloc] initWithFrame:self.bounds];
    }
    return _textLable;
}

- (UILabel *)maskLable {
    if (!_maskLable) {
        _maskLable = [[UILabel alloc] initWithFrame:self.bounds];
    }
    return _maskLable;
}
@end
