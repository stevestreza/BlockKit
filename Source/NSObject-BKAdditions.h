//
//  NSObject-BKAdditions.h
//  BlockKit
//
//  Created by Tristan O'Tierney on 2/13/09.
//  KVO block support by Andy Matuschak
//

#import <Foundation/Foundation.h>
#import "BKTypes.h"


@interface NSObject (BKAdditions)

- (void)performAfterDelay:(NSTimeInterval)delay usingBlock:(BKVoidBlock)block;
- (void)performOnMainThreadUsingBlock:(BKVoidBlock)block;

// These methods return an opaque identifier to manage removal
// using removeObserverWithIdentifier
- (id)addObserverForKeyPath:(NSString *)keyPath task:(BKTaskBlock)task;
- (id)addObserverForKeyPath:(NSString *)keyPath onQueue:(NSOperationQueue *)queue task:(BKTaskBlock)task;
- (void)removeObserverWithIdentifier:(id)identifier;

+ (void)swizzleInstanceSelector:(SEL)origSelector withNewSelector:(SEL)newSelector;
- (void *)associationKeyForPropertyName:(NSString *)propertyName;

@end
