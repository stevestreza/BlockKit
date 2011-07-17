//
//  NSString-BKAdditions.m
//  BlockPlayground
//
//  Created by Nick Paulson on 7/16/11.
//  Copyright 2011 Linebreak. All rights reserved.
//

#import "NSString-BKAdditions.h"

@implementation NSString (BKAdditions)

- (void)enumerateCharactersUsingBlock:(BKUniCharBlock)characterBlock;
{
    for (NSUInteger currentCharacterIndex = 0; currentCharacterIndex < self.length; currentCharacterIndex++) {
        char currentCharacter = [self characterAtIndex:currentCharacterIndex];
        characterBlock(currentCharacter);
    }
}

@end
