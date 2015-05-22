//
//  PlayerItem.m
//  FilmAPI
//
//  Created by Nguyen Tien Dung on 5/18/15.
//  Copyright (c) 2015 DungntVccorp. All rights reserved.
//

#import "PlayerItem.h"
#import "NSString+DecodeString.h"
#import "M3U8.h"
#import <NSString+GzCategory.h>
#import "Subtitle.h"
@implementation PlayerItem

-(void)getPlayerlink:(void (^)(NSMutableArray *))complete{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if([self.file rangeOfString:@"list.m3u8"].location != NSNotFound){
            NSMutableArray *list = [NSMutableArray new];
            M3U8 *m3 = [M3U8 new];
            m3.URI = [self.file stringByReplacingOccurrencesOfString:@"playlist.m3u8" withString:@"list.m3u8"];
            [list addObject:m3];
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(list);
            });
        }
        else{
            self.file = [self.file decode];
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:self.file]];
            NSString *StringData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            if([StringData rangeOfString:@"list.m3u8"].location != NSNotFound){
                NSMutableArray *list = [NSMutableArray new];
                M3U8 *m3 = [M3U8 new];
                m3.URI = [self.file stringByReplacingOccurrencesOfString:@"playlist.m3u8" withString:@"list.m3u8"];
                [list addObject:m3];
                dispatch_async(dispatch_get_main_queue(), ^{
                    complete(list);
                });
            }
            else if([StringData rangeOfString:@"#EXT-X-VERSION"].location != NSNotFound){
                NSArray *arrtemp = [StringData componentsSeparatedByString:@"\n"];
                int index = 0;
                NSMutableArray *list = [NSMutableArray new];
                for(NSString *str in arrtemp){
                    if([str rangeOfString:@"#EXT-X-STREAM-INF"].location != NSNotFound)
                    {
                        NSString *bandwidth = [[[[str componentsSeparatedByString:@"BANDWIDTH="] lastObject] componentsSeparatedByString:@",CODECS="] firstObject];
                        NSString *resolution = [[[[[str componentsSeparatedByString:@"ESOLUTION="] lastObject] componentsSeparatedByString:@"x"] firstObject] stringByAppendingString:@"P"];
                        NSString *URI = arrtemp[index +1];
                        M3U8 *m3 = [M3U8 new];
                        m3.bandwidth = bandwidth;
                        m3.resolution = resolution;
                        m3.URI = URI;
                        [list addObject:m3];
                    }
                    index += 1;
                }
                complete(list);
            }
            
        }
    });
}
-(NSTimeInterval)timeFromString:(NSString *)timeString{
    NSScanner *scanner = [NSScanner scannerWithString:timeString];
    int h,m,s,c = 0;
    [scanner scanInt:&h];
    [scanner scanString:@":" intoString:nil];
    [scanner scanInt:&m];
    [scanner scanString:@":" intoString:nil];
    [scanner scanInt:&s];
    [scanner scanString:@"," intoString:nil];
    [scanner scanInt:&c];
    double xx = h*3600;
    xx += m*60;
    xx += s;
    xx += c/1000.0;
    return xx;
}
-(void)getListSubtitleWidthCurrentIndex:(int)index complete:(void(^)(NSMutableArray *subs))complete{
    if(self.subfile == nil || index > self.subfile.count - 1){
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(nil);
        });
    }
    else{
        NSString *linkSub = self.subfile[index];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:linkSub]];
            if(data == nil){
                dispatch_async(dispatch_get_main_queue(), ^{
                    complete(nil);
                });
            }
            else{
                NSString *StringData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                if(StringData != nil){
                    if([StringData contains:@"***"] == true || [StringData contains:@"vplugin***"] == true){
                        NSString *baseStringEndcode = [[StringData componentsSeparatedByString:@"***"] lastObject];
                        baseStringEndcode = [baseStringEndcode decode];
                        NSData *base64Data = [[NSData alloc]initWithBase64EncodedString:baseStringEndcode options:NSDataBase64DecodingIgnoreUnknownCharacters];
                        NSString *decodedString = [[NSString alloc] initWithData:base64Data encoding:NSUTF8StringEncoding];
                        if(decodedString != nil){
                            complete([self parserSTRString:decodedString]);
                        }
                        else{
                            dispatch_async(dispatch_get_main_queue(), ^{
                                complete(nil);
                            });
                        }
                    }
                    else{
                        complete([self parserSTRString:StringData]);
                    }
                }
                else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        complete(nil);
                    });
                }
            }
        });
    }
}
-(NSString *) stringByStrippingHTML:(NSString *)input {
    NSRange r;
    NSString *s = [input copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound){
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    }
    return s;
}
-(NSMutableArray *)parserSTRString:(NSString *)str{
    NSMutableArray *listSub = [NSMutableArray new];
    NSScanner *scanner = [NSScanner scannerWithString:str];
    while (!scanner.atEnd) {
        NSString *indexString = @"";
        [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&indexString];
        NSString *startString = @"";
        [scanner scanUpToString:@" --> " intoString:&startString];
        NSString *endString = @"";
        [scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&endString];
        endString = [endString stringByReplacingOccurrencesOfString:@"--> " withString:@""];
        NSString *textString = @"";
        [scanner scanUpToString:@"\r\n\r\n" intoString:&textString];
        textString = [textString stringByStrippingWhitespace];
        textString = [self stringByStrippingHTML:textString];
        Subtitle *sub = [Subtitle new];
        sub.uuid = indexString != nil ? indexString : nil;
        sub.startInterval =  startString != nil  ? [self timeFromString:startString] : 0;
        sub.endInterval =  startString != nil  ? [self timeFromString:endString] : 0;
        sub.subtitle = textString != nil ? textString : nil;
        [listSub addObject:sub];
    }
    return listSub;
}

@end
