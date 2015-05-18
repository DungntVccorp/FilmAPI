//
//  Subtitle.h
//  FilmAPI
//
//  Created by Nguyen Tien Dung on 5/18/15.
//  Copyright (c) 2015 DungntVccorp. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Subtitle : NSObject
@property(nonatomic)NSTimeInterval startInterval;
@property(nonatomic)NSTimeInterval endInterval;
@property(nonatomic,strong)NSString *subtitle;
@property(nonatomic,strong)NSString *uuid;

@end
