//
//  NSArray-BKAdditions.m
//  BlockKit
//
//  Created by Square Two on 10/26/09.
//

#import "NSArray-BKAdditions.h"


@implementation NSArray (BKAdditions)

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

- (NSArray *)map:(id (^)(id obj, NSUInteger idx))block;
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
