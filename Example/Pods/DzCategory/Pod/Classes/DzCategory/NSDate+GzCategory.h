//
//  NSDate+GzCategory.h
//  GzoneLib
//
//  Created by Nguyen Dung on 08/01/2015.
//  Copyright (c) Năm 2015 dungnt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (GzCategory)
-(double)getTimeStamp;
-(NSString*)toString;
-(NSString*)toStringWithformat:(NSString *)dateFormat;
@end
