//
//  ViewController.m
//  高仿酷狗音乐歌词逐渐字播放
//
//  Created by liuyang on 16/3/21.
//  Copyright © 2016年 ly. All rights reserved.
//

#import "ViewController.h"
#import "LyricsUtil.h"
#import "LyricsView.h"
#import "KRC.h"
#import <AVFoundation/AVFoundation.h>
#define W [UIScreen mainScreen].bounds.size.width
#define H [UIScreen mainScreen].bounds.size.height
@interface ViewController ()<AVAudioPlayerDelegate>
@property (nonatomic, strong) LyricsView *lyricsView;//歌词视图，里面是两个lab
@property (nonatomic,weak) UIScrollView * backScrollView;//歌词滑动的ScrollView

@end

@implementation ViewController
{
    AVAudioPlayer * _player;
    BOOL _isPlaying;
    //歌词
    NSString * _lyrics;
    CGSize size;
    int time;
    //每句的时间数组
    NSMutableArray * _timeArray;
    //换行时间数组
    NSMutableArray * _startTimeArray;
    //纯歌词
    NSMutableString * _lyricsStr;
    //纯歌词数组
    NSMutableArray * _lyricsSArray;
    //每行歌词单词个数的数组
    NSMutableArray * _wordNumArray;
    //最大行的歌词的个数
    int _maxNum;
    CGSize lineSize;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    UIImageView * imageView = [[UIImageView alloc]init];
    imageView.frame = self.view.frame;
    [imageView setImage:[UIImage imageNamed:@"bj_sing"]];
    [self.view addSubview:imageView];
    
    //拿到歌词
    NSString *path = [[NSBundle mainBundle] pathForResource:@"lll.Krc" ofType:nil];
    
    KRC * krc = [KRC new];
    _lyrics = [krc Decode:path];
    
    //播放歌
    NSURL * url = [[NSBundle mainBundle]URLForResource:@"vocal" withExtension:@"mp3"];
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    _player.delegate = self;
    [_player prepareToPlay];
    _isPlaying = YES;
    
    //拿到歌词的所有数据
    [self getLyricsInfo];
    
    //创建ScrollView及其视图
    [self createBackScrollView];
    
    //创建点击开始按钮
    [self createPlayBtn];
    
}

-(void)getLyricsInfo
{
    //得到没句的时间
    _timeArray = [LyricsUtil timeArrayWithLineLyric:_lyrics];
    //得到换行时间
    _startTimeArray = [LyricsUtil startTimeArrayWithLineLyric:_lyrics];
    //得到纯歌词
    _lyricsStr = [LyricsUtil getLyricStringWithLyric:_lyrics];
    //得到纯歌词数组
    _lyricsSArray = [LyricsUtil getLyricSArrayWithLyric:_lyrics];
    //每行歌词单词个数的数组
    _wordNumArray = [LyricsUtil getLineLyricWordNmuWithLyric:_lyrics];
    _maxNum = [LyricsUtil getMaxLineNumWithArray:_wordNumArray];
}

-(void)createBackScrollView
{
    UIScrollView * backScrollView = [[UIScrollView alloc]init];
    self.backScrollView = backScrollView;
    [self.view addSubview:backScrollView];
    backScrollView.frame = CGRectMake(0, 80, W, H-160);
    
    time = 0;
    LyricsView * lyricsView = [[LyricsView alloc] initWithFrame:CGRectMake(10, 100, 355, 60)];
    lyricsView.center = CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds) / 2, 200);
    lyricsView.backgroundColor = [UIColor clearColor];
    //传过去两个lab的字体大小
    lyricsView.font = [UIFont systemFontOfSize:16];
    
    //把字符串传给两个lab
    lyricsView.text = _lyricsStr;
    //得到歌词的行数
    lyricsView.textLable.numberOfLines =[LyricsUtil getLyricLineNumWithLyric:_lyrics];
    lyricsView.maskLable.numberOfLines =[LyricsUtil getLyricLineNumWithLyric:_lyrics];
    
    //设置两个lab的行间距
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:lyricsView.textLable.text];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:10];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [lyricsView.textLable.text length])];
    lyricsView.textLable.attributedText = attributedString;
    
    NSMutableAttributedString *attributedString1 = [[NSMutableAttributedString alloc]initWithString:lyricsView.maskLable.text];
    NSMutableParagraphStyle *paragraphStyle1 = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle1 setLineSpacing:10];
    [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [lyricsView.maskLable.text length])];
    lyricsView.maskLable.attributedText = attributedString1;
    lyricsView.textAlignment = NSTextAlignmentCenter;
    
    //正常步骤，知道歌词，知道lab字体大小算出歌词的
    size = [_lyricsStr sizeWithFont:lyricsView.textLable.font
                  constrainedToSize:(CGSize){lyricsView.textLable.frame.size.width, NSIntegerMax}
                      lineBreakMode:lyricsView.textLable.lineBreakMode];
    
    [self.backScrollView addSubview:lyricsView];
    self.lyricsView = lyricsView;
    
    lineSize = [_lyricsSArray[0] sizeWithFont:self.lyricsView.textLable.font constrainedToSize:CGSizeMake(self.lyricsView.textLable.frame.size.width, MAXFLOAT) lineBreakMode:NSLineBreakByCharWrapping];
    
    size.height =(lineSize.height-9) * _lyricsSArray.count;
    
    self.backScrollView.contentSize = (CGSize){size.width, size.height+300};
    lyricsView.frame = CGRectMake(10, 10, W-20, size.height);
    
    [lyricsView.maskLable setFrame:CGRectMake(W/2-size.width/2, 0, size.width, size.height)];
    [lyricsView.textLable setFrame:CGRectMake(W/2-size.width/2, 0, size.width, size.height)];
}

