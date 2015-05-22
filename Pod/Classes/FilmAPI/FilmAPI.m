//
//  FilmAPI.m
//  FilmAPI
//
//  Created by Nguyen Tien Dung on 5/18/15.
//  Copyright (c) 2015 DungntVccorp. All rights reserved.
//

#import "FilmAPI.h"
#import "FilmModel.h"
#import "FilmChapter.h"
#import "PlayerItem.h"
@implementation FilmAPI
+ (instancetype)sharedAPI {
    static FilmAPI *_sharedAPI = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedAPI = [[FilmAPI alloc] init];
        _sharedAPI.manager = [AFHTTPRequestOperationManager manager];
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        securityPolicy.allowInvalidCertificates = YES;
        _sharedAPI.manager.securityPolicy = securityPolicy;
        _sharedAPI.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        NSString *path = [FCFileManager pathForDocumentsDirectory];
        path = [path stringByAppendingString:@"/data.plist"];
        _sharedAPI.dataParser = [NSDictionary dictionaryWithContentsOfFile:path];
        if(_sharedAPI == nil){
            
        }
    });
    
    return _sharedAPI;
}
-(NSString *) stringByStrippingHTML:(NSString *)input {
    NSRange r;
    NSString *s = [input copy];
    while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound){
        s = [s stringByReplacingCharactersInRange:r withString:@""];
    }
    return s;
}
-(void)GetHomePageWithDone:(void (^)(BOOL success,NSArray *listBanner,NSArray *listFilm,NSDictionary *leftMenu))done{
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:self.dataParser[@"A01"]]];
    [request setValue:self.dataParser[@"A72"] forHTTPHeaderField:self.dataParser[@"A73"]];
    [request setValue:self.dataParser[@"A95"] forHTTPHeaderField:self.dataParser[@"A74"]];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *xmlData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if(xmlData){
            NSMutableArray *arrFilm = [NSMutableArray new];
            TFHpple *document = [[TFHpple alloc]initWithHTMLData:xmlData];
            NSArray *banner = [document searchWithXPathQuery:self.dataParser[@"A02"]];
            for(TFHppleElement *e in banner){
                FilmModel *fm = [[FilmModel alloc]init];
                for(TFHppleElement *ec in e.children){
                    
                    if([self.dataParser[@"A03"] isEqualToString:ec.tagName]){
                        for(TFHppleElement *en in ec.children){
                            if([self.dataParser[@"A04"] isEqualToString:en.tagName]){
                                fm.FilmName = en.text;
                            }
                        }
                    }
                    if([self.dataParser[@"A05"] isEqualToString:ec.tagName]){
                        fm.filmURL = ec.attributes[self.dataParser[@"A06"]];
                        fm.filmID = [[[[fm.filmURL componentsSeparatedByString:@"."] firstObject] componentsSeparatedByString:@"-"] lastObject];
                        for(TFHppleElement *ei in ec.children){
                            if([self.dataParser[@"A07"] isEqualToString:ei.tagName]){
                                fm.filmBanner = ei.attributes[self.dataParser[@"A08"]];
                            }
                        }
                    }
                }
                [arrFilm addObject:fm];
            }
            if(banner.count != 0)
            {
                NSArray *arrG = [document searchWithXPathQuery:self.dataParser[@"A09"]];
                NSMutableArray *arrGroups = [NSMutableArray new];
                for(TFHppleElement *element in arrG){
                    TFHpple *hp = [[TFHpple alloc]initWithHTMLData:[element.raw dataUsingEncoding:NSUTF8StringEncoding]];
                    NSArray *div1 = [hp searchWithXPathQuery:self.dataParser[@"A10"]];
                    
                    NSMutableDictionary *gr = [NSMutableDictionary new];
                    NSString *hdogroup = @"";
                    for(TFHppleElement *gr_c in div1){
                        if([self.dataParser[@"A11"] isEqualToString:gr_c.tagName]){
                            for(TFHppleElement *gr_e1 in gr_c.children){
                                if([self.dataParser[@"A12"] isEqualToString:gr_e1.tagName]){
                                    for(TFHppleElement *ee in gr_e1.children){
                                        if([self.dataParser[@"A13"] isEqualToString:ee.tagName]){
                                            hdogroup = ee.attributes[self.dataParser[@"A25"]];
                                            [gr setObject:@[] forKey:ee.text];
                                            continue;
                                        }
                                    }
                                    continue;
                                }
                                if([self.dataParser[@"A14"] isEqualToString:gr_e1.tagName]){
                                    for(TFHppleElement *ee in gr_e1.children){
                                        [gr setObject:@[] forKey:ee.text];
                                        if([self.dataParser[@"A15"] isEqualToString:ee.tagName]){
                                            continue;
                                        }
                                    }
                                    continue;
                                }
                            }
                            continue;
                        }
                    }
                    
                    NSArray *div2 = [hp searchWithXPathQuery:self.dataParser[@"A16"]];
                    NSMutableArray *arrFilmInGroup = [NSMutableArray new];
                    for(TFHppleElement *gr_e in div2){
                        TFHpple *doc = [[TFHpple alloc]initWithHTMLData:[gr_e.raw dataUsingEncoding:NSUTF8StringEncoding]];
                        NSArray *arrSearch = [doc searchWithXPathQuery:self.dataParser[@"A17"]];
                        
                        for(TFHppleElement *e2 in arrSearch){
                            FilmModel *film = [[FilmModel alloc] init];
                            film.filmIncategory = hdogroup;
                            film.filmURL = e2.attributes[self.dataParser[@"A18"]];
                            film.filmID = [[[[film.filmURL componentsSeparatedByString:@"."] firstObject] componentsSeparatedByString:@"-"] lastObject];
                            for(TFHppleElement *e3 in e2.children){
                                if([self.dataParser[@"A19"] isEqualToString:e3.tagName]){
                                    if([self.dataParser[@"A20"] isEqualToString:e3.attributes[self.dataParser[@"A21"]]]){
                                        for(TFHppleElement *e4 in e3.children){
                                            if([self.dataParser[@"A22"] isEqualToString:e4.tagName]){
                                                film.filmImage = e4.attributes[self.dataParser[@"A23"]];
                                            }
                                        }
                                    }
                                }
                                if([self.dataParser[@"A24"] isEqualToString:e3.tagName]){
                                    film.FilmName = e3.text;
                                }
                            }
                            [arrFilmInGroup addObject:film];
                        }
                    }
                    
                    [gr setObject:arrFilmInGroup forKey:gr.allKeys.lastObject];
                    
                    [arrGroups addObject:gr];
                    
                    
                }
                
                
                
                NSArray *arrMenu = [document searchWithXPathQuery:self.dataParser[@"A36"]];
                NSMutableDictionary *dic = [NSMutableDictionary new];
                for(int i=0;i<arrMenu.count-1;i++){
                    TFHppleElement *e = arrMenu[i];
                    
                    NSString *gName = @"";
                    for(TFHppleElement *e1 in e.children){
                        
                        if([self.dataParser[@"A37"] isEqualToString:e1.tagName]){
                            gName = [[self stringByStrippingHTML:e1.raw] stringByStrippingWhitespace];
                        }
                        if([self.dataParser[@"A38"] isEqualToString:e1.tagName]){
                            TFHpple *doc2 = [[TFHpple alloc]initWithHTMLData:[e1.raw dataUsingEncoding:NSUTF8StringEncoding]];
                            NSArray *arr = [doc2 searchWithXPathQuery:self.dataParser[@"A39"]];
                            NSMutableArray *arrsubgroup = [NSMutableArray new];
                            for(TFHppleElement *e in arr){
                                NSString *url = e.attributes[self.dataParser[@"A40"]];
                                NSString *text = e.text;
                                if([url contains:@".html"]){
                                    [arrsubgroup addObject:@{@"url":url,@"text":text}];
                                }
                            }
                            [dic setObject:arrsubgroup forKey:gName];
                        }
                    }
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    done(TRUE,[arrFilm sortedArrayUsingComparator:^NSComparisonResult(FilmModel * obj1, FilmModel * obj2) {
                        return [obj1.filmID compare:obj2.filmID];
                    }],arrGroups,dic);
                    
                });
            }
            else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    done(false,nil,nil,nil);
                });
            }
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                done(false,nil,nil,nil);
            });
        }
        
    });
}

