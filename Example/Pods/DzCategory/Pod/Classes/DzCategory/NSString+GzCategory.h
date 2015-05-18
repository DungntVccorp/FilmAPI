//
//  NSString+GzCategory.h
//  GzoneLib
//
//  Created by Nguyen Dung on 08/01/2015.
//  Copyright (c) Năm 2015 dungnt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (GzCategory)
-(NSString *)MD5;
-(NSString *)sha1;
-(NSString *)reverse;
-(NSString *)URLEncode;
-(NSString *)URLDecode;
-(NSString *)stringByStrippingWhitespace;
-(NSString *)substringFrom:(NSInteger)from to:(NSInteger)to;
-(NSString *)CapitalizeFirst:(NSString *)source;
-(NSString *)UnderscoresToCamelCase:(NSString*)underscores;
-(NSString *)CamelCaseToUnderscores:(NSString *)input;
-(NSUInteger)countWords;
-(NSData*)dataFromBase64String;
-(NSData*)data;
-(BOOL)contains:(NSString *)string;
-(BOOL)isBlank;
-(BOOL)isEmail;
-(BOOL)passwordIsValid;
-(BOOL)UserNameIsValid;
-(NSString *)normalizeVietnameseString;
@end
