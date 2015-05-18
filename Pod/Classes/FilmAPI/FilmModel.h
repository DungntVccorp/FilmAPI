//
//  FilmModel.h
//  HDOnline
//
//  Created by Nguyen Tien Dung on 4/21/15.
//  Copyright (c) 2015 Nguyen Tien Dung. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FilmModel : NSObject
@property(nonatomic,strong)NSString *FilmName;
@property(nonatomic,strong)NSString *filmBanner;
@property(nonatomic,strong)NSString *filmImage;
@property(nonatomic,strong)NSString *filmURL;
@property(nonatomic,strong)NSString *filmID;
@property(nonatomic,strong)NSString *filmIncategory;
@property(nonatomic,strong)NSArray  *filmScreenShots;
@property(nonatomic,strong)NSString *engName;
@property(nonatomic,strong)NSString *oginalName;
@property(nonatomic,strong)NSArray  *filmtype;
@property(nonatomic,strong)NSArray  *filmcountry;
@property(nonatomic,strong)NSString *filmTime;
@property(nonatomic,strong)NSString *filmRate;
@property(nonatomic,strong)NSString *filmQuantity;
@property(nonatomic,strong)NSString *filmAudioQuantity;
@property(nonatomic,strong)NSArray  *filmDrector;
@property(nonatomic,strong)NSString *filmtrailer;
@property(nonatomic,strong)NSString *filmDescription;
@property(nonatomic,strong)NSString *filmUUID;
@property(nonatomic,strong)NSString *filmComplete;

@end
