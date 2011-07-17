//
//  NSArray-BKAdditions.m
//  BlockKit
//
//  Created by Square Two on 10/26/09.
//

#import "NSArray-BKAdditions.h"


@implementation NSArray (BKAdditions)

#pragma mark Static Methods

+ (void)iterateFrom:(NSInteger)begin upTo:(NSInteger)end usingBlock:(void (^)(NSInteger value))block;
{
    if (begin > end || !block) {
        return;
    }
    
    for (NSInteger index = begin; index <= end; index++) {
        block(index);
    }
}

+ (void)iterateFrom:(NSInteger)begin downTo:(NSInteger)end usingBlock:(void (^)(NSInteger value))block;
{
    if (end > begin || !block) {
        return;
    }
    
    for (NSInteger index = begin; index >= end; index--) {
        block(index);
    }
}

+ (void)iterateTimes:(NSUInteger)times usingBlock:(void (^)(NSUInteger value))block;
{
    if (times == 0 || !block) {
        return;
    }
    
    for (NSUInteger index = 0; index < times; index++) {
        block(index);
    }
}

#pragma mark Public Methods

- (NSArray *)objectsPassingTest:(BOOL (^)(id obj, NSUInteger idx, BOOL *stop))predicate;
{
    return [self objectsAtIndexes:[self indexesOfObjectsPassingTest:predicate]];
}

- (NSArray *)filteredArray:(BOOL (^)(id obj, NSUInteger idx))predicate;
{
    return [self objectsPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
        return predicate(obj, idx);
    }];
}

- (NSArray *)arrayWithMap:(id (^)(id obj, NSUInteger idx))block;
{
    NSMutableArray *newArray = [NSMutableArray array];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        id objectWithBlockApplied = block(obj, idx);
        
        if (objectWithBlockApplied) {
            [newArray addObject:objectWithBlockApplied];
        }
    }];
    
    return newArray;
}

@end


@implementation NSMutableArray (CCAdditions)

#pragma mark Public Methods

- (void)filter:(BOOL (^)(id obj, NSUInteger idx))predicate;
{
    [self enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (!predicate(obj, idx)) {
            [self removeObjectAtIndex:idx];
        }
    }];
}

@end
