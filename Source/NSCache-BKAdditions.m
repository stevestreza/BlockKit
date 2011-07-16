//
//  NSCache-BKAdditions.m
//  BlockKit
//
//  Created by Tristan O'Tierney on 6/28/11.
//

#import "NSCache-BKAdditions.h"


@implementation NSCache (BKAdditions)

#pragma mark Static Methods

+ (NSCache *)sharedCache;
{
    static NSCache *sharedCache = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCache = [[NSCache alloc] init];
    });
        
    return sharedCache;
}

+ (id)sharedObjectForKey:(id)key withCacheBlock:(BKCacheBlock)cacheBlock;
{
    return [[self sharedCache] objectForKey:key withCacheBlock:cacheBlock];
}

#pragma mark Public Methods

- (id)objectForKey:(id)key withCacheBlock:(BKCacheBlock)cacheBlock;
{
    id cached = [self objectForKey:key];
    
    if (!cached && cacheBlock) {
        cached = cacheBlock();
        [self setObject:cached forKey:key];
    }
    
    return cached;
}

@end
