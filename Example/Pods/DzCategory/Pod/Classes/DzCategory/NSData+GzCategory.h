//
//  NSData+GzCategory.h
//  GzoneLib
//
//  Created by Nguyen Dung on 13/01/2015.
//  Copyright (c) Năm 2015 dungnt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (GzCategory)
//===========================================================
//  Base 64
//===========================================================
+ (NSData *)dataFromBase64String:(NSString *)aString;
- (NSString *)base64EncodedString;
- (NSString *)base64EncodedStringWithSeparateLines:(BOOL)separateLines;
//===========================================================
//  MD 5
//===========================================================
+(NSData *)MD5Digest:(NSData *)input;
-(NSData *)MD5Digest;

+(NSString *)MD5HexDigest:(NSData *)input;
-(NSString *)MD5HexDigest;
@end
