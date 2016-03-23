//
//  KRC.h
//  KRCPARSER
//
//  Created by kipen on 16/3/16.
//  Copyright © 2016年 kipen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KRC : NSObject
{
    //FileStream fs;
    
    //头部4字节
    NSMutableData * HeadBytes;
    
    //异或加密内容
    NSMutableData * EncodedBytes;
    
    //解异或加密后ZIP数据
    NSMutableData * ZipBytes;
    
    //UNZIP后数据
    NSData * UnzipBytes;
}

- (NSString *) Decode: (NSString * )filePath;

@end