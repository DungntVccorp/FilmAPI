//
//  FilmChapter.h
//  FilmAPI
//
//  Created by Nguyen Tien Dung on 5/18/15.
//  Copyright (c) 2015 DungntVccorp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilmChapter : NSObject

@property(nonatomic,strong)NSString *chapName;
@property(nonatomic,strong)NSString *chapThumb;
@property(nonatomic,strong)NSString *chapThumbBackup;
@property(nonatomic,strong)NSString *chapFile;
@property(nonatomic,strong)NSString *chapBackuplink;
@property(nonatomic,strong)NSString *chapSubtitle;
@property(nonatomic,strong)NSString *chapRef;
@property(nonatomic,strong)NSString *chapID;

-(void)chapFileDecode:(void(^)(NSString *chapdecode))complete;
-(void)chapBackupFileDecode:(void(^)(NSString *chapdecode))complete;


@end
