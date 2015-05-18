//
//  FilmChapter.m
//  FilmAPI
//
//  Created by Nguyen Tien Dung on 5/18/15.
//  Copyright (c) 2015 DungntVccorp. All rights reserved.
//

#import "FilmChapter.h"
#import "NSString+DecodeString.h"
@implementation FilmChapter
-(void)chapFileDecode:(void(^)(NSString *chapdecode))complete{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *str = [self.chapFile decode];
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(str);
        });
        
    });
}
-(void)chapBackupFileDecode:(void(^)(NSString *chapdecode))complete{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *str = [self.chapBackuplink decode];
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(str);
        });
        
    });
}

@end