-(void)createPlayBtn
{
    UIButton * playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:playBtn];
    playBtn.frame = CGRectMake(5,H-60, 100, 60);
    [playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    playBtn.selected = NO;
    [playBtn setTitle:@"播放" forState:UIControlStateNormal];
    [playBtn setTitle:@"停止" forState:UIControlStateSelected];
    playBtn.backgroundColor = [UIColor redColor];
}

//播放结束的时候会被调用
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    NSLog(@"播放结束");
}
//协议中的方法，当播放被打断时被调用。当播放音乐时电话响了，短信响了都会打断音乐播放，我们通常需要暂停播放
-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    [_player stop];//暂停而不是停止
}
//协议中的方法，当结束打断（比如电话接完了）的时候会被调用
-(void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
    if (_isPlaying) {
        [_player play];//继续播放
    }
    
}

-(void)playBtnClick:(UIButton *)btn
{
    if (btn.selected == NO) {
        [_player play];
        //设置监控 每秒刷新一次时间
        [NSTimer scheduledTimerWithTimeInterval:0.01f
                                         target:self
                                       selector:@selector(changeTime)
                                       userInfo:nil
                                        repeats:YES];
        if (self.lyricsView.maskLayer == nil) {
            [self.lyricsView setupDefault];
        }
        
        btn.selected = YES;
    }else{
        
        btn.selected = NO;
        [_player stop];
        [self.lyricsView stopAnimation];
    }
    
}

//判断换行
-(void)changeTime
{
    
    for (int i=0; i<_startTimeArray.count; i++) {
        int startTime = [_startTimeArray[i] intValue];
        float currentTime = startTime*1.0/1000;
        if (currentTime - _player.currentTime>=0 && currentTime - _player.currentTime<=0.02) {
            [self changeLineWithNmu:i];
        }
        
    }
    
}
//改变变色mask位置和动画传值
-(void)changeLineWithNmu:(int)num
{
    
    self.lyricsView.maskLayer.position = CGPointMake(0,(lineSize.height-9)*(num));
    self.lyricsView.maskLayer.bounds = CGRectMake(0, 0, 0, lineSize.height-9);
    
    if (num >= 8) {
        [self.backScrollView setContentOffset:CGPointMake(0,(num-7)*(lineSize.height-9)+5) animated:YES];
    }
    
    //timeArray每行歌词的每个单词的开始时间，必须以0开头，总时间结尾
    NSArray *timeArray = _timeArray[num];
    NSMutableArray * timeSumArray = [[NSMutableArray alloc]init];
    int wordNmu = [_wordNumArray[num]intValue];
    int start =(_maxNum-wordNmu)/2;
    int end = start+wordNmu;
    for (int y=0; y<=_maxNum; y++) {
        if (y<=start) {
            [timeSumArray addObject:@"0"];
        }else if(y>end){
            [timeSumArray addObject:timeArray[timeArray.count-1]];
        }
        else{
            [timeSumArray addObject:timeArray[y-start-1]];
        }
        
    }
    
    NSArray * timeEndArray = timeSumArray;
    //计算
    //locationArray每行歌词的每个单词在相应时间时对应的位置，假设为1总长，在歌词view里用比例乘宽度得到位置
    NSMutableArray * localArray =[[NSMutableArray alloc]init];
    for (int i=0; i<=_maxNum; i++) {
        float n = i*1.0/_maxNum;
        NSString * wordSNum = [NSString stringWithFormat:@"%lf",n];
        [localArray addObject:wordSNum];
    }
    NSArray *locationArray = localArray;
    [self.lyricsView startLyricsAnimationWithTimeArray:timeEndArray andLocationArray:locationArray];
    
}

@end
