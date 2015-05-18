//
//  PlayerItem.h
//  FilmAPI
//
//  Created by Nguyen Tien Dung on 5/18/15.
//  Copyright (c) 2015 DungntVccorp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlayerItem : NSObject
@property(nonatomic,strong)NSString *file;
@property(nonatomic,strong)NSString *mediaid;
@property(nonatomic,strong)NSArray *sublabel;
@property(nonatomic,strong)NSArray *subfile;
@property(nonatomic,strong)NSString *filetitle;
@property(nonatomic,strong)NSString *title;

-(void)getPlayerlink:(void(^)(NSMutableArray *urls))complete;


@end
