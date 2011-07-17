//
//  UIControl-BKAdditions.h
//  BlockKit
//
//  Created by Nick Paulson on 7/16/11.
//

#import <UIKit/UIKit.h>
#import "BKTypes.h"


@interface UIControl (BKAdditions)

- (void)addActionForControlEvents:(UIControlEvents)controlEvents usingBlock:(BKVoidBlock)block;
- (void)removeAllActionBlocks;

@end
