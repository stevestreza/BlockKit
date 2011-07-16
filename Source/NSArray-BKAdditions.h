//
//  NSArray-BKAdditions.h
//  BlockKit
//
//  Created by Square Two on 10/26/09.
//

#import <Foundation/Foundation.h>


@interface NSArray (BKAdditions)

- (NSArray *)objectsPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (NSArray *)filteredArray:(BOOL (^)(id obj, NSUInteger idx))predicate;
- (NSArray *)map:(id (^)(id obj, NSUInteger idx))block;

@end


@interface NSMutableArray (BKAdditions)

- (void)filter:(BOOL (^)(id obj, NSUInteger idx))predicate;

@end