-(void)GetGroupWithUrl:(NSString *)grUrl Done:(void (^)(BOOL success,NSString *nextpage,NSArray *filmInpage))done{
    
    if(![grUrl contains:@"http"]){
        grUrl = [self.dataParser[@"A01"] stringByAppendingString:grUrl];
    }
    
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:grUrl]];
        [request setValue:self.dataParser[@"A72"] forHTTPHeaderField:self.dataParser[@"A73"]];
        [request setValue:self.dataParser[@"A95"] forHTTPHeaderField:self.dataParser[@"A74"]];
        NSData *xmlData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if(xmlData){
            TFHpple *doc = [[TFHpple alloc] initWithHTMLData:xmlData];
            NSArray *arr =  [doc searchWithXPathQuery:self.dataParser[@"A102"]];
            NSMutableArray *arrfilms = [NSMutableArray new];
            for(TFHppleElement *ex in arr){
                FilmModel *fm = [FilmModel new];
                
                for(TFHppleElement *e in ex.children){
                    if([self.dataParser[@"A98"] isEqualToString:e.tagName]){
                        fm.filmURL = e.attributes[self.dataParser[@"A27"]];
                        fm.filmID = [[[[fm.filmURL componentsSeparatedByString:@"."] firstObject] componentsSeparatedByString:@"-"] lastObject];
                        for(TFHppleElement *e1 in e.children){
                            if([self.dataParser[@"A28"] isEqualToString:e1.tagName]){
                                
                                if([self.dataParser[@"A29"] isEqualToString:e1.attributes[self.dataParser[@"A30"]]]){
                                    for(TFHppleElement *e2 in e1.children){
                                        if([e2.tagName isEqualToString:self.dataParser[@"A31"]]){
                                            fm.filmImage =e2.attributes[self.dataParser[@"A32"]];
                                            fm.FilmName = e2.attributes[self.dataParser[@"A33"]];
                                        }
                                    }
                                }
                            }
                        }
                    }
                    else if([self.dataParser[@"A99"] isEqualToString:e.tagName]){
                        for(TFHppleElement *e1 in e.children){
                            if([self.dataParser[@"A100"] isEqualToString:e1.tagName]){
                                if([e1.attributes[self.dataParser[@"A103"]] isEqualToString:self.dataParser[@"A101"]]){
                                    fm.engName = e1.text;
                                }
                                else if([e1.attributes[self.dataParser[@"A104"]] isEqualToString:self.dataParser[@"A101"]]){
                                    fm.FilmName = e1.text;
                                }
                                else if([e1.text contains:self.dataParser[@"A59"]]){
                                    fm.filmRate = [e1.text substringFrom:[self.dataParser[@"A59"] length] to:e1.text.length];
                                    fm.filmRate = [fm.filmRate stringByStrippingWhitespace];
                                }
                                else if([e1.text contains:self.dataParser[@"A105"]]){
                                    fm.filmTime = [e1.text substringFrom:[self.dataParser[@"A105"] length] to:e1.text.length];
                                    fm.filmTime = [fm.filmTime stringByStrippingWhitespace];
                                }
                                
                            }
                            else if([self.dataParser[@"A106"] isEqualToString:e1.tagName]){
                                if([e1.attributes[self.dataParser[@"A103"]] isEqualToString:self.dataParser[@"A107"]]){
                                    for(TFHppleElement *e2 in e1.children){
                                        if([e2.tagName isEqualToString:self.dataParser[@"A108"]]){
                                            fm.filmtype = [e2.text componentsSeparatedByString:@","];
                                        }
                                    }
                                }
                                else if([e1.attributes[self.dataParser[@"A103"]] isEqualToString:self.dataParser[@"A109"]]){
                                    fm.filmDescription = e1.text;
                                    fm.filmDescription = [fm.filmDescription stringByStrippingWhitespace];
                                    fm.filmDescription = [self stringByStrippingHTML:fm.filmDescription];
                                    
                                }
                            }
                            
                        }
                        
                    }
                }
                [arrfilms addObject:fm];
            }
            NSArray *arrNext = [doc searchWithXPathQuery:self.dataParser[@"A34"]];
            
            TFHppleElement *next = nil;
            if(arrNext.count!=0){
                next = arrNext.lastObject;
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                done(TRUE,next ? next.attributes[self.dataParser[@"A35"]] : @"",arrfilms);
            });
            
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                done(FALSE,nil,nil);
            });
        }
    });
    
}
-(void)LoadFilmInfoWithURL:(NSString *)url onComplete:(void (^)(BOOL success,FilmModel *fm))complete{
    if(![url contains:@"http"]){
        url = [self.dataParser[@"A01"] stringByAppendingString:url];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
        [request setValue:self.dataParser[@"A72"] forHTTPHeaderField:self.dataParser[@"A73"]];
        [request setValue:self.dataParser[@"A95"] forHTTPHeaderField:self.dataParser[@"A74"]];
        
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        if(data){
            NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            TFHpple *doc = [[TFHpple alloc]initWithHTMLData:data];
            
            FilmModel *f = [FilmModel new];
            NSArray *arr = [doc searchWithXPathQuery:self.dataParser[@"A42"]];
            f.filmURL = url;
            f.filmID = [[[[f.filmURL componentsSeparatedByString:@"."] firstObject] componentsSeparatedByString:@"-"] lastObject];
            if(arr.count == 1){
                TFHppleElement *e = arr.lastObject;
                f.FilmName = [self stringByStrippingHTML:e.raw];
                
            }
            
            // image
            
            NSArray *arrImage = [doc searchWithXPathQuery:self.dataParser[@"A43"]];
            if(arrImage.count==1){
                TFHppleElement *e = arrImage.lastObject;
                f.filmImage = e.attributes[self.dataParser[@"A44"]];
            }
            
            NSArray *arrThumnal = [doc searchWithXPathQuery:self.dataParser[@"A45"]];
            
            if(arrThumnal && arrThumnal.count!=0){
                NSMutableArray *arrt = [NSMutableArray new];
                for(TFHppleElement *e in arrThumnal){
                    [arrt addObject:e.attributes[self.dataParser[@"A46"]]];
                }
                f.filmScreenShots = arrt;
            }
            NSArray *arrInfo = [doc searchWithXPathQuery:self.dataParser[@"A47"]];
            if(arrInfo && arrInfo.count!=0){
                for(TFHppleElement *e in arrInfo){
                    NSString *ct = [e.text stringByStrippingWhitespace];
                    if([ct contains:self.dataParser[@"A48"]]){
                        for(TFHppleElement *e1 in e.children){
                            if([self.dataParser[@"A49"] isEqualToString:e1.tagName]){
                                f.engName = [e1.text stringByStrippingWhitespace];
                            }
                        }
                    }
                    if([ct contains:self.dataParser[@"A50"]]){
                        for(TFHppleElement *e1 in e.children){
                            if([self.dataParser[@"A51"] isEqualToString:e1.tagName]){
                                f.oginalName = [e1.text stringByStrippingWhitespace];
                                NSLog(@"%@",f.oginalName);
                            }
                        }
                    }
                    if([ct contains:self.dataParser[@"A52"]]){
                        NSMutableArray *TheLoai = [NSMutableArray new];
                        for(TFHppleElement *e1 in e.children){
                            if([self.dataParser[@"A53"] isEqualToString:e1.tagName]){
                                for(TFHppleElement *e2 in e1.children)
                                {
                                    if([self.dataParser[@"A54"] isEqualToString:e2.tagName]){
                                        [TheLoai addObject:[e2.text stringByStrippingWhitespace]];
                                    }
                                }
                                
                            }
                        }
                        f.filmtype = TheLoai;
                    }
                    if([ct contains:self.dataParser[@"A55"]]){
                        NSMutableArray *quocgia = [NSMutableArray new];
                        for(TFHppleElement *e1 in e.children){
                            if([self.dataParser[@"A56"] isEqualToString:e1.tagName]){
                                for(TFHppleElement *e2 in e1.children)
                                {
                                    if([self.dataParser[@"A57"] isEqualToString:e2.tagName]){
                                        [quocgia addObject:[e2.text stringByStrippingWhitespace]];
                                    }
                                }
                                
                            }
                        }
                        f.filmcountry = quocgia;
                    }
                    if([ct contains:self.dataParser[@"A58"]]){
                        f.filmTime = [ct substringFrom:[self.dataParser[@"A58"] length] to:ct.length];
                        f.filmTime = [f.filmTime stringByStrippingWhitespace];
                    }
                    if([ct contains:self.dataParser[@"A71"]]){
                        f.filmComplete = [ct substringFrom:[self.dataParser[@"A71"] length] to:ct.length];
                        f.filmComplete = [f.filmComplete stringByStrippingWhitespace];
                    }
                    if([ct contains:self.dataParser[@"A59"]]){
                        f.filmRate = [ct substringFrom:[self.dataParser[@"A59"] length] to:ct.length];
                        f.filmRate = [f.filmRate stringByStrippingWhitespace];
                    }
                    if([ct contains:self.dataParser[@"A60"]]){
                        f.filmQuantity = [ct substringFrom:[self.dataParser[@"A60"] length] to:ct.length];
                        f.filmQuantity = [f.filmQuantity stringByStrippingWhitespace];
                    }
                    if([ct contains:self.dataParser[@"A61"]]){
                        f.filmAudioQuantity = [ct substringFrom:[self.dataParser[@"A61"] length] to:ct.length];
                        f.filmAudioQuantity = [f.filmAudioQuantity stringByStrippingWhitespace];
                    }
                    if([ct contains:self.dataParser[@"A62"]]){
                        NSMutableArray *quocgia = [NSMutableArray new];
                        for(TFHppleElement *e1 in e.children){
                            if([self.dataParser[@"A63"] isEqualToString:e1.tagName]){
                                [quocgia addObject:[e1.text stringByStrippingWhitespace]];
                            }
                        }
                        f.filmDrector = quocgia;
                    }
                }
            }
            NSArray *arrFilmTrailer = [doc searchWithXPathQuery:self.dataParser[@"A64"]];
            if(arrFilmTrailer.count!=0){
                for(TFHppleElement *e in arrFilmTrailer){
                    f.filmtrailer =  [[[[e.raw componentsSeparatedByString:self.dataParser[@"A65"]] lastObject] componentsSeparatedByString:self.dataParser[@"A66"]] firstObject];
                }
            }
            NSArray *arrFilmDescription = [doc searchWithXPathQuery:self.dataParser[@"A67"]];
            if(arrFilmDescription.count!=0){
                for(TFHppleElement *e in arrFilmDescription){
                    for(TFHppleElement *e1 in e.children){
                        if([self.dataParser[@"A68"] isEqualToString:e1.tagName]){
                            f.filmDescription = e1.text;
                        }
                    }
                }
            }
            
            f.filmUUID = [[[[str componentsSeparatedByString:self.dataParser[@"A69"]] lastObject] componentsSeparatedByString:self.dataParser[@"A70"]] firstObject];
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(TRUE,f);
            });
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                complete(FALSE,nil);
            });
        }
        
    });
    
    
}

