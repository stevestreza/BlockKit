//
//  NSString-BKAdditions.h
//  BlockKit
//
//  Created by Nick Paulson on 7/16/11.
//

#import <Foundation/Foundation.h>
#import "BKTypes.h"


@interface NSString (BKAdditions)

- (void)enumerateCharactersUsingBlock:(BKUniCharBlock)characterBlock;
- (NSString *)getterMethodString;

@end
