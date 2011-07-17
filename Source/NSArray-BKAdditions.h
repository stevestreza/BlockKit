//
//  NSArray-BKAdditions.h
//  BlockKit
//
//  Created by Square Two on 10/26/09.
//

#import <Foundation/Foundation.h>


@interface NSArray (BKAdditions)

+ (void)iterateFrom:(NSInteger)begin upTo:(NSInteger)end usingBlock:(void (^)(NSInteger value))block;
+ (void)iterateFrom:(NSInteger)begin downTo:(NSInteger)end usingBlock:(void (^)(NSInteger value))block;
+ (void)iterateTimes:(NSUInteger)times usingBlock:(void (^)(NSUInteger value))block;

- (NSArray *)objectsPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
- (NSArray *)filteredArray:(BOOL (^)(id obj, NSUInteger idx))predicate;
- (NSArray *)arrayWithMap:(id (^)(id obj, NSUInteger idx))block;

@end


@interface NSMutableArray (BKAdditions)

- (void)filter:(BOOL (^)(id obj, NSUInteger idx))predicate;

@end
