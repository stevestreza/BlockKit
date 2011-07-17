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
// WARNING: -initWithDrawRectBlock: must be used to initialize to use accessors
- (id)initWithDrawRectBlock:(BKRectBlock)aDrawRectBlock;

@property (nonatomic, copy) BKRectBlock drawRectBlock;
@property (nonatomic, copy) BKVoidBlock layoutSubviewsBlock;

@end
