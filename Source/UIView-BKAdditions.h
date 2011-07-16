//
//  UIView-BKAdditions.h
//  BlockPlayground
//
//  Created by Nick Paulson on 7/16/11.
//  Copyright 2011 Linebreak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (BKAdditions)

// Block based -drawRect:
// WARNING: -initWithDrawRectBlock: must be used to initialize
- (id)initWithDrawRectBlock:(void (^) (CGRect))aDrawRectBlock;
- (void)setDrawRectBlock:(void (^) (CGRect))newDrawRectBlock;
- (void (^) (CGRect))drawRectBlock;

@end
