//
//  LyricsUtil.h
//  全民歌星歌词渲染demo
//
//  Created by liuyang on 16/3/16.
//  Copyright © 2016年 ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricsUtil : NSObject

//根据每行歌词得到相应行的给个字的时间点数组
+(NSMutableArray *)timeArrayWithLineLyric:(NSString *)lineLyric;

//得到每一行开始时间的数组
+(NSMutableArray *)startTimeArrayWithLineLyric:(NSString *)lineLyric;

//得到不带时间的歌词
+(NSMutableString *)getLyricStringWithLyric:(NSString *)lineLyric;

//得到歌词的总行
+(int)getLyricLineNumWithLyric:(NSString *)lineLyric;

//得到不带时间的歌词的数组
+(NSMutableArray *)getLyricSArrayWithLyric:(NSString *)lineLyric;

//得到每行歌词有多少个字的数组
+(NSMutableArray *)getLineLyricWordNmuWithLyric:(NSString *)lineLyric;

//得到最大行的字体个数
+(int)getMaxLineNumWithArray:(NSMutableArray *)lineNumArray;

@end
