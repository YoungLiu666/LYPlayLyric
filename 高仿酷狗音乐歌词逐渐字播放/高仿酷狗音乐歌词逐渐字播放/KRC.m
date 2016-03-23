//
//  KRC.m
//  KRCPARSER
//
//  Created by kipen on 16/3/16.
//  Copyright © 2016年 kipen. All rights reserved.
//

#import "KRC.h"
#import "GTMNSData+zlib.h"

@implementation KRC

//异或加密 密钥
- (NSString *) Decode: (NSString * )filePath
{
    NSString * EncKey = @"@Gaw^2tGQ61-ÎÒni";
    //char EncKey[] = { '@', 'G', 'a', 'w', '^', '2', 't', 'G', 'Q', '6', '1', '-', 'Î', 'Ò', 'n', 'i' };
    
    NSData * totalBytes = [[NSMutableData alloc] initWithContentsOfFile:filePath];
    //HeadBytes = [[NSMutableData alloc] initWithData:[totalBytes subdataWithRange:NSMakeRange(0, 4)]];
    EncodedBytes = [[NSMutableData alloc] initWithData:[totalBytes subdataWithRange:NSMakeRange(4, totalBytes.length - 4)]];
    
    ZipBytes = [[NSMutableData alloc] initWithCapacity:EncodedBytes.length];
    
    Byte * encodedBytes = EncodedBytes.mutableBytes;
    
    int EncodedBytesLength = EncodedBytes.length;
    
    for (int i = 0; i < EncodedBytesLength; i++)
    {
        int l = i % 16;
        char c = [EncKey characterAtIndex:l];
        
        Byte b = (Byte)((encodedBytes[i]) ^ c);
        
        [ZipBytes appendBytes:&b length:1];
        
    }
    UnzipBytes = [NSData gtm_dataByInflatingData:ZipBytes];
    
    NSString * s = [[NSString alloc] initWithData:UnzipBytes encoding:NSUTF8StringEncoding];
    
    return s;
}

@end