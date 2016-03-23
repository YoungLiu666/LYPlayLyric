//
//  LyricsUtil.m
//  全民歌星歌词渲染demo
//
//  Created by liuyang on 16/3/16.
//  Copyright © 2016年 ly. All rights reserved.
//

#import "LyricsUtil.h"

@implementation LyricsUtil


//拿到krc歌词，返回每句歌词的当个字time组成的数据，只针对krc
+(NSMutableArray *)timeArrayWithLineLyric:(NSString *)lineLyric
{
    //去掉前面没用的歌词
    NSRange LyricTillte = [lineLyric rangeOfString:@"[offset:0]"];
    NSString *LyricBody = [lineLyric substringFromIndex:LyricTillte.location+10];
    
    //把krc歌词每个单词的time的最后一个,0 去掉。
    NSString * lineLyricd= [LyricBody stringByReplacingOccurrencesOfString:@",0>" withString:@">"];
    NSLog(@"%@",lineLyricd);
    //最后返回的时间数组，包含每一行数组的数组
    NSMutableArray * timeArray = [[NSMutableArray alloc]init];
//    //单个句歌词的时间数组
//    NSMutableArray * oneLineArray = [[NSMutableArray alloc]init];
    //把歌词按行分成数组
    NSArray *lineArray = [lineLyricd componentsSeparatedByString:@"\n"];
    for (int i=1; i<lineArray.count-1; i++) {
        //单个句歌词的时间数组
        NSMutableArray * oneLineArray = [[NSMutableArray alloc]init];
        [oneLineArray removeAllObjects];
        //截取总时间以后的字符串，因为我要返回每个字的时间数组
        NSRange start = [lineArray[i] rangeOfString:@"]"];
        NSString *sub = [lineArray[i] substringFromIndex:start.location+1];
        NSLog(@"%@", sub);
        //把sub按>分成数组
        NSArray * array = [sub componentsSeparatedByString:@">"];
        for (int y = 0; y<array.count-1; y++) {
            //取出每个单词的开始时间
            NSRange start = [array[y] rangeOfString:@"<"];
            NSRange end = [array[y] rangeOfString:@","];
            NSString *sub1 = [array[y] substringWithRange:NSMakeRange(start.location+1, end.location-start.location-1)];
            [oneLineArray addObject:sub1];
        }
        
        //因为最后一个时间没取到，在这里拿到最后一个单词的延长时间加上最后一个单词的开始时间为最终时间，加到oneLineArray数组的后面
        NSRange start1 = [array[array.count-2] rangeOfString:@","];
        NSString *sub2 = [array[array.count-2] substringFromIndex:start1.location+1];
        NSString * lastTime = oneLineArray[oneLineArray.count-1];
        int sub2N = [sub2 intValue];
        int lastTimeN = [lastTime intValue];
        int lastN = sub2N + lastTimeN;
        NSString * lastStr = [NSString stringWithFormat:@"%d",lastN];
        
        [oneLineArray addObject:lastStr];
        
        [timeArray addObject:oneLineArray];
    }
   
    NSLog(@"%@",timeArray);
    
    return timeArray;
}

//得到每一行开始时间的数组,可根据时间判断换行
+(NSMutableArray *)startTimeArrayWithLineLyric:(NSString *)lineLyric
{
    NSRange LyricTillte = [lineLyric rangeOfString:@"[offset:0]"];
    NSString *LyricBody = [lineLyric substringFromIndex:LyricTillte.location+10];
    
    NSMutableArray * stratTimeArray = [[NSMutableArray alloc]init];
     NSArray *array = [LyricBody componentsSeparatedByString:@"\n"];
    
    for (int i = 1; i<array.count-1; i++) {
        //截取每行的开始时间
        NSRange start = [array[i] rangeOfString:@"["];
        NSRange end = [array[i] rangeOfString:@","];
        NSString *sub = [array[i] substringWithRange:NSMakeRange(start.location+1, end.location-start.location-1)];
        NSLog(@"%@", sub);
        
        [stratTimeArray addObject:sub];

    }
    NSLog(@"%@",stratTimeArray);
    
    return stratTimeArray;
}

