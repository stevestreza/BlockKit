//
//  NSString-BKAdditions.m
//  BlockPlayground
//
//  Created by Nick Paulson on 7/16/11.
//  Copyright 2011 Linebreak. All rights reserved.
//

#import "NSString-BKAdditions.h"

@implementation NSString (BKAdditions)

- (void)enumerateLinesUsingBlock:(BKStringBlock)lineBlock;
{
    NSArray *lines = [self componentsSeparatedByString:@"\n"];
    for (NSString *currLine in lines) {
        lineBlock(currLine);
    }
}

@end
