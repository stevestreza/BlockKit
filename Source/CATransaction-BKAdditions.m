//
//  CATransaction-BKAdditions.m
//  BlockKit
//
//  Created by Mike Lewis on 3/23/11.
//

#import "CATransaction-BKAdditions.h"


@implementation CATransaction (BKAdditions)

#pragma mark Static Methods

+ (void)transactionUsingBlock:(BKVoidBlock)transactionBlock;
{
    [CATransaction begin];
    
    if (transactionBlock) {
        transactionBlock();
    }
    
    [CATransaction commit];
}

+ (void)transactionUsingBlock:(BKVoidBlock)transactionBlock completionBlock:(BKVoidBlock)completionBlock;
{
    [CATransaction begin];
    
    [CATransaction setCompletionBlock:completionBlock];
    if (transactionBlock) {
        transactionBlock();
    }
    
    [CATransaction commit];
}

@end
