//
//  NSObject-BKAdditions.m
//  BlockKit
//
//  Created by Tristan O'Tierney on 2/13/09.
//

#import "NSObject-BKAdditions.h"


@implementation NSObject (BKAdditions)

#pragma mark Public Methods

- (void)performAfterDelay:(NSTimeInterval)delay usingBlock:(BKVoidBlock)block;
{
    [self performSelector:@selector(_executeBlock:) withObject:[block copy] afterDelay:delay];
}

- (void)performOnMainThreadUsingBlock:(BKVoidBlock)block;
{
    [self performSelectorOnMainThread:@selector(_executeBlock:) withObject:[block copy] waitUntilDone:YES];
}

#pragma mark Private Methods

- (void)_executeBlock:(BKVoidBlock)block;
{
    if (block) {
        block();
        [block release];
    }
}

@end
