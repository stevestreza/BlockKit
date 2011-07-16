//
//  BKCoreGraphics.h
//  BlockKit
//
//  Created by Tristan O'Tierney on 3/8/09.
//

#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>
#import "BKTypes.h"


UIImage *BKImageWithContextBlock(CGSize size, CGFloat scale, BKContextBlock block);
void BKContextGStateBlock(CGContextRef context, BKVoidBlock block);
void BKContextTransparentLayerBlock(CGContextRef context, BKVoidBlock block);
