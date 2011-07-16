//
//  UIView-BKAdditions.h
//  BlockPlayground
//
//  Created by Nick Paulson on 7/16/11.
//  Copyright 2011 Linebreak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BKTypes.h"

@interface UIView (BKAdditions)

// Block based -drawRect:
// WARNING: -initWithDrawRectBlock: must be used to initialize
- (id)initWithDrawRectBlock:(BKRectBlock)aDrawRectBlock;
- (void)setDrawRectBlock:(BKRectBlock)newDrawRectBlock;
- (BKRectBlock)drawRectBlock;

@end
