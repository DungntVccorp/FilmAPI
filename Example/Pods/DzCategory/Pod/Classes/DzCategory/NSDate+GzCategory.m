//
//  NSDate+GzCategory.m
//  GzoneLib
//
//  Created by Nguyen Dung on 08/01/2015.
//  Copyright (c) Năm 2015 dungnt. All rights reserved.
//

#import "NSDate+GzCategory.h"

#import "GzDateFormatter.h"

#import "GzDateFormatter.h"


@implementation NSDate (GzCategory)
-(double)getTimeStamp{
    return self.timeIntervalSince1970;
}
-(NSString*)toString{
    return [[GzDateFormatter shareWithFormat:@"dd/MM/YYYY hh:mm:ss"] stringFromDate:self];
}
-(NSString*)toStringWithformat:(NSString *)dateFormat{
    return [[GzDateFormatter shareWithFormat:dateFormat] stringFromDate:self];
}
@end
