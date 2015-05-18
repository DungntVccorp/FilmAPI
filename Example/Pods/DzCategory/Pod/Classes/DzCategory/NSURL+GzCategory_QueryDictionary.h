//
//  NSURL+GzCategory_QueryDictionary.h
//  GzoneLib
//
//  Created by Nguyen Dung on 08/01/2015.
//  Copyright (c) Năm 2015 dungnt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (GzCategory_QueryDictionary)
- (NSDictionary*) gz_queryDictionary;

/**
 *  @return URL with keys values appending to query string
 *  @param queryDictionary Query keys/values
 *  @param sortedKeys Sorted the keys alphabetically?
 *  @warning If keys overlap in receiver and query dictionary,
 *  behaviour is undefined.
 */
- (NSURL*) gz_URLByAppendingQueryDictionary:(NSDictionary*) queryDictionary
                             withSortedKeys:(BOOL) sortedKeys;

/** As above, but `sortedKeys=NO` */
- (NSURL*) gz_URLByAppendingQueryDictionary:(NSDictionary*) queryDictionary;

@end

#pragma mark -

@interface NSString (gz_URLQuery)

/**
 *  @return If the receiver is a valid URL query component, returns
 *  components as key/value pairs. If couldn't split into *any* pairs,
 *  returns nil.
 */
- (NSDictionary*) gz_URLQueryDictionary;

@end

#pragma mark -

@interface NSDictionary (gz_URLQuery)

/**
 *  @return URL query string component created from the keys and values in
 *  the dictionary. Returns nil for an empty dictionary.
 *  @param sortedKeys Sorted the keys alphabetically?
 *  @see cavetas from the main `NSURL` category as well.
 */
- (NSString*) gz_URLQueryStringWithSortedKeys:(BOOL) sortedKeys;

/** As above, but `sortedKeys=NO` */
- (NSString*) gz_URLQueryString;
@end