-(void)LoadFilmChapterWithUrl:(NSString *)url refLink:(NSString *)ref onComplete:(void (^)(BOOL success,NSArray *chaps))complete{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        [request setValue:self.dataParser[@"A72"] forHTTPHeaderField:self.dataParser[@"A73"]];
        [request setValue:self.dataParser[@"A95"] forHTTPHeaderField:self.dataParser[@"A74"]];
        [request setValue:ref forHTTPHeaderField:self.dataParser[@"A75"]];
        NSData *XMLdata = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *data = [NSDictionary dictionaryWithXMLData:XMLdata];
            if(data){
                
                NSMutableArray *listChapter = [[NSMutableArray alloc]init];
                if([data[self.dataParser[@"A76"]] isKindOfClass:[NSDictionary class]]){
                    if([data[self.dataParser[@"A76"]][self.dataParser[@"A77"]] isKindOfClass:[NSDictionary class]]){
                        NSDictionary *dicData = data[self.dataParser[@"A76"]][self.dataParser[@"A77"]];
                        listChapter = [[NSMutableArray alloc]init];
                        FilmChapter *chap = [[FilmChapter alloc]init];
                        chap.chapThumb = dicData[self.dataParser[@"A78"]];
                        chap.chapThumbBackup = dicData[self.dataParser[@"A79"]];
                        chap.chapName = dicData[self.dataParser[@"A80"]];
                        chap.chapFile = dicData[self.dataParser[@"A81"]];
                        chap.chapBackuplink = dicData[self.dataParser[@"A82"]];
                        chap.chapSubtitle = dicData[self.dataParser[@"A83"]];
                        chap.chapID = dicData[self.dataParser[@"A84"]];
                        chap.chapRef = [NSString stringWithFormat:@"%@%@",dicData[self.dataParser[@"A85"]],dicData[self.dataParser[@"A86"]]];
                        [listChapter addObject:chap];
                        complete(TRUE,listChapter);
                    }
                    else if([data[self.dataParser[@"A76"]][self.dataParser[@"A77"]] isKindOfClass:[NSArray class]])
                    {
                        listChapter = [[NSMutableArray alloc]init];
                        for(NSDictionary *dicData in data[self.dataParser[@"A76"]][self.dataParser[@"A77"]]){
                            
                            FilmChapter *chap = [[FilmChapter alloc]init];
                            chap.chapThumb = dicData[self.dataParser[@"A78"]];
                            chap.chapThumbBackup = dicData[self.dataParser[@"A79"]];
                            chap.chapName = dicData[self.dataParser[@"A80"]];
                            chap.chapFile = dicData[self.dataParser[@"A81"]];
                            chap.chapBackuplink = dicData[self.dataParser[@"A82"]];
                            chap.chapSubtitle = dicData[self.dataParser[@"A83"]];
                            chap.chapID = dicData[self.dataParser[@"A84"]];
                            chap.chapRef = [NSString stringWithFormat:@"%@%@",dicData[self.dataParser[@"A85"]],dicData[self.dataParser[@"A86"]]];
                            [listChapter addObject:chap];
                        }
                        complete(TRUE,listChapter);
                    }
                    else{
                        complete(FALSE,NULL);
                    }
                }
                else{
                    complete(FALSE,NULL);
                }
                
            }
            
            else{
                complete(FALSE,nil);
            }
        });
    });
}
-(void)LoadDirectLinkWithChap:(FilmChapter *)chap onComplete:(void (^)(BOOL success,PlayerItem *listDirectLink))complete
{
    [chap chapFileDecode:^(NSString * chapBackupDecode) {
        //if(StringData.rangeOfString("list.m3u8").location != NSNotFound){
        if([chapBackupDecode rangeOfString:self.dataParser[@"A87"]].location != NSNotFound){
            PlayerItem *linkItem = [[PlayerItem alloc]init];
            linkItem.file = chap.chapFile;
            linkItem.mediaid = chap.chapID;
            if(chap.chapSubtitle!=nil){
                linkItem.subfile = [chap.chapSubtitle componentsSeparatedByString:@","];
                if(linkItem.subfile != nil && linkItem.subfile.count !=0)
                {
                    NSMutableArray *arrList = [NSMutableArray new];
                    for(int i=0;i<linkItem.subfile.count;i++){
                        [arrList addObject:[NSString stringWithFormat:self.dataParser[@"A88"],i+1]];
                        
                    }
                    linkItem.sublabel = arrList;
                }
                
                
                
            }
            linkItem.title = chap.chapName;
            complete(TRUE,linkItem);
            
        }
        else{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:chapBackupDecode]];
                [request setValue:self.dataParser[@"A72"] forHTTPHeaderField:self.dataParser[@"A73"]];
                [request setValue:self.dataParser[@"A95"] forHTTPHeaderField:self.dataParser[@"A74"]];
                [request setValue:chap.chapRef forHTTPHeaderField:self.dataParser[@"A75"]];
                NSData *XMLdata = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if(XMLdata != nil){
                        NSDictionary *data = [NSDictionary dictionaryWithXMLData:XMLdata];
                        if(data != nil){
                            PlayerItem *linkItem = [[PlayerItem alloc]init];
                            linkItem.file = data[self.dataParser[@"A89"]][self.dataParser[@"A90"]][self.dataParser[@"A91"]];
                            linkItem.mediaid = data[self.dataParser[@"A89"]][self.dataParser[@"A90"]][self.dataParser[@"A92"]];
                            NSString *subfile = data[self.dataParser[@"A89"]][self.dataParser[@"A90"]][self.dataParser[@"A93"]];
                            if(subfile){
                                linkItem.subfile = [subfile componentsSeparatedByString:@","];
                            }
                            NSString *sublabel = data[self.dataParser[@"A89"]][self.dataParser[@"A90"]][self.dataParser[@"A94"]];
                            if(sublabel){
                                linkItem.sublabel = [sublabel componentsSeparatedByString:@","];
                            }
                            linkItem.title = chap.chapName;
                            
                            
                            complete(TRUE,linkItem);
                        }
                        else{
                            complete(FALSE,nil);
                        }
                    }
                    else{
                        complete(FALSE,nil);
                    }
                });
            });
        }
    }];
}
-(void)SearchFilmWithName:(NSString *)filmSearchtext onComplete:(void (^)(BOOL success,NSArray *listFilmSearch))complete{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *url = [NSString stringWithFormat:@"%@/%@/%@.html",self.dataParser[@"A01"],self.dataParser[@"A96"],filmSearchtext];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
        [request setValue:self.dataParser[@"A72"] forHTTPHeaderField:self.dataParser[@"A73"]];
        [request setValue:self.dataParser[@"A95"] forHTTPHeaderField:self.dataParser[@"A74"]];
        NSData *XMLdata = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        TFHpple *doc = [[TFHpple alloc]initWithHTMLData:XMLdata];
        NSArray *arrFilmSearch = [doc searchWithXPathQuery:self.dataParser[@"A102"]];
        NSMutableArray *arrfilms = [NSMutableArray new];
        for(TFHppleElement *ex in arrFilmSearch){
            FilmModel *fm = [FilmModel new];
            
            for(TFHppleElement *e in ex.children){
                if([self.dataParser[@"A98"] isEqualToString:e.tagName]){
                    fm.filmURL = e.attributes[self.dataParser[@"A27"]];
                    fm.filmID = [[[[fm.filmURL componentsSeparatedByString:@"."] firstObject] componentsSeparatedByString:@"-"] lastObject];
                    for(TFHppleElement *e1 in e.children){
                        if([self.dataParser[@"A28"] isEqualToString:e1.tagName]){
                            
                            if([self.dataParser[@"A29"] isEqualToString:e1.attributes[self.dataParser[@"A30"]]]){
                                for(TFHppleElement *e2 in e1.children){
                                    if([e2.tagName isEqualToString:self.dataParser[@"A31"]]){
                                        fm.filmImage =e2.attributes[self.dataParser[@"A32"]];
                                        fm.FilmName = e2.attributes[self.dataParser[@"A33"]];
                                    }
                                }
                            }
                        }
                    }
                }
                else if([self.dataParser[@"A99"] isEqualToString:e.tagName]){
                    for(TFHppleElement *e1 in e.children){
                        if([self.dataParser[@"A100"] isEqualToString:e1.tagName]){
                            if([e1.attributes[self.dataParser[@"A103"]] isEqualToString:self.dataParser[@"A101"]]){
                                fm.engName = e1.text;
                            }
                            else if([e1.attributes[self.dataParser[@"A104"]] isEqualToString:self.dataParser[@"A101"]]){
                                fm.FilmName = e1.text;
                            }
                            else if([e1.text contains:self.dataParser[@"A59"]]){
                                fm.filmRate = [e1.text substringFrom:[self.dataParser[@"A59"] length] to:e1.text.length];
                                fm.filmRate = [fm.filmRate stringByStrippingWhitespace];
                            }
                            else if([e1.text contains:self.dataParser[@"A105"]]){
                                fm.filmTime = [e1.text substringFrom:[self.dataParser[@"A105"] length] to:e1.text.length];
                                fm.filmTime = [fm.filmTime stringByStrippingWhitespace];
                            }
                            
                        }
                        else if([self.dataParser[@"A106"] isEqualToString:e1.tagName]){
                            if([e1.attributes[self.dataParser[@"A103"]] isEqualToString:self.dataParser[@"A107"]]){
                                for(TFHppleElement *e2 in e1.children){
                                    if([e2.tagName isEqualToString:self.dataParser[@"A108"]]){
                                        fm.filmtype = [e2.text componentsSeparatedByString:@","];
                                    }
                                }
                            }
                            else if([e1.attributes[self.dataParser[@"A103"]] isEqualToString:self.dataParser[@"A109"]]){
                                fm.filmDescription = e1.text;
                                fm.filmDescription = [fm.filmDescription stringByStrippingWhitespace];
                                fm.filmDescription = [self stringByStrippingHTML:fm.filmDescription];
                                
                            }
                        }
                        
                    }
                    
                }
            }
            [arrfilms addObject:fm];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            complete(arrfilms.count != 0 ? TRUE : FALSE, arrfilms.count != 0 ? arrfilms : nil);
        });
    });
}
-(void)SearchFilmMovieWithName:(NSString *)filmSearchtext onComplete:(void (^)(BOOL, NSArray *))complete{
    filmSearchtext = [filmSearchtext stringByReplacingOccurrencesOfString:@":" withString:@""];
    filmSearchtext = [filmSearchtext stringByReplacingOccurrencesOfString:@" " withString:@"-"];
    [self SearchFilmWithName:filmSearchtext onComplete:^(BOOL success, NSArray *listFilmSearch) {
        if(success){
            FilmModel *m = listFilmSearch.firstObject;
            [self LoadFilmInfoWithURL:m.filmURL onComplete:^(BOOL success, FilmModel *fm) {
                if(success){
                    [self LoadFilmChapterWithUrl:[NSString stringWithFormat:@"http://hdonline.vn/episode/vxml?film=%@",fm.filmUUID] refLink:fm.filmURL onComplete:^(BOOL success, NSArray *chaps) {
                        if(success){
                            complete(TRUE,chaps);
                        }
                        else{
                            complete(FALSE,nil);
                        }
                    }];
                }
                else{
                    complete(FALSE,nil);
                }
            }];
        }
        else{
            complete(FALSE,nil);
        }
    }];
}

@end
