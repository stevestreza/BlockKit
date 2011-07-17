//
//  NSEnumerator-BKAdditions.m
//  BlockKit
//
//  Created by Tristan O'Tierney on 7/16/11.
//

#import "NSEnumerator-BKAdditions.h"


@implementation NSEnumerator (BKAdditions)

- (void)enumerateObjectsUsingBlock:(void (^)(id obj, BOOL *stop))block;
{
    if (!block) {
        return;
    }
    
    id object = nil;
    BOOL stop = NO;
    
    while (!stop && (object = [self nextObject])) {
        block(object, &stop);
    }
}

@end
