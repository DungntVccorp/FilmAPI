//
//  NSUserDefaults+GzCategory.h
//  GzoneLib
//
//  Created by Nguyen Dung on 08/01/2015.
//  Copyright (c) Năm 2015 dungnt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (GzCategory)
/* convenience method to save a given object for a given key */
+ (void)saveObject:(id)object forKey:(NSString *)key;

/* convenience method to return an object for a given key */
+ (id)retrieveObjectForKey:(NSString *)key;

/* convenience method to delete a value for a given key */
+ (void)deleteObjectForKey:(NSString *)key;
@end
