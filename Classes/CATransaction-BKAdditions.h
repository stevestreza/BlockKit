//
//  CATransaction-BKAdditions.h
//  BlockKit
//
//  Created by Mike Lewis on 3/23/11.
//

#import <QuartzCore/QuartzCore.h>
#import "BKTypes.h"


@interface CATransaction (BKAdditions)

+ (void)transactionUsingBlock:(BKVoidBlock)transactionBlock;
+ (void)transactionUsingBlock:(BKVoidBlock)transactionBlock completionBlock:(BKVoidBlock)completionBlock;

@end

