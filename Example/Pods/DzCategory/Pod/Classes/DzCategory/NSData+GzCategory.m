//
//  NSData+GzCategory.m
//  GzoneLib
//
//  Created by Nguyen Dung on 13/01/2015.
//  Copyright (c) Năm 2015 dungnt. All rights reserved.
//

#import "NSData+GzCategory.h"
#import <CommonCrypto/CommonDigest.h>
@implementation NSData (GzCategory)
//===========================================================
//  Base 64
//===========================================================
+ (NSData *)dataFromBase64String:(NSString *)aString
{
    return [[NSData alloc] initWithBase64EncodedString:aString options:NSDataBase64DecodingIgnoreUnknownCharacters];
}
- (NSString *)base64EncodedString{
    return [self base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
}
- (NSString *)base64EncodedStringWithSeparateLines:(BOOL)separateLines{
    if(separateLines){
        return [self base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    }
    else{
        return [self base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
}
//===========================================================
//  MD 5
//===========================================================
+(NSData *)MD5Digest:(NSData *)input {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(input.bytes, (int)input.length, result);
    return [[NSData alloc] initWithBytes:result length:CC_MD5_DIGEST_LENGTH];
}

-(NSData *)MD5Digest {
    return [NSData MD5Digest:self];
}

+(NSString *)MD5HexDigest:(NSData *)input {
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(input.bytes, (int)input.length, result);
    NSMutableString *ret = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH*2];
    for (int i = 0; i<CC_MD5_DIGEST_LENGTH; i++) {
        [ret appendFormat:@"%02x",result[i]];
    }
    return ret;
}

-(NSString *)MD5HexDigest {
    return [NSData MD5HexDigest:self];
}

@end
