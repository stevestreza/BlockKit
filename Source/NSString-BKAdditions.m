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

- (NSString *)getterMethodString;
{
    NSMutableString *retString = [[self mutableCopy] autorelease];
    NSString *setConstant = @"set";
    if ([retString hasPrefix:setConstant]) {
        [retString deleteCharactersInRange:NSMakeRange(0, setConstant.length)];
    } else {
        return self;
    }
    
    if (retString.length > 0) {
        [retString replaceCharactersInRange:NSMakeRange(0, 1) withString:[[retString substringToIndex:1] lowercaseString]];
    }
    
    NSString *endSentinal = @":";
    if ([retString hasSuffix:endSentinal]) {
        [retString deleteCharactersInRange:NSMakeRange(retString.length - 1, endSentinal.length)];
    }
    
    return retString;
}

@end
