//
//  UIView-BKAdditions.h
//  BlockKit
//
//  Created by Nick Paulson on 7/16/11.
//

#import <UIKit/UIKit.h>
#import "BKTypes.h"


@interface UIView (BKAdditions)

// Block based -drawRect:
// WARNING: One of these initializers must be used to use drawRectBlock.
- (id)initWithDrawRectBlock:(BKRectBlock)aDrawRectBlock;
- (id)initWithFrame:(CGRect)frame drawRectBlock:(BKRectBlock)aDrawRectBlock;

@property (nonatomic, copy) BKRectBlock drawRectBlock;
@property (nonatomic, copy) BKVoidBlock layoutSubviewsBlock;

@end
