//
//  GzDateFormatter.h
//  GzoneLib
//
//  Created by Nguyen Dung on 22/01/2015.
//  Copyright (c) Năm 2015 dungnt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GzDateFormatter : NSDateFormatter
+(instancetype)shareWithFormat:(NSString *)format;
@end
