//
//  UIImage-BKAdditions.m
//  BlockKit
//
//  Created by Tristan O'Tierney on 2/11/09.
//

#import "UIImage-BKAdditions.h"
#import "BKCoreGraphics.h"


@implementation UIImage (BKAdditions)

#pragma mark Static Methods

+ (UIImage *)imageWithSize:(CGSize)size scale:(CGFloat)scale block:(BKContextBlock)block;
{
    return BKImageWithContextBlock(size, scale, block);
}

@end