//得到不带时间的歌词
+(NSMutableString *)getLyricStringWithLyric:(NSString *)lineLyric
{
    NSRange LyricTillte = [lineLyric rangeOfString:@"[offset:0]"];
    NSString *LyricBody = [lineLyric substringFromIndex:LyricTillte.location+10];
    
    NSMutableString * LyricStr = [[NSMutableString alloc]init];
    
    NSArray *lineArray = [LyricBody componentsSeparatedByString:@"\n"];
    
    for (int i=1; i<lineArray.count-1; i++) {
        NSArray * array = [lineArray[i] componentsSeparatedByString:@"<"];
        NSLog(@"%@",array);
        NSString * lineStr = [NSString string];
        for (int y=1; y<array.count; y++) {
            NSRange start = [array[y] rangeOfString:@">"];
            NSString *sub1 = [array[y] substringFromIndex:start.location+1];
            lineStr = [lineStr stringByAppendingString:sub1];
            NSLog( @"%@",sub1);
            
        }
        [LyricStr appendString:lineStr];
        [LyricStr appendString:@"\n"];
        
    }
    return LyricStr;
}

//得到不带时间的歌词的数组
+(NSMutableArray *)getLyricSArrayWithLyric:(NSString *)lineLyric
{
    NSRange LyricTillte = [lineLyric rangeOfString:@"[offset:0]"];
    NSString *LyricBody = [lineLyric substringFromIndex:LyricTillte.location+10];
    
    NSMutableArray * lyricSArray = [[NSMutableArray alloc]init];
    
    NSArray *lineArray = [LyricBody componentsSeparatedByString:@"\n"];
    
    for (int i=1; i<lineArray.count-1; i++) {
        NSArray * array = [lineArray[i] componentsSeparatedByString:@"<"];
        NSLog(@"%@",array);
        NSString * lineStr = [NSString string];
        for (int y=1; y<array.count; y++) {
            NSRange start = [array[y] rangeOfString:@">"];
            NSString *sub1 = [array[y] substringFromIndex:start.location+1];
            lineStr = [lineStr stringByAppendingString:sub1];
            NSLog( @"%@",sub1);
            
        }
        [lyricSArray addObject:lineStr];
        
    }
    return lyricSArray;
}

//得到歌词的总行
+(int)getLyricLineNumWithLyric:(NSString *)lineLyric
{
    NSRange LyricTillte = [lineLyric rangeOfString:@"[offset:0]"];
    NSString *LyricBody = [lineLyric substringFromIndex:LyricTillte.location+10];
     int lineNum;
     NSArray *lineArray = [LyricBody componentsSeparatedByString:@"\n"];
     lineNum = lineArray.count -2;
    
    return lineNum;
}

//得到每行歌词有多少个字的数组
+(NSMutableArray *)getLineLyricWordNmuWithLyric:(NSString *)lineLyric
{
    NSMutableArray * wordNumArray = [[NSMutableArray alloc]init];
    NSRange LyricTillte = [lineLyric rangeOfString:@"[offset:0]"];
    NSString *LyricBody = [lineLyric substringFromIndex:LyricTillte.location+10];
    
     NSArray *lineArray = [LyricBody componentsSeparatedByString:@"\n"];
    for (int i=1; i<lineArray.count-1; i++) {
        NSArray * array = [lineArray[i] componentsSeparatedByString:@"<"];
        int num = array.count-1;
        NSString * sNum = [NSString stringWithFormat:@"%d",num];
        [wordNumArray addObject:sNum];
    }
    
    
    return wordNumArray;
}

//得到最大行的字体个数
+(int)getMaxLineNumWithArray:(NSMutableArray *)lineNumArray
{
    int max;
    
    max = [[lineNumArray valueForKeyPath:@"@max.intValue"] intValue];

    return max;
}
@end
