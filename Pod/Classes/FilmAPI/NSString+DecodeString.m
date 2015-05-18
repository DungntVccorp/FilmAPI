//
//  NSString+DecodeString.m
//  HDOnline
//
//  Created by Nguyen Tien Dung on 5/5/15.
//  Copyright (c) 2015 Nguyen Tien Dung. All rights reserved.
//

#import "NSString+DecodeString.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (DecodeString)
- (NSString *) md5:(NSString *) input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (int)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
    
}
-(NSString *)decode{
    NSString *key = @"hdpro123xvactuanvu";
    int _local10;
    int _local11;
    NSString *_local2 = @"";
    NSString *_local3 = @"1234567890qwertyuiopasdfghjklzxcvbnm";
    int _local4 = (int)_local3.length;
    
    NSString *_local5 = [self md5:key];
    NSString *_local6 = [self substringWithRange:NSMakeRange(_local4*2 + 32, self.length - (_local4*2 + 32))];
    NSString *_local7 = [self substringWithRange:NSMakeRange(0,_local4*2)];
    NSString *_local8 = @"";
    
    _local10 = 0;
    while (_local10 < (_local4 * 2)) {
        
        _local11 = (int)[_local3 rangeOfString:[_local7 substringWithRange:NSMakeRange(_local10, 1)]].location*_local4;
        _local11 = _local11 + (int)[_local3 rangeOfString:[_local7 substringWithRange:NSMakeRange(_local10+1, 1)]].location;
        int tem = floor(_local10 / 2);
        int tem2 = tem%_local5.length;
        int intchar = [[_local5 substringWithRange:NSMakeRange(tem2, 1)] characterAtIndex:0];
        _local11 = _local11 - intchar;
        _local8 = [_local8 stringByAppendingString:[NSString stringWithFormat:@"%c",_local11]];
        _local10 = _local10 + 2;
    }
    _local10 = 0;
    while (_local10 < _local6.length) {
        _local11 = (int)[_local3 rangeOfString:[_local6 substringWithRange:NSMakeRange(_local10, 1)]].location*_local4;
        _local11 = _local11 + (int)[_local3 rangeOfString:[_local6 substringWithRange:NSMakeRange(_local10+1, 1)]].location;
        int tem = floor(_local10 / 2);
        int tem2 = tem%_local4;
        int intchar = [[_local8 substringWithRange:NSMakeRange(tem2, 1)] characterAtIndex:0];
        _local11 = _local11 - intchar;
        _local2 = [_local2 stringByAppendingString:[NSString stringWithFormat:@"%c",_local11]];
        _local10 = _local10 + 2;
    }
    return _local2;
}

@end
