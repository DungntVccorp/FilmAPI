//
//  FilmAPI.h
//  FilmAPI
//
//  Created by Nguyen Tien Dung on 5/18/15.
//  Copyright (c) 2015 DungntVccorp. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
#import <TFHpple.h>
#import <FCFileManager.h>
#import <XMLDictionary.h>
#import <NSString+GzCategory.h>
@class FilmChapter;
@class PlayerItem;
@class FilmModel;
@interface FilmAPI : NSObject
@property(nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property(nonatomic,strong)NSDictionary *dataParser;
+ (instancetype)sharedAPI;

-(void)GetHomePageWithDone:(void (^)(BOOL success,NSArray *listBanner,NSArray *listFilm,NSDictionary *leftMenu))done;
-(void)GetGroupWithUrl:(NSString *)grUrl Done:(void (^)(BOOL success,NSString *nextpage,NSArray *filmInpage))done;
-(void)LoadFilmInfoWithURL:(NSString *)url onComplete:(void (^)(BOOL success,FilmModel *fm))complete;
-(void)LoadFilmChapterWithUrl:(NSString *)url refLink:(NSString *)ref onComplete:(void (^)(BOOL success,NSArray *chaps))complete;
-(void)LoadDirectLinkWithChap:(FilmChapter *)chap onComplete:(void (^)(BOOL success,PlayerItem *listDirectLink))complete;
-(void)SearchFilmWithName:(NSString *)filmSearchtext onComplete:(void (^)(BOOL success,NSArray *listFilmSearch))complete;
@end
