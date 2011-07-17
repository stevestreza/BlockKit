//
//  NSString-BKAdditions.h
//  BlockPlayground
//
//  Created by Nick Paulson on 7/16/11.
//  Copyright 2011 Linebreak. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BKTypes.h"

@interface NSString (BKAdditions)

- (void)enumerateCharactersUsingBlock:(BKUniCharBlock)characterBlock;
- (NSString *)getterMethodString;

@end
