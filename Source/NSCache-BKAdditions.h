//
//  NSCache-BKAdditions.h
//  BlockKit
//
//  Created by Tristan O'Tierney on 6/28/11.
//

#import <Foundation/Foundation.h>
#import "BKTypes.h"


#define BKCachedMethod(method, object, key) \
+ (id)method { \
    id cached = [[NSCache sharedCache] objectForKey:key]; \
    id reference = object; \
    if (!cached && reference) { \
        cached = reference; \
        [[NSCache sharedCache] setObject:reference forKey:key]; \
    } \
    return cached; \
}


@interface NSCache (BKAdditions)

+ (NSCache *)sharedCache;
+ (id)sharedObjectForKey:(id)key withCacheBlock:(BKCacheBlock)cacheBlock;

- (id)objectForKey:(id)key withCacheBlock:(BKCacheBlock)cacheBlock;

@end
