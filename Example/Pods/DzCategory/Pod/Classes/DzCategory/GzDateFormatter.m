//
//  GzDateFormatter.m
//  GzoneLib
//
//  Created by Nguyen Dung on 22/01/2015.
//  Copyright (c) Năm 2015 dungnt. All rights reserved.
//

#import "GzDateFormatter.h"

@implementation GzDateFormatter
+(instancetype)shareWithFormat:(NSString *)format{
    static GzDateFormatter *share = nil;
    
    // 2
    static dispatch_once_t oncePredicate;
    
    // 3
    dispatch_once(&oncePredicate, ^{
        share = [[GzDateFormatter alloc]init];
    });
    if(format){
        [share setDateFormat:format];
    }
    return share;
}
@end
