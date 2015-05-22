//
//  DzFilmAppDelegate.m
//  FilmAPI
//
//  Created by CocoaPods on 05/18/2015.
//  Copyright (c) 2014 DungntVccorp. All rights reserved.
//

#import "DzFilmAppDelegate.h"
#import "DzFilmAPI.h"
@implementation DzFilmAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    [[[FilmAPI sharedAPI] manager] GET:@"https://drive.google.com/uc?export=download&id=0B1nXpe6RRjNcX2dqNVgyZ3JWLXc" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *path = [FCFileManager pathForDocumentsDirectory];
        path = [path stringByAppendingString:@"/data.plist"];
        [operation.responseData writeToFile:path atomically:YES];
        [[FilmAPI sharedAPI] setDataParser:[NSDictionary dictionaryWithContentsOfFile:path]];
        [[FilmAPI sharedAPI] SearchFilmMovieWithName:@"Mad Max" onComplete:^(BOOL suc, NSArray *items) {
            for(FilmChapter *chap in items){
                NSLog(@"%@",[chap.chapFile decode]);
            }
        }];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"FAILURE");
        NSString *path = [FCFileManager pathForDocumentsDirectory];
        path = [path stringByAppendingString:@"/data.plist"];
        [[FilmAPI sharedAPI] setDataParser:[NSDictionary dictionaryWithContentsOfFile:path]];
    }];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
